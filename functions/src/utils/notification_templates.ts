/**
 * Server-side copy of the bilingual booking notification templates
 * (lib/features/notifications/data/helpers/booking_notification_templates.dart).
 *
 * For booking notifications the app's own title/body text is NOT trusted:
 * the Cloud Function rebuilds it here from the booking document, so a user
 * cannot send arbitrary text (e.g. a fake "admin" message) to someone else.
 * Keep the wording in sync with the Dart templates.
 */

export interface NotificationText {
  titleEn: string;
  titleAr: string;
  bodyEn: string;
  bodyAr: string;
}

export interface TrustedCopy extends NotificationText {
  senderName: string;
}

export const BOOKING_NOTIFICATION_TYPES = new Set<string>([
  'booking_new',
  'booking_approved',
  'booking_rejected',
  'booking_cancelled',
  'booking_reschedule_proposed',
  'booking_reschedule_accepted',
  'booking_reschedule_declined',
  'booking_monthly_session_reschedule_proposed',
  'booking_monthly_session_reschedule_accepted',
  'booking_monthly_session_reschedule_declined',
  'booking_monthly_session_completed',
]);

const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;
const TIME_RE = /^\d{1,2}:\d{2}$/;
const MAX_REASON_LENGTH = 200;

function str(val: unknown): string {
  return typeof val === 'string' ? val.trim() : '';
}

/** Accepts only a real `YYYY-MM-DD` value, otherwise the fallback. */
function safeDate(val: unknown, fallback: unknown): string {
  const v = str(val);
  if (DATE_RE.test(v)) return v;
  const f = str(fallback);
  return DATE_RE.test(f) ? f : '';
}

/** Accepts only a real `HH:mm` value, otherwise the fallback. */
function safeTime(val: unknown, fallback: unknown): string {
  const v = str(val);
  if (TIME_RE.test(v)) return v;
  const f = str(fallback);
  return TIME_RE.test(f) ? f : '';
}

/** Free-text reason written by the other party: single line, length-capped. */
function safeReason(val: unknown, fallback: unknown): string {
  const raw = str(val) || str(fallback);
  const oneLine = raw.replace(/\s+/g, ' ').trim();
  return oneLine.length > MAX_REASON_LENGTH
    ? `${oneLine.slice(0, MAX_REASON_LENGTH - 1)}…`
    : oneLine;
}

function safeInt(val: unknown, min: number, max: number): number | null {
  const n = typeof val === 'number' ? val : Number(str(val));
  return Number.isInteger(n) && n >= min && n <= max ? n : null;
}

function sessionsOf(booking: Record<string, unknown>): Array<Record<string, unknown>> {
  return Array.isArray(booking.sessions)
    ? (booking.sessions.filter((s) => s && typeof s === 'object') as Array<Record<string, unknown>>)
    : [];
}

function sessionNumberFor(booking: Record<string, unknown>, data: Record<string, unknown>): number {
  const fromData = safeInt(data.sessionNumber, 1, 1000);
  if (fromData !== null) return fromData;
  const fromId = safeInt(data.sessionId, 1, 1000);
  if (fromId !== null) return fromId;
  const idx = sessionsOf(booking).findIndex((s) => s.id === data.sessionId);
  return idx >= 0 ? idx + 1 : 1;
}

/**
 * Rebuilds the notification copy from the booking. Returns null when the
 * type is not a booking notification (admin types are trusted as-is, since
 * only admins may create them).
 */
export function buildTrustedBookingCopy(
  doc: Record<string, unknown>,
  booking: Record<string, unknown>,
): TrustedCopy | null {
  const type = str(doc.type);
  if (!BOOKING_NOTIFICATION_TYPES.has(type)) return null;

  const data = (doc.data && typeof doc.data === 'object' ? doc.data : {}) as Record<string, unknown>;
  const coachName = str(booking.coachName) || 'Coach';
  const traineeName = str(booking.traineeName) || 'Trainee';
  const senderIsCoach = str(doc.senderUid) === str(booking.coachUid);
  const senderName = senderIsCoach ? coachName : traineeName;

  const text = ((): NotificationText => {
    switch (type) {
      case 'booking_new': {
        const sport = str(booking.sport);
        const bookingType = str(booking.bookingType) || 'session';
        return {
          titleEn: 'New Booking Request',
          titleAr: 'طلب حجز جديد',
          bodyEn: `New booking request from ${traineeName} for ${sport} (${bookingType})`,
          bodyAr: `طلب حجز جديد من ${traineeName} لرياضة ${sport} (${bookingType})`,
        };
      }
      case 'booking_approved': {
        const date = safeDate(booking.date, data.date);
        return {
          titleEn: 'Booking Approved',
          titleAr: 'تمت الموافقة على الحجز',
          bodyEn: `Coach ${coachName} approved your booking request for ${date}`,
          bodyAr: `وافق المدرب ${coachName} على طلب الحجز الخاص بك لتاريخ ${date}`,
        };
      }
      case 'booking_rejected': {
        const reason = safeReason(data.reason, booking.rejectionReason);
        return {
          titleEn: 'Booking Declined',
          titleAr: 'تم رفض الحجز',
          bodyEn: `Coach ${coachName} declined your request. Reason: ${reason}`,
          bodyAr: `اعتذر المدرب ${coachName} عن قبول طلبك. السبب: ${reason}`,
        };
      }
      case 'booking_cancelled': {
        const date = safeDate(booking.date, data.date);
        return {
          titleEn: 'Booking Cancelled',
          titleAr: 'تم إلغاء الحجز',
          bodyEn: `${traineeName} cancelled the booking for ${date}`,
          bodyAr: `ألغى ${traineeName} الحجز لتاريخ ${date}`,
        };
      }
      case 'booking_reschedule_proposed': {
        const date = safeDate(data.date, booking.proposedDate);
        const time = safeTime(data.time, booking.proposedStartTime);
        const reason = safeReason(data.reason, booking.rescheduleReason);
        return {
          titleEn: 'Reschedule Proposed',
          titleAr: 'اقتراح موعد جديد',
          bodyEn: `${senderName} proposed a new time: ${date} at ${time}. Reason: ${reason}`,
          bodyAr: `اقترح ${senderName} موعداً جديداً: ${date} الساعة ${time}. السبب: ${reason}`,
        };
      }
      case 'booking_reschedule_accepted': {
        const date = safeDate(data.date, booking.date);
        return {
          titleEn: 'Reschedule Accepted',
          titleAr: 'تم قبول الموعد الجديد',
          bodyEn: `${senderName} accepted the proposed reschedule for ${date}`,
          bodyAr: `وافق ${senderName} على الموعد المقترح لتاريخ ${date}`,
        };
      }
      case 'booking_reschedule_declined':
        return {
          titleEn: 'Reschedule Declined',
          titleAr: 'تم رفض الموعد المقترح',
          bodyEn: `${senderName} declined the proposed reschedule`,
          bodyAr: `رفض ${senderName} الموعد المقترح`,
        };
      case 'booking_monthly_session_reschedule_proposed': {
        const n = sessionNumberFor(booking, data);
        const session = sessionsOf(booking).find((s) => s.id === data.sessionId) ?? {};
        const date = safeDate(data.date, session.proposedDate);
        const time = safeTime(data.time, session.proposedStartTime);
        return {
          titleEn: 'Monthly Session Reschedule',
          titleAr: 'إعادة جدولة جلسة شهرية',
          bodyEn: `${senderName} proposed rescheduling Session #${n} of your monthly plan to ${date} at ${time}`,
          bodyAr: `اقترح ${senderName} إعادة جدولة الجلسة رقم ${n} لخطتك الشهرية إلى ${date} الساعة ${time}`,
        };
      }
      case 'booking_monthly_session_reschedule_accepted': {
        const n = sessionNumberFor(booking, data);
        return {
          titleEn: 'Session Reschedule Accepted',
          titleAr: 'تم قبول إعادة جدولة الجلسة',
          bodyEn: `${senderName} accepted the new time for Session #${n}`,
          bodyAr: `وافق ${senderName} على الموعد الجديد للجلسة رقم ${n}`,
        };
      }
      case 'booking_monthly_session_reschedule_declined': {
        const n = sessionNumberFor(booking, data);
        return {
          titleEn: 'Session Reschedule Declined',
          titleAr: 'تم رفض إعادة جدولة الجلسة',
          bodyEn: `${senderName} declined the reschedule for Session #${n}`,
          bodyAr: `رفض ${senderName} إعادة جدولة الجلسة رقم ${n}`,
        };
      }
      default: {
        // booking_monthly_session_completed: progress counted from the booking.
        const sessions = sessionsOf(booking);
        const n = sessionNumberFor(booking, data);
        const total = sessions.length || 1;
        const completed = sessions.filter((s) => s.status === 'completed').length;
        return {
          titleEn: 'Session Completed',
          titleAr: 'اكتملت الجلسة',
          bodyEn: `Session #${n} was marked as completed. Progress: ${completed}/${total} done!`,
          bodyAr: `تم تحديد الجلسة رقم ${n} كمكتملة. التقدم: ${completed}/${total} مكتملة!`,
        };
      }
    }
  })();

  return { ...text, senderName };
}
