import * as admin from 'firebase-admin';
import { FieldValue } from 'firebase-admin/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { BUSY_SLOTS_COLLECTION, busySlotsDoc } from '../utils/busy_slots_store';
import {
  BookingRequestError,
  parseBookingRequest,
  planNewBooking,
} from '../utils/booking_request';

const toHttpsError = (e: BookingRequestError): HttpsError =>
  new HttpsError(
    e.reason === 'invalid_request' ? 'invalid-argument' : 'failed-precondition',
    e.reason,
    { reason: e.reason, ...(e.conflict ? { conflict: e.conflict } : {}) },
  );

/**
 * The only way to create a booking (the security rules refuse direct
 * writes). Everything runs in one transaction that also rewrites the coach's
 * `coach_busy_slots` document; because every booking request for the same
 * coach reads and writes that document, Firestore lets them through one at
 * a time, so two trainees can never get the same time.
 */
export const createBooking = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'sign_in_required');

  let input;
  try {
    input = parseBookingRequest(request.data);
  } catch (e) {
    if (e instanceof BookingRequestError) throw toHttpsError(e);
    throw e;
  }

  const db = admin.firestore();
  const [traineeUser, traineeProfile, coachUser, coachProfile] = await Promise.all([
    db.doc(`users/${uid}`).get(),
    db.doc(`trainee_profiles/${uid}`).get(),
    db.doc(`users/${input.coachUid}`).get(),
    db.doc(`coach_profiles/${input.coachUid}`).get(),
  ]);

  const bookingRef = db.collection('bookings').doc();
  const busyRef = db.collection(BUSY_SLOTS_COLLECTION).doc(input.coachUid);
  let price = 0;

  try {
    await db.runTransaction(async (tx) => {
      // Read first: this is what queues concurrent requests for this coach.
      await tx.get(busyRef);
      const existing = await tx.get(db.collection('bookings').where('coachUid', '==', input.coachUid));

      const plan = planNewBooking(input, {
        traineeUid: uid,
        traineeUser: traineeUser.data(),
        traineeProfile: traineeProfile.data(),
        coachUser: coachUser.data(),
        coachProfile: coachProfile.data(),
        coachBookings: existing.docs.map((d) => d.data()),
        now: new Date(),
      });

      tx.create(bookingRef, {
        ...plan.booking,
        id: bookingRef.id,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      tx.set(busyRef, busySlotsDoc(input.coachUid, plan.intervals));
      price = plan.booking.price as number;
    });
  } catch (e) {
    if (e instanceof BookingRequestError) throw toHttpsError(e);
    throw e;
  }

  return { bookingId: bookingRef.id, price };
});
