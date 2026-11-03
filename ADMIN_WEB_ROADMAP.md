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
| `admin_notifications` | `notificationId` | `id`, `type`, `sourceUid`, `sourceName`, `title`, `message`, `data`, `isRead` (`bool`), `createdAt` (`DateTime`) | Dedicated queue for Admin Dashboard alerts & moderation |

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

### Milestone 9: Admin Moderation & Notifications Integration
- [ ] Connect `admin_notifications` collection for real-time alerts.
- [ ] Admin warning/broadcast triggers to coaches and trainees.

### Milestone 10: Localization, Testing & Deployment
- [ ] Maintain 100% Arabic & English coverage in ARB files.
- [ ] Comprehensive unit and widget test suite for Trainee Management.
- [ ] Production build and Firebase Hosting release.
