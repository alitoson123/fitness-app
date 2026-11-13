import { FieldValue, type Firestore, type DocumentReference } from 'firebase-admin/firestore';

/** Firestore docs keyed by the user's uid that belong only to that user. */
export const USER_OWNED_DOCS = [
  'users',
  'coach_profiles',
  'trainee_profiles',
  'coach_verifications',
  'fcm_tokens',
  'coach_busy_slots',
] as const;

/** Booking statuses that are still "upcoming" and get cancelled. */
export const ACTIVE_BOOKING_STATUSES = new Set(['pending', 'confirmed', 'reschedule_pending']);

export const DELETED_USER_NAME = 'Deleted user';

/** Server-only notification type (clients can't create it, see firestore.rules). */
export const ACCOUNT_DELETED_CANCEL_TYPE = 'booking_cancelled_account_deleted';

/** Storage prefixes holding the user's uploads (see storage.rules). */
export function userStoragePrefixes(uid: string): string[] {
  return [
    `avatars/${uid}_`,
    `coach_avatars/${uid}.jpg`,
    `trainee_avatars/${uid}.jpg`,
    `coach_documents/${uid}_`,
  ];
}

/** Minimal bucket surface so tests can pass a fake. */
export interface CleanupBucket {
  deleteFiles(options: { prefix: string; force?: boolean }): Promise<unknown>;
}

type Write =
  | { kind: 'update'; ref: DocumentReference; data: Record<string, unknown> }
  | { kind: 'set'; ref: DocumentReference; data: Record<string, unknown> }
  | { kind: 'delete'; ref: DocumentReference };

/**
 * What happens to one booking of the deleted user. Pure, so it is unit-tested.
 * - Every booking: the deleted side's name/photo become "Deleted user"/empty,
 *   so the other person keeps their history without personal data.
 * - Upcoming bookings (pending / confirmed / reschedule_pending) are also
 *   cancelled, and the other participant gets a notification.
 */
export function planBookingCleanup(uid: string, booking: Record<string, unknown>) {
  const isCoach = booking.coachUid === uid;
  const update: Record<string, unknown> = isCoach
    ? { coachName: DELETED_USER_NAME, coachPhotoUrl: '' }
    : { traineeName: DELETED_USER_NAME, traineePhotoUrl: '' };

  const status = typeof booking.status === 'string' ? booking.status : '';
  const cancel = ACTIVE_BOOKING_STATUSES.has(status);
  if (cancel) {
    update.status = 'cancelled';
    update.cancellationReason = 'account_deleted';
  }

  const otherUid = String((isCoach ? booking.traineeUid : booking.coachUid) ?? '');
  const notify = cancel && otherUid !== '' && otherUid !== uid
    ? { recipientUid: otherUid, recipientRole: isCoach ? 'trainee' : 'coach' }
    : null;
  return { update, notify };
}

function cancellationNotice(
  bookingId: string,
  booking: Record<string, unknown>,
  recipient: { recipientUid: string; recipientRole: string },
): Record<string, unknown> {
  const date = typeof booking.date === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(booking.date)
    ? booking.date
    : '';
  const whoEn = recipient.recipientRole === 'coach' ? 'trainee' : 'coach';
  const whoAr = recipient.recipientRole === 'coach' ? 'المتدرب' : 'المدرب';
  return {
    ...recipient,
    senderUid: 'system',
    senderName: 'CoachHub',
    type: ACCOUNT_DELETED_CANCEL_TYPE,
    titleEn: 'Booking Cancelled',
    titleAr: 'تم إلغاء الحجز',
    bodyEn: date
      ? `Your booking for ${date} was cancelled because the ${whoEn} deleted their account.`
      : `Your booking was cancelled because the ${whoEn} deleted their account.`,
    bodyAr: date
      ? `تم إلغاء حجزك لتاريخ ${date} لأن ${whoAr} حذف حسابه.`
      : `تم إلغاء حجزك لأن ${whoAr} حذف حسابه.`,
    data: { bookingId },
    isRead: false,
    pushStatus: 'pending',
    createdAt: FieldValue.serverTimestamp(),
  };
}

async function commitInChunks(db: Firestore, writes: Write[]): Promise<void> {
  const CHUNK = 400; // Firestore batch limit is 500 operations
  for (let i = 0; i < writes.length; i += CHUNK) {
    const batch = db.batch();
    for (const w of writes.slice(i, i + CHUNK)) {
      if (w.kind === 'delete') batch.delete(w.ref);
      else if (w.kind === 'set') batch.set(w.ref, w.data);
      else batch.update(w.ref, w.data);
    }
    await batch.commit();
  }
}

/**
 * Removes or anonymises the account's data after its Firebase Auth login was
 * deleted. See [planBookingCleanup] for bookings; notifications addressed to
 * the deleted user are removed (nobody else can read them).
 */
export async function cleanupDeletedUser(
  db: Firestore,
  bucket: CleanupBucket | null,
  uid: string,
): Promise<void> {
  const writes: Write[] = [];

  const [asCoach, asTrainee, inbox] = await Promise.all([
    db.collection('bookings').where('coachUid', '==', uid).get(),
    db.collection('bookings').where('traineeUid', '==', uid).get(),
    db.collection('notifications').where('recipientUid', '==', uid).get(),
  ]);

  const seen = new Set<string>();
  for (const snap of [...asCoach.docs, ...asTrainee.docs]) {
    if (seen.has(snap.id)) continue;
    seen.add(snap.id);
    const booking = snap.data();
    const { update, notify } = planBookingCleanup(uid, booking);
    writes.push({
      kind: 'update',
      ref: snap.ref,
      data: { ...update, updatedAt: FieldValue.serverTimestamp() },
    });
    if (notify) {
      writes.push({
        kind: 'set',
        ref: db.collection('notifications').doc(),
        data: cancellationNotice(snap.id, booking, notify),
      });
    }
  }

  for (const snap of inbox.docs) writes.push({ kind: 'delete', ref: snap.ref });
  for (const collection of USER_OWNED_DOCS) {
    writes.push({ kind: 'delete', ref: db.collection(collection).doc(uid) });
  }

  await commitInChunks(db, writes);

  if (bucket) {
    for (const prefix of userStoragePrefixes(uid)) {
      await bucket.deleteFiles({ prefix, force: true });
    }
  }
}
