# CoachHub Push Notifications Backend (`functions/`)

Server-side Firebase Cloud Functions (Node.js 22, TypeScript, `firebase-functions` v2) for **Milestone 11** all-state push delivery across Foreground, Background, and Killed/Terminated states.

## Triggers

- **`onNotificationCreated`** (`notifications/{notificationId}`):
  - Reads `fcm_tokens/{recipientUid}` (respects `notificationsEnabled` and `languageCode`: `'en'` | `'ar'`).
  - Queries unread count from `notifications` for iOS/Android badge updates.
  - Dispatches multicast push via `admin.messaging().sendEachForMulticast` on channel `coachhub_high_importance` with `FLUTTER_NOTIFICATION_CLICK`.
  - Automatically removes dead/unregistered tokens (`messaging/registration-token-not-registered`, `messaging/invalid-registration-token`).
  - Writes audit telemetry (`pushStatus`, `pushSentAt`, `pushSuccessCount`, `pushFailureCount`).

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
   firebase deploy --only functions,firestore:rules
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

