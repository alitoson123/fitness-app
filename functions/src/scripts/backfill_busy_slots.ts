/**
 * One-time backfill: builds `coach_busy_slots/{coachUid}` for every coach
 * whose bookings were created before the `onBookingWritten` function existed.
 *
 * Run once after deploying the functions (see functions/README.md):
 *   gcloud auth application-default login
 *   npm run backfill:busy-slots
 *
 * Safe to re-run: it only recomputes the documents from the real bookings.
 * This file is not exported from index.ts, so it is never deployed.
 */
import * as admin from 'firebase-admin';
import { rebuildAllCoachBusySlots } from '../utils/busy_slots_store';

const projectId =
  process.env.GCLOUD_PROJECT || process.env.GOOGLE_CLOUD_PROJECT || 'coach-hub-app-522cd';

async function main(): Promise<void> {
  admin.initializeApp({ projectId });
  const target = process.env.FIRESTORE_EMULATOR_HOST
    ? `emulator ${process.env.FIRESTORE_EMULATOR_HOST}`
    : `project ${projectId}`;
  console.log(`Backfilling coach_busy_slots on ${target}...`);
  const count = await rebuildAllCoachBusySlots(admin.firestore());
  console.log(`Done: rebuilt busy slots for ${count} coach(es).`);
}

main().catch((err) => {
  console.error('Backfill failed:', err);
  process.exit(1);
});
