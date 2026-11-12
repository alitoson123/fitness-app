import * as assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import type { BatchResponse, MulticastMessage } from 'firebase-admin/messaging';
import {
  handleNotificationCreated,
  type NotificationTriggerDeps,
} from '../src/triggers/on_notification_created';
import { hashToken } from '../src/utils/token_utils';

function makeNotificationDoc(overrides: Record<string, unknown> = {}) {
  return {
    recipientUid: 'coach_1',
    recipientRole: 'coach',
    senderUid: 'trainee_1',
    senderName: 'Ali',
    type: 'booking_new',
    titleEn: 'New Booking Request',
    titleAr: 'طلب حجز جديد',
    bodyEn: 'New booking request from Ali',
    bodyAr: 'طلب حجز جديد من علي',
    data: { bookingId: 'booking_42', sessionId: 's_1', bookingType: 'monthly' },
    isRead: false,
    ...overrides,
  };
}

describe('Cloud Functions: onNotificationCreated', () => {
  it('selects Arabic copy when recipient languageCode is ar and attaches badge & Android channel', async () => {
    let sentMsg: MulticastMessage | undefined;
    let auditUpdate: Record<string, unknown> | undefined;

    const deps: NotificationTriggerDeps = {
      getTokenDoc: async () => ({
        tokens: ['token_ios', 'token_android'],
        languageCode: 'ar',
        notificationsEnabled: true,
      }),
      getUnreadCount: async () => 5,
      sendMulticast: async (msg) => {
        sentMsg = msg;
        return {
          successCount: 2,
          failureCount: 0,
          responses: [{ success: true }, { success: true }],
        } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async (_id, update) => {
        auditUpdate = update;
      },
    };

    await handleNotificationCreated(deps, 'notif_100', makeNotificationDoc());

    assert.ok(sentMsg);
    assert.equal(sentMsg.notification?.title, 'طلب حجز جديد');
    assert.equal(sentMsg.notification?.body, 'طلب حجز جديد من علي');
    assert.deepEqual(sentMsg.tokens, ['token_ios', 'token_android']);
    assert.equal(sentMsg.data?.notificationId, 'notif_100');
    assert.equal(sentMsg.data?.bookingId, 'booking_42');
    assert.equal(sentMsg.data?.click_action, 'FLUTTER_NOTIFICATION_CLICK');
    assert.equal(sentMsg.android?.notification?.channelId, 'coachhub_high_importance');
    assert.equal(sentMsg.android?.notification?.tag, 'notif_100');
    assert.equal(sentMsg.apns?.payload?.aps?.badge, 5);
    assert.equal(auditUpdate?.pushStatus, 'sent');
    assert.equal(auditUpdate?.pushSuccessCount, 2);
  });

  it('selects English copy when recipient languageCode is en', async () => {
    let sentMsg: MulticastMessage | undefined;
    const deps: NotificationTriggerDeps = {
      getTokenDoc: async () => ({
        tokens: ['token_1'],
        languageCode: 'en',
        notificationsEnabled: true,
      }),
      getUnreadCount: async () => 1,
      sendMulticast: async (msg) => {
        sentMsg = msg;
        return {
          successCount: 1,
          failureCount: 0,
          responses: [{ success: true }],
        } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async () => { },
    };

    await handleNotificationCreated(deps, 'notif_en', makeNotificationDoc());

    assert.equal(sentMsg?.notification?.title, 'New Booking Request');
    assert.equal(sentMsg?.notification?.body, 'New booking request from Ali');
  });

  it('skips dispatch and marks pushStatus as skipped when notificationsEnabled is false', async () => {
    let multicastCalled = false;
    let auditUpdate: Record<string, unknown> | undefined;

    const deps: NotificationTriggerDeps = {
      getTokenDoc: async () => ({
        tokens: ['token_1'],
        languageCode: 'en',
        notificationsEnabled: false,
      }),
      getUnreadCount: async () => 2,
      sendMulticast: async () => {
        multicastCalled = true;
        return { successCount: 0, failureCount: 0, responses: [] } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async (_id, update) => {
        auditUpdate = update;
      },
    };

    await handleNotificationCreated(deps, 'notif_muted', makeNotificationDoc());

    assert.equal(multicastCalled, false);
    assert.equal(auditUpdate?.pushStatus, 'skipped');
  });

  it('cleans up dead/unregistered tokens from fcm_tokens on multicast error', async () => {
    let cleanedUid = '';
    let cleanedTokens: string[] = [];
    let auditUpdate: Record<string, unknown> | undefined;

    const deps: NotificationTriggerDeps = {
      getTokenDoc: async () => ({
        tokens: ['good_tok', 'dead_tok_1', 'bad_tok_2'],
        languageCode: 'en',
        notificationsEnabled: true,
      }),
      getUnreadCount: async () => 3,
      sendMulticast: async () =>
        ({
          successCount: 1,
          failureCount: 2,
          responses: [
            { success: true },
            {
              success: false,
              error: { code: 'messaging/registration-token-not-registered' },
            },
            {
              success: false,
              error: { code: 'messaging/invalid-registration-token' },
            },
          ],
        }) as unknown as BatchResponse,
      cleanupStaleTokens: async (uid, stale) => {
        cleanedUid = uid;
        cleanedTokens = stale;
      },
      updateAudit: async (_id, update) => {
        auditUpdate = update;
      },
    };

    await handleNotificationCreated(deps, 'notif_cleanup', makeNotificationDoc());

    assert.equal(cleanedUid, 'coach_1');
    assert.deepEqual(cleanedTokens, ['dead_tok_1', 'bad_tok_2']);
    assert.equal(auditUpdate?.pushStatus, 'sent');
    assert.equal(auditUpdate?.pushSuccessCount, 1);
    assert.equal(auditUpdate?.pushFailureCount, 2);
  });

  it('produces consistent 16-char hex token hashes for Firestore device keys', () => {
    const hash = hashToken('fcm:device_token-123');
    assert.match(hash, /^[0-9a-f]{16}$/);
  });

  it('dispatches Admin Dashboard notifications (e.g. admin_warning) to coach/trainee devices', async () => {
    let sentMsg: MulticastMessage | undefined;
    let auditUpdate: Record<string, unknown> | undefined;

    const deps: NotificationTriggerDeps = {
      getTokenDoc: async () => ({
        tokens: ['coach_tok_1'],
        languageCode: 'ar',
        notificationsEnabled: true,
      }),
      getUnreadCount: async () => 1,
      sendMulticast: async (msg) => {
        sentMsg = msg;
        return {
          successCount: 1,
          failureCount: 0,
          responses: [{ success: true }],
        } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async (_id, update) => {
        auditUpdate = update;
      },
    };

    await handleNotificationCreated(deps, 'notif_admin_warn', {
      recipientUid: 'coach_1',
      recipientRole: 'coach',
      senderUid: 'admin',
      senderName: 'CoachHub Admin',
      type: 'admin_warning',
      titleEn: 'Policy Warning',
      titleAr: 'تنبيه إداري',
      bodyEn: 'Please respond faster to trainees',
      bodyAr: 'يرجى الرد بشكل أسرع على المتدربين',
      data: { adminMessage: 'Please respond faster to trainees' },
      isRead: false,
    });

    assert.ok(sentMsg);
    assert.equal(sentMsg.notification?.title, 'تنبيه إداري');
    assert.equal(sentMsg.notification?.body, 'يرجى الرد بشكل أسرع على المتدربين');
    assert.equal(sentMsg.data?.type, 'admin_warning');
    assert.equal(auditUpdate?.pushStatus, 'sent');
  });

  it('skips notifications addressed to literal admin recipientUid', async () => {
    let multicastCalled = false;
    let auditUpdate: Record<string, unknown> | undefined;

    const deps: NotificationTriggerDeps = {
      getTokenDoc: async () => undefined,
      getUnreadCount: async () => 0,
      sendMulticast: async () => {
        multicastCalled = true;
        return { successCount: 0, failureCount: 0, responses: [] } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async (_id, update) => {
        auditUpdate = update;
      },
    };

    await handleNotificationCreated(
      deps,
      'notif_admin_skip',
      makeNotificationDoc({ recipientUid: 'admin', recipientRole: 'admin' }),
    );

    assert.equal(multicastCalled, false);
    assert.equal(auditUpdate?.pushStatus, 'skipped');
  });
});

