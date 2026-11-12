import { FieldValue, type Firestore } from 'firebase-admin/firestore';

export const STALE_TOKEN_ERROR_CODES = new Set<string>([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

export interface TokenRecord {
  tokens: string[];
  languageCode: 'en' | 'ar';
  notificationsEnabled: boolean;
  legacyToken?: string;
}

export function hashToken(token: string): string {
  let h1 = 5381;
  let h2 = 2166136261;
  for (let i = 0; i < token.length; i++) {
    const unit = token.charCodeAt(i);
    h1 = (((h1 << 5) + h1) + unit) >>> 0;
    h2 = (((h2 << 5) - h2) ^ unit) >>> 0;
  }
  return (
    h1.toString(16).padStart(8, '0') +
    h2.toString(16).padStart(8, '0')
  );
}

export function parseTokenRecord(
  data: Record<string, unknown> | undefined,
): TokenRecord {
  if (!data) {
    return { tokens: [], languageCode: 'en', notificationsEnabled: true };
  }

  const tokenSet = new Set<string>();
  if (Array.isArray(data.tokens)) {
    for (const item of data.tokens) {
      if (typeof item === 'string' && item.trim().length > 0) {
        tokenSet.add(item.trim());
      }
    }
  }

  const legacyToken =
    typeof data.token === 'string' && data.token.trim().length > 0
      ? data.token.trim()
      : undefined;
  if (tokenSet.size === 0 && legacyToken) {
    tokenSet.add(legacyToken);
  }

  return {
    tokens: Array.from(tokenSet),
    languageCode: data.languageCode === 'ar' ? 'ar' : 'en',
    notificationsEnabled: data.notificationsEnabled !== false,
    legacyToken,
  };
}

export function collectStaleTokens(
  tokens: string[],
  responses: Array<{ success: boolean; error?: { code?: string } }>,
): string[] {
  const stale: string[] = [];
  responses.forEach((resp, idx) => {
    const code = resp.error?.code;
    if (!resp.success && code && STALE_TOKEN_ERROR_CODES.has(code)) {
      const token = tokens[idx];
      if (token) stale.push(token);
    }
  });
  return stale;
}

export async function removeStaleTokensFromDoc(
  db: Firestore,
  uid: string,
  staleTokens: string[],
  legacyToken?: string,
): Promise<void> {
  if (staleTokens.length === 0) return;
  const updates: Record<string, unknown> = {
    tokens: FieldValue.arrayRemove(...staleTokens),
  };
  for (const token of staleTokens) {
    updates[`devices.${hashToken(token)}`] = FieldValue.delete();
    if (legacyToken && legacyToken === token) {
      updates.token = FieldValue.delete();
    }
  }
  await db.collection('fcm_tokens').doc(uid).update(updates);
}
