import * as admin from 'firebase-admin';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { rebuildCoachBusySlots } from '../utils/busy_slots_store';

/**
 * Keeps the coach's public `coach_busy_slots/{coachUid}` document in sync
 * with booking changes. Bookings that existed before this function was
 * deployed are filled in once with `npm run backfill:busy-slots`.
 */
export const onBookingWritten = onDocumentWritten('bookings/{bookingId}', async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  const coachUids = new Set<string>();
  for (const d of [before, after]) {
    if (d && typeof d.coachUid === 'string' && d.coachUid) coachUids.add(d.coachUid);
  }
  const db = admin.firestore();
  for (const uid of coachUids) {
    await rebuildCoachBusySlots(db, uid);
  }
});
