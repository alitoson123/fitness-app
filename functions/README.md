# CoachHub Push Notifications Backend (`functions/`)

Server-side Firebase Cloud Functions (Node.js 22, TypeScript, `firebase-functions` v2) for **Milestone 11** all-state push delivery across Foreground, Background, and Killed/Terminated states.

## Triggers

- **`onNotificationCreated`** (`notifications/{notificationId}`):
  - Reads `fcm_tokens/{recipientUid}` (respects `notificationsEnabled` and `languageCode`: `'en'` | `'ar'`).
  - Queries unread count from `notifications` for iOS/Android badge updates.
  - Dispatches multicast push via `admin.messaging().sendEachForMulticast` on channel `coachhub_high_importance` with `FLUTTER_NOTIFICATION_CLICK`.
  - Automatically removes dead/unregistered tokens (`messaging/registration-token-not-registered`, `messaging/invalid-registration-token`).
  - Writes audit telemetry (`pushStatus`, `pushSentAt`, `pushSuccessCount`, `pushFailureCount`).
  - For booking notification types, ignores the app-written title/body and rebuilds them from the booking (`src/utils/notification_templates.ts`, keep in sync with the Dart templates), then saves the trusted copy back to the document.

- **`onBookingWritten`** (`bookings/{bookingId}`):
  - Rebuilds the public `coach_busy_slots/{coachUid}` document (taken dates + start times only, no personal data) whenever one of the coach's bookings changes. The app reads availability from it, so `bookings` stay private to each booking's coach and trainee.

- **`onAuthUserDeleted`** (Auth user deleted, v1 trigger):
  - Deletes the account's own docs (`users`, `coach_profiles`, `trainee_profiles`, `coach_verifications`, `fcm_tokens`, `coach_busy_slots`) and its Storage uploads (`src/utils/account_cleanup.ts`).
  - Bookings: every booking of the user is anonymised ("Deleted user", no photo) so the other participant keeps their history. Upcoming ones (`pending`, `confirmed`, `reschedule_pending`) are also cancelled (`cancellationReason: 'account_deleted'`) and the other participant gets a `booking_cancelled_account_deleted` notification.
  - Notifications addressed to the deleted user are removed.
  - The app deletes the Auth login first and relies on this function for the data, so it must be deployed before shipping the new app build.

## One-time busy-slots backfill

Bookings created before `onBookingWritten` was first deployed have no `coach_busy_slots` document yet. Run this **once**, right after the first deploy of `onBookingWritten` and **before** deploying the participant-only `bookings` rules:

```bash
gcloud auth application-default login
cd functions
npm run backfill:busy-slots
```

It is safe to re-run (it recomputes from the real bookings), e.g. if a coach's availability ever looks wrong.

> Note: `admin_notifications` is consumed directly by the Admin Web Dashboard via Firestore real-time streams (no server-side FCM push trigger needed).

## Local Verification (Free / Spark Plan)

```bash
cd functions
npm install
npm run build
npm test
```

To test end-to-end triggers locally using the Firebase Emulator Suite:

```bash
firebase emulators:start --only functions,firestore
```

## Production Deployment Checklist (Client Handover)

1. **Firebase Plan**: Upgrade `coach-hub-app-522cd` to the **Blaze (Pay-as-you-go)** plan (includes 2,000,000 free invocations/month).
2. **Deploy Backend & Rules**:
   ```bash
   cd functions && npm run build && cd ..
   firebase deploy --only functions
   cd functions && npm run backfill:busy-slots && cd ..   # first time only
   firebase deploy --only firestore:rules,storage
   ```
3. **iOS APNs Setup** (for Apple Push delivery in Background & Killed states):
   - In Apple Developer Portal -> **Certificates, Identifiers & Profiles -> Keys**, generate an **Apple Push Notifications service (APNs)** `.p8` key and note the **Key ID** and **Team ID**.
   - In **Firebase Console -> Project Settings -> Cloud Messaging -> Apple app configuration**, upload the `.p8` file with Key ID and Team ID.
   - In Xcode (`ios/Runner.xcworkspace`), select the `Runner` target -> **Signing & Capabilities -> + Capability -> Push Notifications** and **Background Modes -> Remote notifications**.
4. **3-State Real-Device Verification Matrix**:
   - Verify Foreground, Background, and Killed/Terminated push delivery between Trainee and Coach devices.
   - Verify zero duplicate heads-up banners in Foreground.
   - Verify tapping a Killed-state notification opens `Splash -> Dashboard -> BookingDetailsView` and pressing Back returns to Dashboard.
   - Verify Arabic (`ar`) push copy, Push Notifications mute toggle, multi-device delivery, and token detachment upon Sign-Out.

