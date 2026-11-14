/**
 * English/Arabic display names for values stored on bookings, used in
 * notification text. Copied from lib/l10n/intl_*.arb (sport* keys,
 * singleSessionType, monthlyPackageType); keep them in sync.
 */

export interface Bilingual {
  en: string;
  ar: string;
}

const SPORTS: Record<string, Bilingual> = {
  football: { en: 'Football', ar: 'كرة القدم' },
  basketball: { en: 'Basketball', ar: 'كرة السلة' },
  swimming: { en: 'Swimming', ar: 'السباحة' },
  tennis: { en: 'Tennis', ar: 'التنس' },
  running: { en: 'Running', ar: 'الجري' },
  boxing: { en: 'Boxing', ar: 'الملاكمة' },
  gym: { en: 'Gym', ar: 'جيم وكمال أجسام' },
  cycling: { en: 'Cycling', ar: 'ركوب الدراجات' },
  martial_arts: { en: 'Martial Arts', ar: 'فنون قتالية' },
  volleyball: { en: 'Volleyball', ar: 'كرة الطائرة' },
  padel: { en: 'Padel', ar: 'بادل' },
  badminton: { en: 'Badminton', ar: 'كرة الريشة' },
  table_tennis: { en: 'Table Tennis', ar: 'كرة الطاولة' },
  crossfit: { en: 'CrossFit', ar: 'كروس فيت' },
  handball: { en: 'Handball', ar: 'كرة اليد' },
};

/** Known sports are translated; a custom sport keeps the coach's own text. */
export function sportName(raw: string): Bilingual {
  const key = raw.trim().toLowerCase().replace(/ /g, '_');
  return SPORTS[key] ?? { en: raw.trim(), ar: raw.trim() };
}

export function bookingTypeName(raw: string): Bilingual {
  return raw === 'monthly'
    ? { en: 'Monthly Plan', ar: 'باقة شهرية' }
    : { en: 'Single Session', ar: 'جلسة فردية' };
}
