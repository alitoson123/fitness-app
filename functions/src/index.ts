import * as admin from 'firebase-admin';

if (admin.apps.length === 0) {
  admin.initializeApp();
}

export { onNotificationCreated } from './triggers/on_notification_created';
export { onBookingWritten } from './triggers/busy_slots_sync';
export { onAuthUserDeleted } from './triggers/on_auth_user_deleted';

