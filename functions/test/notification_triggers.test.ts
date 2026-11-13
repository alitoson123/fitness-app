import * as assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import type { BatchResponse, MulticastMessage } from 'firebase-admin/messaging';
import {
  handleNotificationCreated,
  type NotificationTriggerDeps,
} from '../src/triggers/on_notification_created';
import { hashToken } from '../src/utils/token_utils';
import { computeBusySlots } from '../src/utils/busy_slots';
import { buildTrustedBookingCopy } from '../src/utils/notification_templates';

const booking42: Record<string, unknown> = {
  coachUid: 'coach_1',
  traineeUid: 'trainee_1',
  coachName: 'Sara',
  traineeName: 'Ali',
  sport: 'football',
  bookingType: 'monthly',
  date: '2026-12-01',
};

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
      getBooking: async () => booking42,
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
    assert.equal(sentMsg.notification?.body, 'طلب حجز جديد من Ali لرياضة football (monthly)');
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
      getBooking: async () => booking42,
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
    assert.equal(sentMsg?.notification?.body, 'New booking request from Ali for football (monthly)');
  });

  it('skips dispatch and marks pushStatus as skipped when notificationsEnabled is false', async () => {
    let multicastCalled = false;
    let auditUpdate: Record<string, unknown> | undefined;

    const deps: NotificationTriggerDeps = {
      getBooking: async () => booking42,
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
      getBooking: async () => booking42,
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
      getBooking: async () => booking42,
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
      getBooking: async () => booking42,
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

  it('replaces client-written booking text with the server template (anti-phishing)', async () => {
    let sentMsg: MulticastMessage | undefined;
    const audits: Array<Record<string, unknown>> = [];
    const deps: NotificationTriggerDeps = {
      getBooking: async () => ({ ...booking42, bookingType: 'session' }),
      getTokenDoc: async () => ({ tokens: ['tok'], languageCode: 'en', notificationsEnabled: true }),
      getUnreadCount: async () => 1,
      sendMulticast: async (msg) => {
        sentMsg = msg;
        return { successCount: 1, failureCount: 0, responses: [{ success: true }] } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async (_id, update) => { audits.push(update); },
    };

    await handleNotificationCreated(deps, 'notif_phish', makeNotificationDoc({
      type: 'booking_approved',
      senderUid: 'coach_1',
      senderName: 'CoachHub Admin',
      recipientUid: 'trainee_1',
      recipientRole: 'trainee',
      titleEn: 'Account suspended',
      bodyEn: 'Call +20 000 to restore your account',
      data: { bookingId: 'booking_42', date: 'Call +20 000 now' },
    }));

    assert.equal(sentMsg?.notification?.title, 'Booking Approved');
    assert.equal(sentMsg?.notification?.body, 'Coach Sara approved your booking request for 2026-12-01');
    assert.equal(audits[0]?.titleEn, 'Booking Approved');
    assert.equal(audits[0]?.senderName, 'Sara');
  });

  it('skips push when the referenced booking does not exist', async () => {
    let multicastCalled = false;
    let auditUpdate: Record<string, unknown> | undefined;
    const deps: NotificationTriggerDeps = {
      getBooking: async () => undefined,
      getTokenDoc: async () => ({ tokens: ['tok'], notificationsEnabled: true }),
      getUnreadCount: async () => 0,
      sendMulticast: async () => {
        multicastCalled = true;
        return { successCount: 0, failureCount: 0, responses: [] } as BatchResponse;
      },
      cleanupStaleTokens: async () => { },
      updateAudit: async (_id, update) => { auditUpdate = update; },
    };

    await handleNotificationCreated(deps, 'notif_nobooking', makeNotificationDoc());

    assert.equal(multicastCalled, false);
    assert.equal(auditUpdate?.pushSkipReason, 'booking_not_found');
  });
});

describe('notification templates', () => {
  it('caps and flattens free-text reasons', () => {
    const copy = buildTrustedBookingCopy(
      { type: 'booking_rejected', senderUid: 'coach_1', data: { reason: `busy\n\n${'x'.repeat(500)}` } },
      booking42,
    );
    assert.ok(copy);
    assert.ok(!copy.bodyEn.includes('\n'));
    assert.ok(copy.bodyEn.length < 260);
  });

  it('counts monthly progress from the booking, not from client data', () => {
    const copy = buildTrustedBookingCopy(
      {
        type: 'booking_monthly_session_completed',
        senderUid: 'coach_1',
        data: { sessionId: '2', sessionNumber: 2, completedCount: 99, totalCount: 99 },
      },
      {
        ...booking42,
        sessions: [
          { id: '1', status: 'completed' },
          { id: '2', status: 'completed' },
          { id: '3', status: 'scheduled' },
        ],
      },
    );
    assert.equal(copy?.bodyEn, 'Session #2 was marked as completed. Progress: 2/3 done!');
  });

  it('returns null for admin types (trusted as-is)', () => {
    assert.equal(buildTrustedBookingCopy({ type: 'admin_warning' }, booking42), null);
  });
});

describe('computeBusySlots (ported from the Dart getBookedSlots tests)', () => {
  const MIN = '2026-01-01';

  it('single booking: keeps original slot booked even when reschedule_pending', () => {
    const slots = computeBusySlots(
      [{ status: 'reschedule_pending', date: '2026-11-10', startTime: '10:00' }],
      MIN,
    );
    assert.deepEqual(slots['2026-11-10'], ['10:00']);
  });

  it('single booking: blocks proposed slot on proposed date during reschedule_pending', () => {
    const slots = computeBusySlots(
      [{
        status: 'reschedule_pending', date: '2026-11-10', startTime: '10:00',
        proposedDate: '2026-11-12', proposedStartTime: '14:00',
      }],
      MIN,
    );
    assert.deepEqual(slots['2026-11-12'], ['14:00']);
  });

  it('single booking: ignores rejected and cancelled bookings', () => {
    const slots = computeBusySlots(
      [
        { status: 'rejected', date: '2026-11-10', startTime: '10:00' },
        { status: 'cancelled', date: '2026-11-10', startTime: '11:00' },
        { status: 'confirmed', date: '2026-11-10', startTime: '12:00' },
      ],
      MIN,
    );
    assert.deepEqual(slots['2026-11-10'], ['12:00']);
  });

  it('monthly booking: blocks scheduled and proposed session slots', () => {
    const slots = computeBusySlots(
      [{
        bookingType: 'monthly', status: 'reschedule_pending',
        sessions: [
          { id: 's1', date: '2026-11-05', startTime: '09:00', status: 'reschedule_pending',
            proposedDate: '2026-11-12', proposedStartTime: '15:00' },
          { id: 's2', date: '2026-11-12', startTime: '11:00', status: 'scheduled' },
        ],
      }],
      MIN,
    );
    assert.deepEqual(slots['2026-11-05'], ['09:00']);
    assert.deepEqual(slots['2026-11-12'], ['11:00', '15:00']);
  });

  it('monthly booking: ignores cancelled sessions and cancelled bookings', () => {
    const slots = computeBusySlots(
      [
        { bookingType: 'monthly', status: 'cancelled',
          sessions: [{ id: 's1', date: '2026-11-10', startTime: '10:00', status: 'scheduled' }] },
        { bookingType: 'monthly', status: 'confirmed',
          sessions: [
            { id: 's2', date: '2026-11-10', startTime: '12:00', status: 'cancelled' },
            { id: 's3', date: '2026-11-10', startTime: '16:00', status: 'scheduled' },
          ] },
      ],
      MIN,
    );
    assert.deepEqual(slots['2026-11-10'], ['16:00']);
  });

  it('drops dates before the minimum date', () => {
    const slots = computeBusySlots(
      [{ status: 'confirmed', date: '2025-12-31', startTime: '10:00' }],
      MIN,
    );
    assert.deepEqual(slots, {});
  });
});

