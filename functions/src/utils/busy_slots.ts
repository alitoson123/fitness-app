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

const ACTIVE_MONTHLY_STATUSES = new Set(['pending', 'confirmed', 'reschedule_pending']);
const INACTIVE_SESSION_BOOKING_STATUSES = new Set(['rejected', 'cancelled']);

function str(val: unknown): string {
  return typeof val === 'string' ? val : '';
}

function addSlot(map: Map<string, Set<string>>, date: unknown, time: unknown, minDate: string): void {
  const d = str(date);
  const t = str(time);
  if (!d || !t || d < minDate) return;
  let set = map.get(d);
  if (!set) {
    set = new Set<string>();
    map.set(d, set);
  }
  set.add(t);
}

/**
 * @param bookings raw booking documents for ONE coach
 * @param minDate  dates before this `YYYY-MM-DD` are dropped (past days)
 */
export function computeBusySlots(
  bookings: Array<Record<string, unknown>>,
  minDate: string,
): BusySlotMap {
  const map = new Map<string, Set<string>>();

  for (const b of bookings) {
    const bookingType = str(b.bookingType) || 'session';
    const status = str(b.status);

    if (bookingType === 'session') {
      if (!INACTIVE_SESSION_BOOKING_STATUSES.has(status)) {
        addSlot(map, b.date, b.startTime, minDate);
      }
      if (status === 'reschedule_pending') {
        addSlot(map, b.proposedDate, b.proposedStartTime, minDate);
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
      addSlot(map, s.date, s.startTime, minDate);
      if (sessionStatus === 'reschedule_pending') {
        addSlot(map, s.proposedDate, s.proposedStartTime, minDate);
      }
    }
  }

  const result: BusySlotMap = {};
  for (const date of Array.from(map.keys()).sort()) {
    result[date] = Array.from(map.get(date)!).sort();
  }
  return result;
}

/** `YYYY-MM-DD` for yesterday (UTC) — keeps a one-day margin for time zones. */
export function busySlotsMinDate(now: Date = new Date()): string {
  const d = new Date(now.getTime() - 24 * 60 * 60 * 1000);
  return d.toISOString().slice(0, 10);
}
