import type { MulticastMessage } from 'firebase-admin/messaging';

export interface LocalizedCopy {
  title: string;
  body: string;
}

function readString(val: unknown): string {
  return typeof val === 'string' ? val.trim() : '';
}

export function selectLocalizedCopy(
  data: Record<string, unknown>,
  languageCode: 'en' | 'ar',
): LocalizedCopy {
  const titleEn = readString(data.titleEn) || readString(data.title);
  const titleAr = readString(data.titleAr) || titleEn;
  const bodyEn = readString(data.bodyEn) || readString(data.message);
  const bodyAr = readString(data.bodyAr) || bodyEn;

  if (languageCode === 'ar') {
    return {
      title: titleAr || 'CoachHub',
      body: bodyAr,
    };
  }
  return {
    title: titleEn || 'CoachHub',
    body: bodyEn,
  };
}

export function buildStringDataPayload(
  notificationId: string,
  doc: Record<string, unknown>,
): Record<string, string> {
  const nested = (doc.data && typeof doc.data === 'object'
    ? doc.data
    : {}) as Record<string, unknown>;

  const payload: Record<string, string> = {
    notificationId: String(notificationId),
    type: readString(doc.type),
    bookingId: nested.bookingId !== undefined ? String(nested.bookingId) : '',
    sessionId: nested.sessionId !== undefined ? String(nested.sessionId) : '',
    recipientRole: readString(doc.recipientRole),
    click_action: 'FLUTTER_NOTIFICATION_CLICK',
  };

  for (const [key, value] of Object.entries(nested)) {
    if (!(key in payload) && value !== undefined && value !== null) {
      payload[key] = String(value);
    }
  }
  return payload;
}

export function buildMulticastPayload(params: {
  notificationId: string;
  tokens: string[];
  doc: Record<string, unknown>;
  languageCode: 'en' | 'ar';
  unreadCount: number;
}): MulticastMessage {
  const { notificationId, tokens, doc, languageCode, unreadCount } = params;
  const copy = selectLocalizedCopy(doc, languageCode);
  const data = buildStringDataPayload(notificationId, doc);

  return {
    tokens,
    notification: {
      title: copy.title,
      body: copy.body,
    },
    data,
    android: {
      priority: 'high',
      notification: {
        channelId: 'coachhub_high_importance',
        sound: 'default',
        tag: notificationId,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        color: '#FF3D00',
      },
    },
    apns: {
      headers: {
        'apns-priority': '10',
      },
      payload: {
        aps: {
          alert: { title: copy.title, body: copy.body },
          sound: 'default',
          badge: Math.max(0, unreadCount),
          'content-available': 1,
        },
      },
    },
  };
}

