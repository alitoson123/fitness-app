import * as assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import {
  BookingRequestError,
  MAX_OPEN_REQUESTS_PER_COACH,
  parseBookingRequest,
  planNewBooking,
  type BookingPlanContext,
  type BookingRequestInput,
} from '../src/utils/booking_request';
import { busyRangesFromIntervals, collectBusyIntervals } from '../src/utils/busy_slots';

// Friday 1 March 2030, 08:00 UTC.
const NOW = new Date('2030-03-01T08:00:00Z');

const coach = (over: Record<string, unknown> = {}): Record<string, unknown> => ({
  name: 'Sara',
  photoUrl: 'https://x/coach.png',
  verificationStatus: 'approved',
  sessionPriceUSD: 50,
  monthlyPriceUSD: 300,
  sessionDurationMinutes: 60,
  sports: ['football'],
  sportLocations: [{ sport: 'football', isOnline: true, locations: ['Club A'] }],
  ...over,
});

const input = (over: Partial<BookingRequestInput> = {}): BookingRequestInput => ({
  coachUid: 'coach1',
  bookingType: 'session',
  sport: 'football',
  isOnline: false,
  trainingLocation: 'Club A',
  notes: '',
  sessions: [{ date: '2030-03-02', startTime: '18:00' }],
  utcOffsetMinutes: 0,
  ...over,
});

const ctx = (over: Partial<BookingPlanContext> = {}): BookingPlanContext => ({
  traineeUid: 'trainee1',
  traineeUser: { role: 'trainee', status: 'active' },
  traineeProfile: { name: 'Ali', photoUrl: 'https://x/ali.png' },
  coachUser: { role: 'coach', status: 'active' },
  coachProfile: coach(),
  coachBookings: [],
  now: NOW,
  ...over,
});

function refused(fn: () => unknown, reason: string): BookingRequestError {
  try {
    fn();
  } catch (e) {
    assert.ok(e instanceof BookingRequestError, `expected BookingRequestError, got ${e}`);
    assert.equal(e.reason, reason);
    return e;
  }
  assert.fail(`expected refusal "${reason}"`);
}

const monthlyDates = (n: number) =>
  Array.from({ length: n }, (_, i) => ({
    date: `2030-03-${String(i + 2).padStart(2, '0')}`,
    startTime: '18:00',
  }));

describe('planNewBooking: a normal request', () => {
  it('builds the booking from the coach profile, not from the app', () => {
    const { booking } = planNewBooking(input({ notes: ' hi ' }), ctx());
    assert.equal(booking.price, 50);
    assert.equal(booking.status, 'pending');
    assert.equal(booking.endTime, '19:00');
    assert.equal(booking.coachName, 'Sara');
    assert.equal(booking.traineeName, 'Ali');
    assert.equal(booking.trainingLocation, 'Club A');
    assert.equal(booking.sessions, undefined);
  });

  it('reads prices stored as text', () => {
    const { booking } = planNewBooking(input(), ctx({ coachProfile: coach({ sessionPriceUSD: '45.5' }) }));
    assert.equal(booking.price, 45.5);
  });

  it('monthly: 8 sessions on different days, priced per month', () => {
    const { booking, intervals } = planNewBooking(
      input({ bookingType: 'monthly', sessions: monthlyDates(8).reverse() }),
      ctx(),
    );
    assert.equal(booking.price, 300);
    assert.equal(booking.durationMonths, 1);
    const sessions = booking.sessions as Array<Record<string, unknown>>;
    assert.equal(sessions.length, 8);
    assert.equal(sessions[0].date, '2030-03-02', 'sorted by date');
    assert.equal(sessions[0].id, 's_2030-03-02_18:00');
    assert.equal(booking.date, '2030-03-02');
    assert.equal(intervals.length, 8);
  });
});

describe('planNewBooking: double booking', () => {
  const existing = (over: Record<string, unknown>) => ({
    coachUid: 'coach1', traineeUid: 'other', bookingType: 'session',
    date: '2030-03-02', startTime: '18:00', endTime: '19:00', status: 'confirmed', ...over,
  });

  it('the same time is refused, with the clashing time', () => {
    const e = refused(() => planNewBooking(input(), ctx({ coachBookings: [existing({})] })), 'slot_taken');
    assert.deepEqual(e.conflict, { date: '2030-03-02', startTime: '18:00' });
  });

  it('an overlapping time is refused too (different start)', () => {
    refused(
      () => planNewBooking(
        input({ sessions: [{ date: '2030-03-02', startTime: '17:30' }] }),
        ctx({ coachBookings: [existing({})] }),
      ),
      'slot_taken',
    );
  });

  it('back-to-back is fine', () => {
    planNewBooking(
      input({ sessions: [{ date: '2030-03-02', startTime: '19:00' }] }),
      ctx({ coachBookings: [existing({})] }),
    );
  });

  it('a time someone has proposed in a reschedule is held', () => {
    refused(
      () => planNewBooking(input(), ctx({
        coachBookings: [existing({
          date: '2030-03-05', status: 'reschedule_pending',
          proposedDate: '2030-03-02', proposedStartTime: '18:00', proposedEndTime: '19:00',
        })],
      })),
      'slot_taken',
    );
  });

  it('cancelled and rejected bookings free their time', () => {
    planNewBooking(input(), ctx({
      coachBookings: [existing({ status: 'cancelled' }), existing({ status: 'rejected' })],
    }));
  });

  it('a monthly session clashing with another package is refused', () => {
    refused(
      () => planNewBooking(input(), ctx({
        coachBookings: [{
          coachUid: 'coach1', bookingType: 'monthly', status: 'pending', traineeUid: 'other',
          sessions: [{ date: '2030-03-02', startTime: '18:30', endTime: '19:30', status: 'scheduled' }],
        }],
      })),
      'slot_taken',
    );
  });
});

describe('planNewBooking: times', () => {
  it('not in the past', () => {
    refused(() => planNewBooking(input({ sessions: [{ date: '2030-02-28', startTime: '18:00' }] }), ctx()), 'in_past');
  });

  it('uses the trainee\'s clock: 17:00 local has passed at 17:30 local', () => {
    const late = { now: new Date('2030-03-01T14:30:00Z') }; // 17:30 in UTC+3
    refused(
      () => planNewBooking(input({ sessions: [{ date: '2030-03-01', startTime: '17:00' }], utcOffsetMinutes: 180 }), ctx(late)),
      'in_past',
    );
    planNewBooking(input({ sessions: [{ date: '2030-03-01', startTime: '18:00' }], utcOffsetMinutes: 180 }), ctx(late));
  });

  it('not more than a month ahead', () => {
    refused(() => planNewBooking(input({ sessions: [{ date: '2030-05-01', startTime: '18:00' }] }), ctx()), 'too_far_ahead');
  });

  it('within the coach\'s hours (default 17:00-21:00)', () => {
    refused(() => planNewBooking(input({ sessions: [{ date: '2030-03-02', startTime: '16:00' }] }), ctx()), 'outside_hours');
    refused(() => planNewBooking(input({ sessions: [{ date: '2030-03-02', startTime: '20:30' }] }), ctx()), 'outside_hours');
  });

  it('respects the weekly schedule (2 March 2030 is a Saturday)', () => {
    const closedSaturday = coach({
      weeklyAvailability: [{ day: 'saturday', isAvailable: false }],
    });
    refused(() => planNewBooking(input(), ctx({ coachProfile: closedSaturday })), 'outside_hours');

    const mornings = coach({
      weeklyAvailability: [{ day: 'saturday', isAvailable: true, fromHour: 8, fromMinute: 0, toHour: 12, toMinute: 0 }],
    });
    planNewBooking(input({ sessions: [{ date: '2030-03-02', startTime: '09:00' }] }), ctx({ coachProfile: mornings }));
  });
});

describe('planNewBooking: who and what', () => {
  it('only active trainees', () => {
    refused(() => planNewBooking(input(), ctx({ traineeUser: { role: 'coach' } })), 'not_a_trainee');
    refused(() => planNewBooking(input(), ctx({ traineeUser: { role: 'trainee', status: 'suspended' } })), 'not_a_trainee');
    refused(() => planNewBooking(input(), ctx({ traineeUser: undefined })), 'not_a_trainee');
  });

  it('only approved, active coaches; not yourself', () => {
    refused(() => planNewBooking(input(), ctx({ coachProfile: coach({ verificationStatus: 'pending' }) })), 'coach_unavailable');
    refused(() => planNewBooking(input(), ctx({ coachUser: { status: 'suspended' } })), 'coach_unavailable');
    refused(() => planNewBooking(input(), ctx({ coachProfile: undefined })), 'coach_unavailable');
    refused(() => planNewBooking(input({ coachUid: 'trainee1' }), ctx()), 'coach_unavailable');
  });

  it('no monthly package when the coach has no monthly price', () => {
    refused(
      () => planNewBooking(input({ bookingType: 'monthly', sessions: monthlyDates(8) }), ctx({ coachProfile: coach({ monthlyPriceUSD: 0 }) })),
      'monthly_not_offered',
    );
  });

  it('monthly must be exactly 8 sessions on different days', () => {
    refused(() => planNewBooking(input({ bookingType: 'monthly', sessions: monthlyDates(7) }), ctx()), 'invalid_request');
    const sameDay = [...monthlyDates(7), { date: '2030-03-02', startTime: '20:00' }];
    refused(() => planNewBooking(input({ bookingType: 'monthly', sessions: sameDay }), ctx()), 'invalid_request');
  });

  it('a single session is exactly one time', () => {
    refused(() => planNewBooking(input({ sessions: monthlyDates(2) }), ctx()), 'invalid_request');
  });

  it('sport and place must be ones the coach offers', () => {
    refused(() => planNewBooking(input({ sport: 'tennis' }), ctx()), 'sport_not_offered');
    refused(() => planNewBooking(input({ trainingLocation: 'Somewhere' }), ctx()), 'location_not_offered');
    const inPersonOnly = coach({ sportLocations: [{ sport: 'football', isOnline: false, locations: ['Club A'] }] });
    refused(() => planNewBooking(input({ isOnline: true }), ctx({ coachProfile: inPersonOnly })), 'location_not_offered');
    planNewBooking(input({ isOnline: true, trainingLocation: '' }), ctx());
  });
});

describe('planNewBooking: open request limit', () => {
  const pending = (date: string) => ({
    coachUid: 'coach1', traineeUid: 'trainee1', bookingType: 'session',
    date, startTime: '17:00', endTime: '18:00', status: 'pending',
  });

  it(`at most ${MAX_OPEN_REQUESTS_PER_COACH} unanswered requests with one coach`, () => {
    const three = [pending('2030-03-03'), pending('2030-03-04'), pending('2030-03-05')];
    refused(() => planNewBooking(input(), ctx({ coachBookings: three })), 'too_many_requests');
  });

  it('expired and answered requests do not count', () => {
    planNewBooking(input(), ctx({
      coachBookings: [
        pending('2030-02-20'), // its time passed without an answer
        { ...pending('2030-03-03'), status: 'confirmed' },
        pending('2030-03-04'),
        pending('2030-03-05'),
      ],
    }));
  });
});

describe('parseBookingRequest', () => {
  const valid = {
    coachUid: 'c', bookingType: 'session', sport: 'football', isOnline: true,
    sessions: [{ date: '2030-03-02', startTime: '18:00' }], utcOffsetMinutes: 180,
  };

  it('accepts a valid request', () => {
    const r = parseBookingRequest(valid);
    assert.equal(r.utcOffsetMinutes, 180);
    assert.equal(r.trainingLocation, '');
  });

  it('refuses malformed input', () => {
    for (const bad of [
      null,
      { ...valid, coachUid: '' },
      { ...valid, bookingType: 'yearly' },
      { ...valid, isOnline: 'yes' },
      { ...valid, sessions: [] },
      { ...valid, sessions: [{ date: '2030-02-30', startTime: '18:00' }] },
      { ...valid, sessions: [{ date: '2030-03-02', startTime: '25:00' }] },
    ]) {
      refused(() => parseBookingRequest(bad), 'invalid_request');
    }
  });

  it('ignores an impossible time-zone offset', () => {
    assert.equal(parseBookingRequest({ ...valid, utcOffsetMinutes: 5000 }).utcOffsetMinutes, 0);
  });
});

describe('busy ranges', () => {
  it('lists start-end ranges per day for the app', () => {
    const intervals = collectBusyIntervals([
      { bookingType: 'session', status: 'confirmed', date: '2030-03-02', startTime: '18:00', endTime: '19:30' },
      { bookingType: 'session', status: 'pending', date: '2030-03-02', startTime: '17:00' }, // no end: 60 min
    ], '2030-01-01');
    assert.deepEqual(busyRangesFromIntervals(intervals), { '2030-03-02': ['17:00-18:00', '18:00-19:30'] });
  });
});
