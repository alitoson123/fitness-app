import * as admin from 'firebase-admin';
import { FieldValue } from 'firebase-admin/firestore';
import type { BatchResponse, MulticastMessage } from 'firebase-admin/messaging';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { buildMulticastPayload } from '../utils/fcm_payload_builder';
import {
  BOOKING_NOTIFICATION_TYPES,
  buildTrustedBookingCopy,
} from '../utils/notification_templates';
import {
  collectStaleTokens,
  parseTokenRecord,
  removeStaleTokensFromDoc,
} from '../utils/token_utils';

export interface NotificationTriggerDeps {
  getBooking: (bookingId: string) => Promise<Record<string, unknown> | undefined>;
  getTokenDoc: (uid: string) => Promise<Record<string, unknown> | undefined>;
  getUnreadCount: (uid: string) => Promise<number>;
  sendMulticast: (msg: MulticastMessage) => Promise<BatchResponse>;
  cleanupStaleTokens: (
    uid: string,
    staleTokens: string[],
    legacyToken?: string,
  ) => Promise<void>;
  updateAudit: (
    notificationId: string,
    update: Record<string, unknown>,
  ) => Promise<void>;
}

export async function handleNotificationCreated(
  deps: NotificationTriggerDeps,
  notificationId: string,
  data: Record<string, unknown> | undefined,
): Promise<void> {
  if (!data) return;

  const recipientUid =
    typeof data.recipientUid === 'string' ? data.recipientUid.trim() : '';
  if (!recipientUid || recipientUid === 'admin') {
    await deps.updateAudit(notificationId, { pushStatus: 'skipped' });
    return;
  }

  // Booking notifications are written by the app, so their text is not
  // trusted: rebuild it from the booking and store the trusted copy back on
  // the document (the in-app notification list reads it from there).
  let doc = data;
  const type = typeof data.type === 'string' ? data.type : '';
  if (BOOKING_NOTIFICATION_TYPES.has(type)) {
    const nested = (data.data && typeof data.data === 'object'
      ? data.data
      : {}) as Record<string, unknown>;
    const bookingId = typeof nested.bookingId === 'string' ? nested.bookingId : '';
    const booking = bookingId ? await deps.getBooking(bookingId) : undefined;
    if (!booking) {
      await deps.updateAudit(notificationId, {
        pushStatus: 'skipped',
        pushSkipReason: 'booking_not_found',
      });
      return;
    }
    const trusted = buildTrustedBookingCopy(data, booking);
    if (trusted) {
      await deps.updateAudit(notificationId, { ...trusted });
      doc = { ...data, ...trusted };
    }
  }

  const tokenData = await deps.getTokenDoc(recipientUid);
  const record = parseTokenRecord(tokenData);
  if (!record.notificationsEnabled || record.tokens.length === 0) {
    await deps.updateAudit(notificationId, { pushStatus: 'skipped' });
    return;
  }

  const unreadCount = await deps.getUnreadCount(recipientUid);
  const message = buildMulticastPayload({
    notificationId,
    tokens: record.tokens,
    doc,
    languageCode: record.languageCode,
    unreadCount,
  });

  const batchResponse = await deps.sendMulticast(message);
  const staleTokens = collectStaleTokens(record.tokens, batchResponse.responses);
  if (staleTokens.length > 0) {
    await deps.cleanupStaleTokens(recipientUid, staleTokens, record.legacyToken);
  }

  const status = batchResponse.successCount > 0 ? 'sent' : 'failed';
  await deps.updateAudit(notificationId, {
    pushStatus: status,
    pushSentAt: FieldValue.serverTimestamp(),
    pushSuccessCount: batchResponse.successCount,
    pushFailureCount: batchResponse.failureCount,
  });
}

function createFirebaseDeps(): NotificationTriggerDeps {
  const db = admin.firestore();
  const messaging = admin.messaging();

  return {
    getBooking: async (bookingId) =>
      (await db.collection('bookings').doc(bookingId).get()).data(),
    getTokenDoc: async (uid) =>
      (await db.collection('fcm_tokens').doc(uid).get()).data(),
    getUnreadCount: async (uid) => {
      const snap = await db
        .collection('notifications')
        .where('recipientUid', '==', uid)
        .where('isRead', '==', false)
        .count()
        .get();
      return snap.data().count;
    },
    sendMulticast: (msg) => messaging.sendEachForMulticast(msg),
    cleanupStaleTokens: (uid, staleTokens, legacyToken) =>
      removeStaleTokensFromDoc(db, uid, staleTokens, legacyToken),
    updateAudit: async (id, update) => {
      await db.collection('notifications').doc(id).update(update);
    },
  };
}

export const onNotificationCreated = onDocumentCreated(
  'notifications/{notificationId}',
  async (event) => {
    await handleNotificationCreated(
      createFirebaseDeps(),
      event.params.notificationId,
      event.data?.data(),
    );
  },
);
