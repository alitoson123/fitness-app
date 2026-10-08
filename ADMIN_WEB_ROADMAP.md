# CoachHub Admin Web Dashboard — Phase 8 Implementation Roadmap

> **Project Name**: `fitness_app_dashboard`  
> **Platform**: Flutter Web (Optimized for Desktop / Widescreen)  
> **Connected Firebase**: `coach-hub-app-522cd`  
> **Target Phase**: Phase 8 — Admin Management (from CoachHub Master Roadmap)

---

## 1. Architectural Standards & Rules

Any agent or developer working on this project must strictly comply with the following standards:

1. **Pragmatic Architecture (Strictly Anti-Overengineering)**:
   - `lib/core/`: Constants, database services, navigator/router, theme, shared widgets, utils.
   - `lib/features/<feature>/`: Divided into `data/` (models, concrete data sources, concrete repositories) and `presentation/` (views, widgets, Cubit).
   - **NO Entities**: Use data models directly across all layers.
   - **NO Use Cases**: Cubits call concrete repositories/services directly.
   - **NO Abstract Classes for Repositories/DataSources**: Implement repositories directly.
2. **State Management**:
   - Use `flutter_bloc` (`Cubit` pattern).
   - UI widgets must never call Firestore or repositories directly; delegate state to Cubit.
3. **Clean Code & Modularity**:
   - **Keep all files under 150 lines**. Split widgets and logic if a file approaches this limit.
   - Screen files (`*_view.dart`) only handle high-level layout. All table rows, cards, dialogs, and filters must live in `presentation/widgets/`.
4. **Desktop-First UX**:
   - Persistent collapsible sidebar, top action header, data tables with pagination/filters, and responsive dialogs/drawers.
5. **Localization (l10n)**:
   - No hardcoded strings. All user-facing text must be defined in both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb` simultaneously.
   - Support LTR (English) and RTL (Arabic) layouts.

---

## 2. Firebase Configuration & Data Schema

### 2.1 Web Firebase Options
Use the existing Firebase project (`coach-hub-app-522cd`). Register in `firebase_options.dart`:

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

### 2.2 Firestore Collections & Schemas

| Collection | Document ID | Key Fields |
| :--- | :--- | :--- |
| `users` | `uid` | `uid`, `name`, `email`, `role` (`'admin'` \| `'coach'` \| `'trainee'`), `status` (`'active'` \| `'suspended'`), `createdAt`, `updatedAt` |
| `coach_verifications` | `coachUid` | `coachUid`, `status` (`'pending'` \| `'approved'` \| `'rejected'`), `identityDocumentUrl`, `certificateUrls` (`List<String>`), `rejectionReason`, `submittedAt`, `reviewedAt`, `updatedAt` |
| `coach_profiles` | `coachUid` | `uid`, `name`, `email`, `photoUrl`, `bio`, `country`, `city`, `sports` (`List<String>`), `specialties`, `sessionPrice`, `currency`, `yearsOfExperience`, `rating` |
| `trainee_profiles` | `uid` | `uid`, `name`, `email`, `photoUrl`, `country`, `city`, `age`, `gender`, `sports` (`List<String>`), `level`, `goal`, `isProfileCompleted`, `updatedAt` |
| `bookings` | `bookingId` | `id`, `coachUid`, `coachName`, `traineeUid`, `traineeName`, `sport`, `date`, `startTime`, `endTime`, `status` (`'pending'` \| `'confirmed'` \| `'rejected'` \| `'completed'` \| `'cancelled'`), `createdAt` |

---

## 3. Recommended `pubspec.yaml` Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Firebase
  firebase_core: ^4.15.0
  firebase_auth: ^6.7.0
  cloud_firestore: ^6.10.0

  # State Management & Routing
  flutter_bloc: ^8.1.6
  go_router: ^14.8.0

  # Fonts & UI
  google_fonts: ^6.2.1
  cached_network_image: ^3.4.1
  url_launcher: ^6.3.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  intl_utils: ^2.8.7
```

---

## 4. Step-by-Step Implementation Milestones

### Milestone 1: Initialization & Foundation
- [x] Initialize `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
- [x] Create `lib/core/theme/app_theme.dart` (Professional Dark / Light modern dashboard theme, high-contrast palettes, clean typography).
- [x] Set up `FirestoreService` in `lib/core/services/` with error logging and typed query methods.
- [x] Set up service locator (`get_it` or constructor dependency injection).

### Milestone 2: Domain Entities & Data Models
- [x] `UserModel`: `uid`, `name`, `email`, `role`, `status`, `isActive`, `isSuspended`.
- [x] `CoachVerificationModel`: `coachUid`, `status`, `identityDocumentUrl`, `certificateUrls`, `rejectionReason`, `submittedAt`.
- [x] `CoachProfileModel`: Full coach details, pricing, sports, ratings.
- [x] `BookingModel`: Details of training sessions, coach/trainee references, status.
- [x] `AdminStatsModel`: Metrics summary (`totalCoaches`, `totalTrainees`, `pendingApplications`, `totalBookings`).

### Milestone 3: Authentication & Role-Based Routing
- [x] Implement `AdminAuthCubit` with email/password sign-in.
- [x] **Admin Security Guard**: On sign-in, inspect `users/{uid}`. If `role != 'admin'`, sign out immediately and display an "Unauthorized: Admin privileges required" banner.
- [x] Configure `GoRouter`:
  - `/login`: Admin login screen.
  - `/`: Redirects to `/dashboard` if authenticated as admin.
  - `/dashboard`: Metrics & overview.
  - `/coaches`: Coach list & verification review.
  - `/trainees`: Trainee directory & status management.
  - `/bookings`: Marketplace bookings management.

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
  - Language toggle (English / Arabic).
  - Theme mode toggle.
- [x] Content viewport wrapped in smooth scroll & responsive constraints.

### Milestone 5: Feature 1 — Dashboard Overview
- [x] **State**: `AdminDashboardCubit` (fetches counts from Firestore).
- [x] **Widgets**:
  - `StatCard`: 4 primary KPI cards (Total Coaches, Total Trainees, Pending Coach Applications, Total Bookings) with icons, trends, and hover animations.
  - `PendingApplicationsAlertBanner`: Quick-access banner showing coaches waiting for review.
  - `RecentBookingsTable`: Mini preview of the latest 5 bookings.

### Milestone 6: Feature 2 — Coach Management & Verification
- [x] **State**: `AdminCoachesCubit`:
  - Loads coaches and combines `users` doc, `coach_profiles` doc, and `coach_verifications` doc.
  - Filter state: `all` | `pending` | `approved` | `rejected` | `suspended`.
- [x] **Widgets**:
  - `CoachDataTable`: Columns for Avatar, Name, Email, Sports, Verification Status badge, Account Status badge, Actions.
  - `CoachVerificationDetailModal`:
    - Full coach bio, pricing, and experience.
    - Document viewer: Preview National ID and Certificate URLs (with full-screen zoom or external tab opener via `url_launcher`).
    - Action Bar:
      - **Approve**: Updates `coach_verifications/{uid}` status to `'approved'`.
      - **Reject**: Opens `RejectReasonDialog` to input a mandatory reason, then updates status to `'rejected'`.
      - **Suspend / Unsuspend**: Modifies `users/{uid}` status between `'suspended'` and `'active'`.

### Milestone 7: Feature 3 — Trainee Management
- [ ] **State**: `AdminTraineesCubit` (queries `users` where `role == 'trainee'`).
- [ ] **Widgets**:
  - `TraineeDataTable`: Columns for Name, Email, Status badge (`active` / `suspended`), Joined Date, Actions.
  - `TraineeDetailDrawer`: View trainee details and booking history.
  - `SuspendConfirmationDialog`: Confirm action before changing trainee status to `suspended` (with reason logging).

### Milestone 8: Feature 4 — Booking Management
- [ ] **State**: `AdminBookingsCubit` (queries `bookings` collection).
- [ ] Filter chips: `All`, `Pending`, `Confirmed`, `Completed`, `Cancelled`, `Rejected`.
- [ ] **Widgets**:
  - `BookingDataTable`: Columns for Booking ID, Coach Name, Trainee Name, Sport, Date & Time slot, Status badge.
  - `BookingDetailsDialog`: Shows session details, notes, and timeline.

### Milestone 9: Localization & Accessibility
- [ ] Define all strings in `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb`.
- [ ] Run `flutter pub run intl_utils:generate`.
- [ ] Ensure Arabic RTL aligns sidebars, data tables, and modal dialogs seamlessly.

### Milestone 10: Production Deployment (Firebase Hosting)
1. Initialize Firebase Hosting in `fitness_app_dashboard`:
   ```bash
   firebase init hosting
   ```
   Select existing project: `coach-hub-app-522cd`  
   Public directory: `build/web`  
   Configure as single-page app: `Yes`
2. Build for Web:
   ```bash
   flutter build web --release
   ```
3. Deploy to production:
   ```bash
   firebase deploy --only hosting
   ```
   Live admin URL will be available immediately at:  
   `https://coach-hub-app-522cd.web.app`

---

## 5. File Structure Reference

```
lib/
├── core/
│   ├── constant/
│   │   └── app_constants.dart
│   ├── navigator/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── services/
│   │   └── firestore_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── admin_scaffold.dart
│       ├── admin_sidebar.dart
│       ├── admin_header.dart
│       └── status_badge.dart
├── features/
│   ├── auth/
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── view_model/
│   │   │   ├── views/admin_dashboard_view.dart
│   │   │   └── widgets/kpi_card.dart
│   ├── coaches/
│   │   ├── data/
│   │   ├── presentation/
│   │   │   ├── view_model/
│   │   │   ├── views/admin_coaches_view.dart
│   │   │   └── widgets/
│   │   │       ├── coach_data_table.dart
│   │   │       ├── verification_review_dialog.dart
│   │   │       └── reject_reason_dialog.dart
│   ├── trainees/
│   │   ├── presentation/
│   │   │   ├── views/admin_trainees_view.dart
│   │   │   └── widgets/trainee_data_table.dart
│   └── bookings/
│       ├── presentation/
│       │   ├── views/admin_bookings_view.dart
│       │   └── widgets/booking_data_table.dart
├── firebase_options.dart
└── main.dart
```
