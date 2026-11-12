# CoachHub Admin Web Dashboard — Implementation Roadmap

> **Project Name**: `fitness_app_dashboard`  
> **Platform**: Flutter Web (Optimized for Desktop / Widescreen)  
> **Connected Firebase Project**: `coach-hub-app-522cd`  
> **Target Alignment**: Synced with CoachHub Mobile App (Phase 1 & Phase 2)

---

## 1. Architectural Standards & Rules

Any agent or developer working on this project must strictly comply with the following standards:

1. **Pragmatic Architecture (Strictly Anti-Overengineering)**:
   - `lib/core/`: Constants, database services, navigator/router, theme, shared widgets, utils.
   - `lib/features/<feature>/`: Divided into `data/` (models, concrete data sources, concrete repositories) and `presentation/` (views, widgets, Cubit).
   - **NO Entities**: Use data models directly across all layers.
   - **NO Use Cases**: Cubits call concrete repositories/services directly.
   - **NO Abstract Classes for Repositories/DataSources**: Implement repositories directly.
2. **Mandatory Clean Data Flow Pipeline**:
   - `Core Services -> Remote Data Source -> Concrete Repository -> Cubit -> UI (Views & Widgets)`.
3. **State Management**:
   - Use `flutter_bloc` (`Cubit` pattern).
   - UI widgets must never call Firestore or repositories directly; delegate state to Cubit.
4. **Clean Code & Modularity**:
   - **Keep all files under 150 lines**. Split widgets and logic if a file approaches this limit.
   - Screen files (`*_view.dart`) only handle high-level layout. All table rows, cards, dialogs, and filters must live in `presentation/widgets/`.
5. **Desktop-First UX**:
   - Persistent collapsible sidebar, top action header, data tables with pagination/filters, and responsive dialogs/modals.
6. **Localization (l10n)**:
   - No hardcoded strings. All user-facing text must be defined in both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb` simultaneously.
   - Support LTR (English) and RTL (Arabic) layouts.

---

## 2. Firebase Configuration & Data Schema

### 2.1 Web Firebase Options
Use the existing Firebase project (`coach-hub-app-522cd`). Registered in `firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyBSv7EPtsxVYK02K0PPwRKQDfieO1DXCB8',
  appId: '1:572406151179:web:7eb6de5ac187e7e869ef0e',
  messagingSenderId: '572406151179',
  projectId: 'coach-hub-app-522cd',
  authDomain: 'coach-hub-app-522cd.firebaseapp.com',
  storageBucket: 'coach-hub-app-522cd.firebasestorage.app',
  measurementId: 'G-RRZE0F78FC',
);
```

### 2.2 Firestore Collections & Schemas (Aligned with Mobile Phase 1 & 2)

| Collection | Document ID | Key Fields | Description |
| :--- | :--- | :--- | :--- |
| `users` | `uid` | `uid`, `name`, `email`, `phoneNumber`, `countryCode`, `role` (`'admin'` \| `'coach'` \| `'trainee'`), `status` (`'active'` \| `'suspended'`), `createdAt`, `updatedAt` | Base account profile (supports Phase 2 phone-only auth) |
| `coach_verifications` | `coachUid` | `coachUid`, `status` (`'pending'` \| `'approved'` \| `'rejected'`), `identityDocumentUrl`, `certificateUrls` (`List<String>`), `rejectionReason`, `submittedAt`, `reviewedAt`, `updatedAt` | Professional verification review record |
| `coach_profiles` | `coachUid` | `uid`, `name`, `phoneNumber`, `photoUrl`, `bio`, `country`, `city`, `sports` (`List<String>`), `specialties` (`List<String>`), `sessionPriceUSD` (`double`), `monthlyPriceUSD` (`double`), `currency` (`'USD'`), `yearsOfExperience`, `rating`, `workingDays`, `workingHours`, `isProfileCompleted`, `updatedAt` | Public coach profile and Phase 2 dual USD pricing |
| `trainee_profiles` | `uid` | `uid`, `name`, `phoneNumber`, `photoUrl`, `country`, `city`, `age`, `gender`, `sports` (`List<String>`), `level`, `goal`, `trainingType`, `isProfileCompleted`, `updatedAt` | Trainee fitness dossier & preferences |
| `bookings` | `bookingId` | `id`, `coachUid`, `coachName`, `traineeUid`, `traineeName`, `sport`, `bookingType` (`'session'` \| `'monthly'`), `date`, `startTime`, `endTime`, `durationMonths`, `monthlyScheduleNotes`, `price` (`double`), `currency` (`'USD'`), `status` (`'pending'` \| `'confirmed'` \| `'rejected'` \| `'completed'` \| `'cancelled'` \| `'reschedule_pending'`), `rejectionReason`, `proposedDate`, `proposedStartTime`, `proposedEndTime`, `rescheduleReason`, `rescheduledBy`, `createdAt`, `updatedAt` | Training session bookings & monthly packages with reschedule flow |
| `admin_notifications` | `notificationId` | `id`, `recipientUid` (`'admin'`), `recipientRole` (`'admin'`), `senderUid`, `senderName`, `type` (`'coach_verification_submitted'` \| `'booking_new'` \| `'booking_cancelled'`), `titleEn`, `titleAr`, `bodyEn`, `bodyAr`, `data`, `isRead` (`bool`), `pushStatus`, `createdAt` (`Timestamp`) | Mobile-to-Admin queue read directly via Firestore real-time stream (no Cloud Function push needed) |
| `notifications` | `notificationId` | `id`, `recipientUid`, `recipientRole` (`'coach'` \| `'trainee'`), `senderUid` (`'admin'`), `senderName` (`'CoachHub Admin'`), `type` (`'coach_profile_approved'` \| `'coach_profile_rejected'` \| `'admin_warning'` \| `'account_suspended'`), `titleEn`, `titleAr`, `bodyEn`, `bodyAr`, `data`, `isRead` (`bool`), `pushStatus` (`'pending'`), `createdAt` (`Timestamp`) | Admin-to-User outbound notifications; triggers `onNotificationCreated` Cloud Function for mobile FCM push + in-app center |

---

## 3. Step-by-Step Implementation Milestones

### Milestone 1: Initialization & Foundation
- [x] Initialize `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
- [x] Create `lib/core/theme/app_theme.dart` (CoachHub Sporty Pure Dark Mode, high-contrast tokens, Plus Jakarta Sans & Inter typography).
- [x] Set up `FirestoreService` in `lib/core/services/` with error logging and typed query methods.
- [x] Set up service locator (`get_it`).

### Milestone 2: Domain Entities & Data Models
- [x] `UserModel`: `uid`, `name`, `email`, `phoneNumber`, `role`, `status`, `isActive`, `isSuspended`.
- [x] `CoachVerificationModel`: `coachUid`, `status`, `identityDocumentUrl`, `certificateUrls`, `rejectionReason`, `submittedAt`.
- [x] `CoachProfileModel`: Full coach details, dual USD pricing, sports, ratings.
- [x] `BookingModel`: Details of training sessions, coach/trainee references, status, booking type (`session` / `monthly`).
- [x] `AdminStatsModel`: Metrics summary (`totalCoaches`, `totalTrainees`, `pendingApplications`, `totalBookings`).

### Milestone 3: Authentication & Role-Based Routing
- [x] Implement `AdminAuthCubit` with email/password sign-in.
- [x] **Admin Security Guard**: On sign-in, inspect `users/{uid}`. If `role != 'admin'`, sign out immediately and display an "Unauthorized: Admin privileges required" banner.
- [x] Configure `GoRouter` with centralized routes.

### Milestone 4: Admin Desktop Shell (`AdminLayoutScaffold`)
- [x] **Collapsible Sidebar**:
  - Logo & app title (`CoachHub Admin`).
  - Navigation items with icons & active route highlights:
    - 📊 Dashboard
    - 🏋️ Coaches & Verification
    - 👥 Trainees
    - 📅 Bookings
  - Bottom action: Admin profile chip & Logout button.
- [x] **Header Bar**:
  - Breadcrumb navigation.
  - Search bar.
  - Language toggle (English / Arabic RTL).
  - Theme mode toggle.
- [x] Content viewport wrapped in smooth scroll & responsive constraints.

### Milestone 5: Feature 1 — Dashboard Overview
- [x] **State**: `AdminDashboardCubit` (fetches real-time counts from Firestore).
- [x] **Widgets**:
  - `StatCard`: 4 primary KPI cards (Total Coaches, Total Trainees, Pending Applications, Total Bookings).
  - `PendingApplicationsAlertBanner`: Quick-access banner showing coaches waiting for review.
  - `RecentBookingsTable`: Mini preview of the latest bookings.

### Milestone 6: Feature 2 — Coach Management & Verification
- [x] **State**: `AdminCoachesCubit`:
  - Loads coaches and combines `users` doc, `coach_profiles` doc, and `coach_verifications` doc.
  - Filter state: `all` | `pending` | `approved` | `rejected` | `suspended`.
- [x] **Widgets**:
  - `CoachDataTable`: Columns for Avatar, Name, Contact, Sports, Verification Status badge, Account Status badge, Actions.
  - `CoachVerificationDetailModal`: Full bio, pricing, experience, and document viewer.
  - Action Bar: Approve, Reject (with reason dialog), Suspend / Unsuspend.

### Milestone 7: Feature 3 — Trainee Management
- [x] **Data Layer**:
  - `TraineeProfileModel`: Models trainee profile document (`trainee_profiles/{uid}`) including sports, fitness goals, fitness level, age, gender, phone, and location.
  - `TraineeAdminModel`: Aggregated model combining `UserModel`, `TraineeProfileModel`, total bookings count, and recent booking history.
  - `TraineesRemoteDataSource`: Joins `users` (`role == 'trainee'`), `trainee_profiles`, and `bookings` collections; updates account status between `'active'` and `'suspended'`.
  - `TraineesRepository`: Concrete repository returning `Either<Failure, List<TraineeAdminModel>>` and coordinating status updates.
- [x] **State Management**:
  - `AdminTraineesCubit`: Manages trainee list, loading/error states, search query filtering, and status filtering (`all`, `active`, `suspended`).
- [x] **Widgets**:
  - `TraineeFilterBar`: Filter chips (`all`, `active`, `suspended`), search field (name, phone, email, city, goal), and refresh button.
  - `TraineeDataTable`: High-contrast data table with columns for Avatar, Name, Phone/Email, Location, Fitness Goal/Level, Account Status badge, Joined Date, and Actions.
  - `TraineeDetailModal`: Comprehensive modal displaying personal info, fitness profile (level, goal, sports chips), booking history overview, and account status toggle.
  - `SuspendConfirmDialog`: Reusable confirmation modal before suspending or unsuspending accounts.

### Milestone 8: Feature 4 — Booking Management
- [ ] **State**: `AdminBookingsCubit` (queries `bookings` collection supporting Phase 2 single-session & monthly packages).
- [ ] Filter chips: `All`, `Pending`, `Confirmed`, `Reschedule Pending`, `Completed`, `Cancelled`, `Rejected`.
- [ ] **Widgets**:
  - `BookingDataTable`: Columns for Booking ID, Coach Name, Trainee Name, Type (`Session` / `Monthly`), Sport, Date & Time / Duration, Price ($ USD), Status badge.
  - `BookingDetailsDialog`: Shows session details, notes, reschedule proposals, and timeline.

### Milestone 9: Admin Notifications Center (Firestore Stream) & Admin-to-User Push Dispatch
> **Architecture Alignment with Mobile (`fitness_app`)**:
> - **Mobile → Admin Dashboard**: Mobile writes alerts (`coach_verification_submitted`, `booking_new`, `booking_cancelled`) to `admin_notifications`. The Admin Dashboard consumes them directly via a **Firestore real-time stream** (no Web FCM / no `onAdminNotificationCreated` Cloud Function).
> - **Admin Dashboard → Mobile (Coach & Trainee)**: Dashboard writes bilingual docs (`coach_profile_approved`, `coach_profile_rejected`, `account_suspended`, `admin_warning`) to `notifications`. The existing `onNotificationCreated` Cloud Function automatically sends FCM Push Notifications (Foreground / Background / Killed) and Mobile's `NotificationsView` displays them in real time.

- [ ] **Task 9.1: Core Constants, Navigation & Sidebar Integration**
  - Add notification type constants to `lib/core/constant/app_constants.dart` matching Mobile `NotificationType` (`coach_verification_submitted`, `booking_new`, `booking_cancelled`, `coach_profile_approved`, `coach_profile_rejected`, `admin_warning`, `account_suspended`).
  - Add `AppRoutes.notifications = '/notifications'` in `lib/core/navigator/app_routes.dart`.
  - Register `GoRoute(path: AppRoutes.notifications)` inside `ShellRoute` in `lib/core/navigator/app_router.dart`.
  - Update `AdminBreadcrumbs` (`lib/core/widgets/header/admin_breadcrumbs.dart`) and `AdminSidebar` (`lib/core/widgets/sidebar/admin_sidebar.dart`) with a **Notifications** item (with live unread count badge).
- [ ] **Task 9.2: Data Layer (`lib/features/notifications/data/`)**
  - Create `models/admin_notification_model.dart` (<150 lines):
    - Fields: `id`, `recipientUid`, `recipientRole`, `senderUid`, `senderName`, `type`, `titleEn`, `titleAr`, `bodyEn`, `bodyAr`, `data`, `isRead`, `pushStatus`, `createdAt`.
    - Defensive `fromMap` supporting `titleEn`/`titleAr`/`bodyEn`/`bodyAr` (with fallback to `title`/`message`) and `senderUid`/`senderName` (with fallback to `sourceUid`/`sourceName`).
    - Helpers: `localizedTitle(lang)`, `localizedBody(lang)`, `isBookingRelated`, `isVerificationRelated`, `copyWith`, `toMap`.
  - Create `helpers/admin_notification_templates.dart` (<150 lines):
    - Bilingual EN/AR templates matching Mobile `NotificationBannerDetail` & `NotificationDeepLinkHandler`:
      - `coachProfileApproved()` -> `type: 'coach_profile_approved'`, `data: {'status': 'approved'}`
      - `coachProfileRejected(reason)` -> `type: 'coach_profile_rejected'`, `data: {'status': 'rejected', 'reason': reason, 'rejectionReason': reason}`
      - `accountSuspended({reason})` -> `type: 'account_suspended'`, `data: {'status': 'suspended', 'reason': reason, 'adminMessage': reason}`
      - `adminWarning({titleEn, titleAr, bodyEn, bodyAr})` -> `type: 'admin_warning'`, `data: {'title': titleEn, 'details': bodyEn, 'adminMessage': bodyEn}`
  - Create `datasources/notifications_remote_data_source.dart` (<150 lines):
    - `streamAdminNotifications()`: `FirestoreService.streamCollection` on `FirestoreCollections.adminNotifications` ordered by `createdAt` descending.
    - `markAsRead(id)`, `markAllAsRead()` (batched updates), `deleteNotification(id)` on `admin_notifications`.
    - `sendNotificationToUser(...)`: creates doc in `FirestoreCollections.notifications` with `senderUid: 'admin'`, `senderName: 'CoachHub Admin'`, `isRead: false`, `pushStatus: 'pending'`, `createdAt: FieldValue.serverTimestamp()`.
    - `sendBroadcastNotification(...)`: batched writes (chunks of <=500) to `notifications` for target role (`coach` | `trainee` | `all`).
  - Create `repositories/notifications_repository.dart` (<150 lines): concrete repository returning `Either<Failure, ...>`.
  - Register `NotificationsRemoteDataSource`, `NotificationsRepository`, and `AdminNotificationsCubit` (as `registerLazySingleton` so header badge stays live across routes) in `lib/core/services/service_locator.dart`, and provide `AdminNotificationsCubit` at root in `lib/main.dart` (start stream after admin auth succeeds, cancel on sign-out).
- [ ] **Task 9.3: State Management (`lib/features/notifications/presentation/cubit/`)**
  - Create `notification_filter.dart` (`all`, `bookings`, `verifications`) and `admin_notifications_state.dart`.
  - Create `admin_notifications_cubit.dart` (<150 lines):
    - Real-time subscription `startListening()` / `stopListening()`, computing `unreadCount`, `bookingsCount`, `verificationsCount`, `filteredNotifications`.
    - Actions: `setFilter`, `setSearchQuery`, `markAsRead`, `markAllAsRead`, `deleteNotification`, `sendWarningToUser`, `sendBroadcastNotification`.
- [ ] **Task 9.4: UI — Header Bell & Dedicated Notifications Page (`lib/features/notifications/presentation/`)**
  - Create `widgets/admin_notification_bell.dart` (<150 lines) and mount in `AdminHeaderActions` (`lib/core/widgets/header/admin_header_actions.dart`) with live unread badge (`99+` cap) navigating to `AppRoutes.notifications` (or quick preview dropdown + "View All").
  - Create `views/admin_notifications_view.dart` (<150 lines, layout only) and modular widgets (<150 lines each):
    - `widgets/notifications_filter_bar.dart` (`All`, `Bookings`, `Verifications` chips with counts + Refresh + Mark All as Read + Send Notification CTA).
    - `widgets/notification_item_card.dart` & `widgets/notification_avatar.dart` & `widgets/notification_detail_chips.dart`: unread dot, localized EN/AR copy, relative timestamp, metadata badges (`priceUSD`, `bookingType`, `date`, `coachUid`), mark read, delete, and click-to-navigate (`coach_verification_submitted` -> `/coaches`, `booking_new`/`booking_cancelled` -> `/bookings`).
    - `widgets/empty_notifications_view.dart`.
    - `widgets/send_admin_notification_dialog.dart`: modal for sending `admin_warning` / custom bilingual notification to a specific user (pre-filled from Coach/Trainee modals) or broadcast to All Coaches / All Trainees / All Users.
- [ ] **Task 9.5: Hook Auto-Dispatch into Existing Moderation Flows**
  - **Coaches (`CoachesRepository` / `AdminCoachesCubit` / `CoachVerificationDetailModal`)**:
    - On `approveVerification(coachUid)` -> auto-dispatch `coach_profile_approved` notification to `notifications`.
    - On `rejectVerification(coachUid, reason)` -> auto-dispatch `coach_profile_rejected` notification with `reason`.
    - Update `SuspendConfirmDialog` (`lib/features/coaches/presentation/widgets/suspend_confirm_dialog.dart`) to include an optional suspension `reason` `TextFormField` when `isSuspending == true` (returning `({bool confirmed, String? reason})?` or equivalent record), and pass `reason` into `toggleAccountStatus(uid, currentStatus, reason: reason)` -> auto-dispatch `account_suspended` notification with `reason`.
    - Add **"Send Warning / Notification"** button in `CoachModalActions` opening `SendAdminNotificationDialog` pre-targeted to the coach.
  - **Trainees (`TraineesRepository` / `AdminTraineesCubit` / `TraineeDetailModal`)**:
    - Update `SuspendTraineeDialog` (`lib/features/trainees/presentation/widgets/suspend_trainee_dialog.dart`) to include an optional suspension `reason` `TextFormField` when `isSuspending == true`, and pass `reason` into `toggleAccountStatus(uid, currentStatus, reason: reason)` -> auto-dispatch `account_suspended` notification with `reason`.
    - Add **"Send Warning / Notification"** button in `TraineeModalActions` opening `SendAdminNotificationDialog` pre-targeted to the trainee.
- [ ] **Task 9.6: Localization (EN/AR) & Verification**
  - Add all new notification strings to both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb`, then run `flutter pub run intl_utils:generate`.
  - Write unit tests for `AdminNotificationModel`, `NotificationsRepository`, `AdminNotificationsCubit`, and verify `AdminCoachesCubit` / `AdminTraineesCubit` dispatch outbound notifications on approve/reject/suspend.
  - Verify cross-app integration: Mobile -> `admin_notifications` -> Dashboard Stream, and Dashboard -> `notifications` -> `onNotificationCreated` -> Mobile Push & In-App Center.

### Milestone 10: Localization, Testing & Deployment
- [ ] Maintain 100% Arabic & English coverage in ARB files.
- [ ] Comprehensive unit and widget test suite for Trainee Management.
- [ ] Production build and Firebase Hosting release.
