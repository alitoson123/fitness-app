import * as assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import type { Firestore } from 'firebase-admin/firestore';
import {
  ACCOUNT_DELETED_CANCEL_TYPE,
  DELETED_USER_NAME,
  USER_OWNED_DOCS,
  cleanupDeletedUser,
  planBookingCleanup,
} from '../src/utils/account_cleanup';

type Doc = Record<string, unknown>;

/** In-memory Firestore with just what cleanupDeletedUser uses. */
function fakeDb(seed: Record<string, Record<string, Doc>>) {
  const store: Record<string, Record<string, Doc>> = JSON.parse(JSON.stringify(seed));
  let autoId = 0;
  const ref = (c: string, id: string) => ({ c, id });
  const db = {
    collection: (c: string) => ({
      doc: (id?: string) => ref(c, id ?? `auto_${++autoId}`),
      where: (field: string, _op: string, value: unknown) => ({
        get: async () => ({
          docs: Object.entries(store[c] ?? {})
            .filter(([, d]) => d[field] === value)
            .map(([id, d]) => ({ id, ref: ref(c, id), data: () => d })),
        }),
      }),
    }),
    batch: () => {
      const ops: Array<() => void> = [];
      return {
        delete: (r: { c: string; id: string }) => ops.push(() => { delete store[r.c]?.[r.id]; }),
        set: (r: { c: string; id: string }, data: Doc) =>
          ops.push(() => { (store[r.c] ??= {})[r.id] = data; }),
        update: (r: { c: string; id: string }, data: Doc) =>
          ops.push(() => { Object.assign(store[r.c][r.id], data); }),
        commit: async () => ops.forEach((op) => op()),
      };
    },
  } as unknown as Firestore;
  return { db, store };
}

describe('planBookingCleanup', () => {
  it('anonymises and cancels an upcoming booking, notifying the other side', () => {
    const plan = planBookingCleanup('t1', { coachUid: 'c1', traineeUid: 't1', status: 'confirmed' });
    assert.equal(plan.update.traineeName, DELETED_USER_NAME);
    assert.equal(plan.update.traineePhotoUrl, '');
    assert.equal(plan.update.status, 'cancelled');
    assert.equal(plan.update.cancellationReason, 'account_deleted');
    assert.deepEqual(plan.notify, { recipientUid: 'c1', recipientRole: 'coach' });
  });

  it('only anonymises a finished booking (history kept, no notification)', () => {
    for (const status of ['completed', 'cancelled', 'rejected']) {
      const plan = planBookingCleanup('c1', { coachUid: 'c1', traineeUid: 't1', status });
      assert.equal(plan.update.coachName, DELETED_USER_NAME);
      assert.equal(plan.update.status, undefined);
      assert.equal(plan.notify, null);
    }
  });
});

describe('cleanupDeletedUser', () => {
  it('handles bookings, inbox, own docs and uploads', async () => {
    const { db, store } = fakeDb({
      bookings: {
        b1: { coachUid: 'c1', traineeUid: 'u1', traineeName: 'Ali', status: 'pending', date: '2099-01-02' },
        b2: { coachUid: 'c1', traineeUid: 'u1', traineeName: 'Ali', status: 'completed' },
        b3: { coachUid: 'c1', traineeUid: 'other', traineeName: 'Sara', status: 'pending' },
      },
      notifications: {
        n1: { recipientUid: 'u1', type: 'booking_approved' },
        n2: { recipientUid: 'c1', type: 'booking_new' },
      },
      users: { u1: { role: 'trainee' } },
      trainee_profiles: { u1: { name: 'Ali' } },
    });
    const prefixes: string[] = [];

    await cleanupDeletedUser(db, { deleteFiles: async ({ prefix }) => prefixes.push(prefix) }, 'u1');

    // Upcoming booking: cancelled + anonymised.
    assert.equal(store.bookings.b1.status, 'cancelled');
    assert.equal(store.bookings.b1.traineeName, DELETED_USER_NAME);
    // Past booking: kept, anonymised, status unchanged.
    assert.equal(store.bookings.b2.status, 'completed');
    assert.equal(store.bookings.b2.traineeName, DELETED_USER_NAME);
    // Someone else's booking: untouched.
    assert.equal(store.bookings.b3.traineeName, 'Sara');
    assert.equal(store.bookings.b3.status, 'pending');

    // Deleted user's inbox removed; others' kept; coach notified once.
    assert.equal(store.notifications.n1, undefined);
    assert.ok(store.notifications.n2);
    const notices = Object.values(store.notifications).filter((n) => n.type === ACCOUNT_DELETED_CANCEL_TYPE);
    assert.equal(notices.length, 1);
    assert.equal(notices[0].recipientUid, 'c1');
    assert.equal(notices[0].recipientRole, 'coach');
    assert.deepEqual(notices[0].data, { bookingId: 'b1' });
    assert.match(String(notices[0].bodyEn), /2099-01-02/);

    for (const c of USER_OWNED_DOCS) assert.equal(store[c]?.u1, undefined);
    assert.deepEqual(prefixes, [
      'avatars/u1_',
      'coach_avatars/u1.jpg',
      'trainee_avatars/u1.jpg',
      'coach_documents/u1_',
    ]);
  });
});
