/**
 * Server-side validation of a new booking request (used by the
 * `createBooking` callable). The app only says WHAT the trainee wants;
 * everything that matters (price, names, end times, status) is decided here
 * from the coach's real profile, and the requested times are checked
 * against the coach's hours and existing bookings.
 */
import {
  busySlotsMinDate,
  collectBusyIntervals,
  fromMinutes,
  isIsoDate,
  overlapsAny,
  toMinutes,
  type BusyInterval,
} from './busy_slots';

/** Must match `BookingRequestState.requiredMonthlySessions` in the app. */
export const MONTHLY_SESSIONS_REQUIRED = 8;
/** Unanswered requests one trainee may have open with the same coach. */
export const MAX_OPEN_REQUESTS_PER_COACH = 3;
/** The app offers today + 29 days; one day of slack for time zones. */
export const BOOKING_WINDOW_DAYS = 31;

const DEFAULT_FROM = 17 * 60;
const DEFAULT_TO = 21 * 60;
const DAY_NAMES = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

export type BookingRequestErrorReason =
  | 'invalid_request'
  | 'not_a_trainee'
  | 'coach_unavailable'
  | 'monthly_not_offered'
  | 'sport_not_offered'
  | 'location_not_offered'
  | 'in_past'
  | 'too_far_ahead'
  | 'outside_hours'
  | 'slot_taken'
  | 'too_many_requests';

export class BookingRequestError extends Error {
  constructor(
    readonly reason: BookingRequestErrorReason,
    readonly conflict?: { date: string; startTime: string },
  ) {
    super(reason);
  }
}

export interface RequestedSession {
  date: string;
  startTime: string;
}

export interface BookingRequestInput {
  coachUid: string;
  bookingType: 'session' | 'monthly';
  sport: string;
  isOnline: boolean;
  trainingLocation: string;
  notes: string;
  sessions: RequestedSession[];
  /** The trainee device's offset from UTC; booking times are wall-clock. */
  utcOffsetMinutes: number;
}

export interface BookingPlanContext {
  traineeUid: string;
  traineeUser?: Record<string, unknown>;
  traineeProfile?: Record<string, unknown>;
  coachUser?: Record<string, unknown>;
  coachProfile?: Record<string, unknown>;
  /** All booking documents of the coach (read inside the transaction). */
  coachBookings: Array<Record<string, unknown>>;
  now: Date;
}

export interface BookingPlan {
  /** The booking document, without `id`/`createdAt`/`updatedAt`. */
  booking: Record<string, unknown>;
  /** The coach's busy periods including the new booking. */
  intervals: BusyInterval[];
}

const fail = (reason: BookingRequestErrorReason, conflict?: RequestedSession): never => {
  throw new BookingRequestError(reason, conflict);
};

function str(val: unknown, max = 200): string {
  return typeof val === 'string' ? val.trim().slice(0, max) : '';
}

/** Validates the shape of the callable's input. */
export function parseBookingRequest(data: unknown): BookingRequestInput {
  if (!data || typeof data !== 'object') return fail('invalid_request');
  const d = data as Record<string, unknown>;

  const coachUid = str(d.coachUid, 128);
  const bookingType = d.bookingType;
  const sport = str(d.sport, 100);
  if (!coachUid || !sport) fail('invalid_request');
  if (bookingType !== 'session' && bookingType !== 'monthly') fail('invalid_request');
  if (typeof d.isOnline !== 'boolean') fail('invalid_request');

  const offset = typeof d.utcOffsetMinutes === 'number' && Number.isFinite(d.utcOffsetMinutes)
    ? Math.round(d.utcOffsetMinutes)
    : 0;

  if (!Array.isArray(d.sessions) || d.sessions.length === 0 || d.sessions.length > 31) {
    fail('invalid_request');
  }
  const sessions = (d.sessions as unknown[]).map((raw) => {
    const s = (raw && typeof raw === 'object' ? raw : {}) as Record<string, unknown>;
    const date = str(s.date, 10);
    const startTime = str(s.startTime, 5);
    if (!isIsoDate(date) || toMinutes(startTime) === null) fail('invalid_request');
    return { date, startTime };
  });

  return {
    coachUid,
    bookingType: bookingType as 'session' | 'monthly',
    sport,
    isOnline: d.isOnline as boolean,
    trainingLocation: str(d.trainingLocation, 200),
    notes: str(d.notes, 1000),
    sessions,
    // Real offsets are within +-14h; anything else is ignored.
    utcOffsetMinutes: Math.abs(offset) <= 14 * 60 ? offset : 0,
  };
}

/** Prices may be stored as numbers or numeric strings. */
export function parsePrice(val: unknown): number {
  const n = typeof val === 'number' ? val : typeof val === 'string' ? Number(val.trim()) : NaN;
  return Number.isFinite(n) && n > 0 ? n : 0;
}

/** Wall-clock `date` + `time` as a comparable number (ms, as if UTC). */
function wallClock(date: string, minutes: number): number {
  const [y, m, d] = date.split('-').map(Number);
  return Date.UTC(y, m - 1, d) + minutes * 60_000;
}

function addDays(date: string, days: number): string {
  const [y, m, d] = date.split('-').map(Number);
  return new Date(Date.UTC(y, m - 1, d + days)).toISOString().slice(0, 10);
}

/** The coach's open hours on [date] (wall clock), or null when closed. */
export function coachHoursOn(
  coach: Record<string, unknown>,
  date: string,
): { from: number; to: number } | null {
  const [y, m, d] = date.split('-').map(Number);
  const dayName = DAY_NAMES[new Date(Date.UTC(y, m - 1, d)).getUTCDay()];

  const weekly = Array.isArray(coach.weeklyAvailability) ? coach.weeklyAvailability : [];
  const entry = weekly.find(
    (e): e is Record<string, unknown> =>
      !!e && typeof e === 'object' && (e as Record<string, unknown>).day === dayName,
  );
  if (entry) {
    if (entry.isAvailable !== true) return null;
    const num = (v: unknown, def: number) => (typeof v === 'number' ? v : def);
    return {
      from: num(entry.fromHour, 17) * 60 + num(entry.fromMinute, 0),
      to: num(entry.toHour, 21) * 60 + num(entry.toMinute, 0),
    };
  }

  const workingDays = Array.isArray(coach.workingDays) ? coach.workingDays : [];
  if (workingDays.length > 0 &&
      !workingDays.some((w) => typeof w === 'string' && w.toLowerCase() === dayName)) {
    return null;
  }
  return { from: DEFAULT_FROM, to: DEFAULT_TO };
}

/** Same fallback as the app: no location settings means online only. */
function deliveryAllowed(coach: Record<string, unknown>, input: BookingRequestInput): boolean {
  const list = Array.isArray(coach.sportLocations) ? coach.sportLocations : [];
  const config = list.find(
    (c): c is Record<string, unknown> =>
      !!c && typeof c === 'object' && (c as Record<string, unknown>).sport === input.sport,
  );
  if (!config) return input.isOnline;
  if (input.isOnline) return config.isOnline === true;
  const locations = Array.isArray(config.locations) ? config.locations : [];
  return input.trainingLocation !== '' && locations.includes(input.trainingLocation);
}

/** Latest start of an existing booking (booked or proposed), wall clock. */
function latestStart(b: Record<string, unknown>): number | null {
  const starts: Array<[unknown, unknown]> = [];
  if (b.bookingType === 'monthly' && Array.isArray(b.sessions)) {
    for (const s of b.sessions as Array<Record<string, unknown>>) {
      starts.push([s?.date, s?.startTime], [s?.proposedDate, s?.proposedStartTime]);
    }
  } else {
    starts.push([b.date, b.startTime], [b.proposedDate, b.proposedStartTime]);
  }
  let latest: number | null = null;
  for (const [date, time] of starts) {
    const min = toMinutes(time);
    if (!isIsoDate(date) || min === null) continue;
    const t = wallClock(date, min);
    if (latest === null || t > latest) latest = t;
  }
  return latest;
}

/** A request the coach hasn't answered yet and whose time hasn't passed. */
export function isOpenRequest(b: Record<string, unknown>, nowWall: number): boolean {
  const neverApproved = b.status === 'pending' ||
    (b.status === 'reschedule_pending' && b.statusBeforeReschedule === 'pending');
  if (!neverApproved) return false;
  const latest = latestStart(b);
  return latest !== null && latest > nowWall;
}

export function planNewBooking(input: BookingRequestInput, ctx: BookingPlanContext): BookingPlan {
  // Who is asking, and is the coach bookable?
  const user = ctx.traineeUser;
  if (!user || user.role !== 'trainee' || user.status === 'suspended') fail('not_a_trainee');

  const coach = ctx.coachProfile;
  if (!coach ||
      input.coachUid === ctx.traineeUid ||
      coach.verificationStatus !== 'approved' ||
      ctx.coachUser?.status === 'suspended') {
    return fail('coach_unavailable');
  }

  const isMonthly = input.bookingType === 'monthly';
  const unitPrice = parsePrice(isMonthly ? coach.monthlyPriceUSD : coach.sessionPriceUSD);
  if (unitPrice <= 0) fail(isMonthly ? 'monthly_not_offered' : 'coach_unavailable');

  const sports = Array.isArray(coach.sports) ? coach.sports : [];
  if (sports.length > 0 && !sports.includes(input.sport)) fail('sport_not_offered');
  if (!deliveryAllowed(coach, input)) fail('location_not_offered');

  // Shape of the package.
  if (isMonthly) {
    if (input.sessions.length !== MONTHLY_SESSIONS_REQUIRED) fail('invalid_request');
    if (new Set(input.sessions.map((s) => s.date)).size !== input.sessions.length) {
      fail('invalid_request');
    }
  } else if (input.sessions.length !== 1) {
    fail('invalid_request');
  }

  // Times: future, within the booking window and the coach's hours.
  const nowWall = ctx.now.getTime() + input.utcOffsetMinutes * 60_000;
  const today = new Date(nowWall).toISOString().slice(0, 10);
  const lastDay = addDays(today, BOOKING_WINDOW_DAYS);
  const rawDuration = coach.sessionDurationMinutes;
  const duration = typeof rawDuration === 'number' && rawDuration > 0 ? Math.round(rawDuration) : 60;

  const sessions = [...input.sessions].sort((a, b) =>
    a.date === b.date ? a.startTime.localeCompare(b.startTime) : a.date.localeCompare(b.date));
  const planned = sessions.map((s) => {
    const start = toMinutes(s.startTime)!;
    const end = start + duration;
    if (wallClock(s.date, start) <= nowWall) fail('in_past', s);
    if (s.date > lastDay) fail('too_far_ahead', s);
    const hours = coachHoursOn(coach, s.date);
    if (!hours || start < hours.from || end > hours.to) fail('outside_hours', s);
    return { ...s, start, end };
  });

  // Not too many unanswered requests with this coach.
  const open = ctx.coachBookings.filter(
    (b) => b.traineeUid === ctx.traineeUid && isOpenRequest(b, nowWall),
  ).length;
  if (open >= MAX_OPEN_REQUESTS_PER_COACH) fail('too_many_requests');

  // No overlap with anything the coach already has (or has been offered).
  const intervals = collectBusyIntervals(ctx.coachBookings, busySlotsMinDate(ctx.now));
  for (const p of planned) {
    if (overlapsAny(intervals, p.date, p.start, p.end)) {
      fail('slot_taken', { date: p.date, startTime: p.startTime });
    }
  }

  const first = planned[0];
  const traineeProfile = ctx.traineeProfile ?? {};
  const traineePhotoUrl = str(traineeProfile.photoUrl, 2000);
  const booking: Record<string, unknown> = {
    coachUid: input.coachUid,
    coachName: str(coach.name) || 'Coach',
    coachPhotoUrl: str(coach.photoUrl, 2000),
    traineeUid: ctx.traineeUid,
    traineeName: str(traineeProfile.name) || 'Trainee',
    ...(traineePhotoUrl ? { traineePhotoUrl } : {}),
    sport: input.sport,
    bookingType: input.bookingType,
    trainingLocation: input.isOnline ? 'Online' : input.trainingLocation,
    isOnline: input.isOnline,
    date: first.date,
    startTime: first.startTime,
    endTime: fromMinutes(first.end),
    price: unitPrice,
    currency: 'USD',
    ...(input.notes ? { notes: input.notes } : {}),
    status: 'pending',
  };
  if (isMonthly) {
    booking.durationMonths = 1;
    booking.sessions = planned.map((p) => ({
      id: `s_${p.date}_${p.startTime}`,
      date: p.date,
      startTime: p.startTime,
      endTime: fromMinutes(p.end),
      status: 'scheduled',
    }));
  }

  return {
    booking,
    intervals: [
      ...intervals,
      ...planned.map((p) => ({ date: p.date, start: p.start, end: Math.min(p.end, 1440) })),
    ],
  };
}
