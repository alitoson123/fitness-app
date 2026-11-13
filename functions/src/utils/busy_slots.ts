/**
 * Computes a coach's busy time slots from their bookings.
 *
 * This is the server-side port of the logic that used to run in the app
 * (`BookingRequestRemoteDataSource.getBookedSlots`). Moving it here lets the
 * app read only a public `coach_busy_slots/{coachUid}` document (dates and
 * start times, no personal data) instead of every booking of the coach.
 */

/** Map of `YYYY-MM-DD` -> sorted list of busy `HH:mm` start times. */
export type BusySlotMap = Record<string, string[]>;

/** Map of `YYYY-MM-DD` -> sorted list of busy `HH:mm-HH:mm` ranges. */
export type BusyRangeMap = Record<string, string[]>;

/** One busy period of a coach on one day, in minutes since midnight. */
export interface BusyInterval {
  date: string;
  start: number;
  end: number;
}

const ACTIVE_MONTHLY_STATUSES = new Set(['pending', 'confirmed', 'reschedule_pending']);
const INACTIVE_SESSION_BOOKING_STATUSES = new Set(['rejected', 'cancelled']);
const DEFAULT_DURATION_MIN = 60;

function str(val: unknown): string {
  return typeof val === 'string' ? val : '';
}

/** `HH:mm` -> minutes since midnight, or null. */
export function toMinutes(time: unknown): number | null {
  const m = /^(\d{1,2}):(\d{2})$/.exec(str(time));
  if (!m) return null;
  const h = Number(m[1]);
  const min = Number(m[2]);
  if (h > 23 || min > 59) return null;
  return h * 60 + min;
}

/** minutes since midnight -> `HH:mm` (wraps past midnight). */
export function fromMinutes(total: number): string {
  const t = ((total % 1440) + 1440) % 1440;
  const h = Math.floor(t / 60);
  const m = t % 60;
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
}

/** Valid `YYYY-MM-DD` (a real calendar day). */
export function isIsoDate(val: unknown): val is string {
  const d = str(val);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(d)) return false;
  const [y, m, day] = d.split('-').map(Number);
  const dt = new Date(Date.UTC(y, m - 1, day));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === day;
}

function pushInterval(
  out: BusyInterval[],
  date: unknown,
  startTime: unknown,
  endTime: unknown,
  fallbackDuration: number,
  minDate: string,
): void {
  const d = str(date);
  const start = toMinutes(startTime);
  if (!d || start === null || d < minDate) return;
  let end = toMinutes(endTime);
  // Missing end, or a session that runs past midnight: treat as running to
  // the end of the day it starts on (we only compare within one day).
  if (end === null) end = start + fallbackDuration;
  if (end <= start) end = Math.max(start + fallbackDuration, 1440);
  out.push({ date: d, start, end: Math.min(end, 1440) });
}

function durationOf(start: unknown, end: unknown): number {
  const s = toMinutes(start);
  const e = toMinutes(end);
  return s !== null && e !== null && e > s ? e - s : DEFAULT_DURATION_MIN;
}

/**
 * Every period a coach is taken: booked times of active bookings plus
 * times currently proposed in an open reschedule (held until answered).
 *
 * @param bookings raw booking documents for ONE coach
 * @param minDate  dates before this `YYYY-MM-DD` are dropped (past days)
 */
export function collectBusyIntervals(
  bookings: Array<Record<string, unknown>>,
  minDate: string,
): BusyInterval[] {
  const out: BusyInterval[] = [];

  for (const b of bookings) {
    const bookingType = str(b.bookingType) || 'session';
    const status = str(b.status);

    if (bookingType === 'session') {
      const dur = durationOf(b.startTime, b.endTime);
      if (!INACTIVE_SESSION_BOOKING_STATUSES.has(status)) {
        pushInterval(out, b.date, b.startTime, b.endTime, dur, minDate);
      }
      if (status === 'reschedule_pending') {
        pushInterval(out, b.proposedDate, b.proposedStartTime, b.proposedEndTime, dur, minDate);
      }
      continue;
    }

    if (bookingType !== 'monthly' || !ACTIVE_MONTHLY_STATUSES.has(status)) continue;
    if (!Array.isArray(b.sessions)) continue;

    for (const raw of b.sessions) {
      if (!raw || typeof raw !== 'object') continue;
      const s = raw as Record<string, unknown>;
      const sessionStatus = str(s.status) || 'scheduled';
      if (sessionStatus === 'cancelled') continue;
      const dur = durationOf(s.startTime, s.endTime);
      pushInterval(out, s.date, s.startTime, s.endTime, dur, minDate);
      if (sessionStatus === 'reschedule_pending') {
        pushInterval(out, s.proposedDate, s.proposedStartTime, s.proposedEndTime, dur, minDate);
      }
    }
  }
  return out;
}

/** True when [start, end) on [date] overlaps any of [intervals]. */
export function overlapsAny(
  intervals: BusyInterval[],
  date: string,
  start: number,
  end: number,
): boolean {
  return intervals.some((i) => i.date === date && start < i.end && i.start < end);
}

function group(intervals: BusyInterval[], label: (i: BusyInterval) => string): Record<string, string[]> {
  const map = new Map<string, Set<string>>();
  for (const i of intervals) {
    let set = map.get(i.date);
    if (!set) {
      set = new Set<string>();
      map.set(i.date, set);
    }
    set.add(label(i));
  }
  const result: Record<string, string[]> = {};
  for (const date of Array.from(map.keys()).sort()) {
    result[date] = Array.from(map.get(date)!).sort();
  }
  return result;
}

/** Busy start times per day (kept for app versions that only read these). */
export function computeBusySlots(
  bookings: Array<Record<string, unknown>>,
  minDate: string,
): BusySlotMap {
  return busySlotsFromIntervals(collectBusyIntervals(bookings, minDate));
}

export function busySlotsFromIntervals(intervals: BusyInterval[]): BusySlotMap {
  return group(intervals, (i) => fromMinutes(i.start));
}

/** Busy `HH:mm-HH:mm` ranges per day, so the app can detect overlaps. */
export function busyRangesFromIntervals(intervals: BusyInterval[]): BusyRangeMap {
  return group(intervals, (i) => `${fromMinutes(i.start)}-${i.end >= 1440 ? '24:00' : fromMinutes(i.end)}`);
}

/** `YYYY-MM-DD` for yesterday (UTC) — keeps a one-day margin for time zones. */
export function busySlotsMinDate(now: Date = new Date()): string {
  const d = new Date(now.getTime() - 24 * 60 * 60 * 1000);
  return d.toISOString().slice(0, 10);
}
