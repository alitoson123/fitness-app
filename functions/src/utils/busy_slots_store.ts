import { FieldValue, type Firestore } from 'firebase-admin/firestore';
import {
  busyRangesFromIntervals,
  busySlotsFromIntervals,
  busySlotsMinDate,
  collectBusyIntervals,
  type BusyInterval,
} from './busy_slots';

export const BUSY_SLOTS_COLLECTION = 'coach_busy_slots';

/**
 * Recomputes `coach_busy_slots/{coachUid}` from all of the coach's bookings.
 * Runs in a transaction so concurrent booking writes cannot leave a stale
 * result (the last writer always recomputes from fresh data).
 */
export async function rebuildCoachBusySlots(db: Firestore, coachUid: string): Promise<void> {
  if (!coachUid) return;
  const minDate = busySlotsMinDate();
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(db.collection('bookings').where('coachUid', '==', coachUid));
    const intervals = collectBusyIntervals(snap.docs.map((d) => d.data()), minDate);
    tx.set(db.collection(BUSY_SLOTS_COLLECTION).doc(coachUid), busySlotsDoc(coachUid, intervals));
  });
}

/** The public `coach_busy_slots/{coachUid}` document for [intervals]. */
export function busySlotsDoc(coachUid: string, intervals: BusyInterval[]): Record<string, unknown> {
  return {
    coachUid,
    // Start times only: read by older app versions.
    slots: busySlotsFromIntervals(intervals),
    // Start-end ranges: lets the app hide every time that overlaps.
    ranges: busyRangesFromIntervals(intervals),
    updatedAt: FieldValue.serverTimestamp(),
  };
}

/** Rebuilds the busy-slot document of every coach that has bookings. */
export async function rebuildAllCoachBusySlots(db: Firestore): Promise<number> {
  const snap = await db.collection('bookings').select('coachUid').get();
  const coachUids = new Set<string>();
  for (const doc of snap.docs) {
    const uid = doc.get('coachUid');
    if (typeof uid === 'string' && uid) coachUids.add(uid);
  }
  for (const uid of coachUids) {
    await rebuildCoachBusySlots(db, uid);
  }
  return coachUids.size;
}
