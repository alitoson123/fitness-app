# CoachHub Mobile App — MVP Implementation Roadmap

> **Project Name**: `fitness_app` (CoachHub Mobile)  
> **Platform**: Flutter (Android & iOS)  
> **Connected Firebase**: `coach-hub-app-522cd`  
> **Target**: MVP Release (Phases 1 — 7 & 9, Core Marketplace Lifecycle)  
> **Core Workflow**: `Find a coach → View coach profile → Request training → Coach accepts or rejects`

---

## 1. Architectural Standards & Rules

Any agent or developer working on this project must strictly comply with the following standards:

1. **Pragmatic Architecture (Strictly Anti-Overengineering)**:
   - `lib/core/`: Constants, database services, navigator/router, theme, shared widgets, helpers, service locator.
   - `lib/features/<feature>/`: Divided strictly into:
     - `data/`: Data models, concrete data sources (Firestore, Firebase Storage, Hive), and concrete repositories.
     - `presentation/`: Views, sub-widgets, and Cubit state management.
   - **NO Entities**: NEVER create separate domain entity classes that mirror models. Use models (e.g., `UserModel`, `CoachProfileModel`, `TraineeProfileModel`, `BookingModel`) directly across data, repositories, Cubits, and UI.
   - **NO Use Cases**: NEVER create UseCase classes. Cubits MUST call concrete repositories or services directly.
   - **NO Abstract Classes for Repositories or Data Sources**: Implement concrete repositories and data sources directly (e.g., `class TraineeSetupRepo`, `class CoachSetupRemoteDataSource`).
2. **State Management**:
   - `flutter_bloc` (`Cubit` pattern) is the default state management solution.
   - UI widgets must never query Firestore or repositories directly; delegate state and async actions to the respective Cubit.
   - Emit immutable states using `copyWith` or state subclasses.
3. **Clean Code & Modularity**:
   - **Keep all files under 150 lines**. If a file approaches this limit, split widgets and logic immediately.
   - Screen files (`*_view.dart`) only handle high-level layout, `Scaffold`, and delegate to widgets.
   - All sub-sections, cards, lists, bottom sheets, dialogs, and step forms must live in `presentation/widgets/`.
   - Private widget classes (`_MyWidget`) are only acceptable for trivial wrappers (≤ 20 lines). Anything larger gets its own file.
4. **Mobile UX & Design Standards**:
   - Material 3 theming with responsive sizing via `flutter_screenutil`.
   - Follow the 60-30-10 color rule. Always support both Light and Dark themes.
   - Provide explicit loading indicators, friendly empty states, and retryable error states for all asynchronous operations.
5. **Localization (l10n)**:
   - **Never hardcode user-facing strings** in widgets. Every string must go through the localization system (`S.of(context)`).
   - All strings must be defined in both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb` simultaneously.
   - Support both LTR (English) and RTL (Arabic) layouts seamlessly.
6. **Push Notifications**:
   - Integrate Firebase Cloud Messaging (FCM) for key transaction events: new training request, request accepted, and request rejected.

---

## 2. Firebase Configuration & Data Schema

### 2.1 Mobile Firebase Options
Use the existing Firebase project (`coach-hub-app-522cd`) configured via `firebase_options.dart`:
- **Android**: `1:572406151179:android:4b09b936d50ffc1769ef0e`
- **iOS**: `1:572406151179:ios:9e89ff6ee57aee2969ef0e`
- **Web / Admin**: `1:572406151179:web:7eb6de5ac187e7e869ef0e`

### 2.2 Firestore Collections & Schemas

| Collection | Document ID | Key Fields | Description |
| :--- | :--- | :--- | :--- |
| `users` | `uid` | `uid`, `name`, `email`, `role` (`'coach'` \| `'trainee'` \| `'admin'`), `status` (`'active'` \| `'suspended'`), `createdAt`, `updatedAt` | Base auth profile and account status |
| `coach_verifications` | `coachUid` | `coachUid`, `status` (`'pending'` \| `'approved'` \| `'rejected'`), `identityDocumentUrl`, `certificateUrls` (`List<String>`), `rejectionReason`, `submittedAt`, `reviewedAt`, `updatedAt` | Professional verification review record |
| `coach_profiles` | `coachUid` | `uid`, `name`, `email`, `photoUrl`, `bio`, `country`, `city`, `sports` (`List<String>`), `specialties`, `sessionPrice`, `currency`, `yearsOfExperience`, `rating`, `workingDays`, `workingHours`, `isProfileCompleted`, `updatedAt` | Public coach profile and marketplace data |
| `trainee_profiles` | `uid` | `uid`, `name`, `email`, `photoUrl`, `country`, `city`, `age`, `gender`, `sports` (`List<String>`), `level`, `goal`, `trainingType`, `isProfileCompleted`, `updatedAt` | Trainee details and preferences |
| `bookings` | `bookingId` | `id`, `coachUid`, `coachName`, `coachPhotoUrl`, `traineeUid`, `traineeName`, `traineePhotoUrl`, `sport`, `date`, `startTime`, `endTime`, `notes`, `status` (`'pending'` \| `'confirmed'` \| `'rejected'`), `createdAt`, `updatedAt` | Training session requests and bookings |
| `fcm_tokens` | `uid` | `uid`, `token`, `platform` (`'android'` \| `'ios'`), `updatedAt` | Push notification device tokens |

---

## 3. Recommended & Active Dependencies

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
  firebase_storage: ^13.6.0

  # State Management & DI
  flutter_bloc: ^9.1.1
  get_it: ^9.3.0

  # Navigation
  go_router: ^17.5.0

  # Local Persistence
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.5.5

  # UI & Responsive
  flutter_screenutil: ^5.9.3
  google_fonts: ^6.2.1
  cached_network_image: ^3.4.1
  cupertino_icons: ^1.0.8
  modal_progress_hud_nsn: ^0.5.1

  # Media & File Handling
  image_picker: ^1.2.3
  file_picker: ^13.1.0

  # Social Sign-in
  google_sign_in: ^6.1.0
  sign_in_with_apple: ^7.0.1

  # Network & Utilities
  internet_connection_checker_plus: ^3.1.2
  dartz: ^0.10.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.13
  intl_utils: ^2.8.7
```

---

## 4. Step-by-Step Implementation Milestones

### Milestone 1: App Foundation & Architecture
- [x] Configure Firebase initialization for Android and iOS (`DefaultFirebaseOptions.currentPlatform`).
- [x] Implement centralized Service Locator (`get_it`) in `lib/core/locator_service/service_locator.dart`.
- [x] Configure Light & Dark themes with Material 3 in `lib/core/theme/`.
- [x] Set up responsive layout foundation using `flutter_screenutil`.
- [x] Initialize Hive local boxes for caching (`user_box`, `trainee_profile_box`, `coach_profile_box`).
- [x] Centralize route names in `lib/core/navigator/app_routes.dart` and define `GoRouter` in `app_router.dart`.

### Milestone 2: Authentication & Role Selection
- [x] Implement `SignInCubit` with email/password authentication.
- [x] Implement `SignUpCubit` with validation and error handling.
- [x] Integrate Google Sign-In and Apple Sign-In.
- [x] Implement Forgot Password flow (`sendPasswordResetEmail`).
- [x] Implement `ChooseRoleCubit` and `ChooseRoleView` (Trainee vs. Coach selection).
- [x] Implement `AuthRouteResolver` to route users based on role and profile completion status.
- [x] Implement `AuthSessionCubit` for global sign-out and account deletion.

### Milestone 3: Trainee Setup & Profile Completion
- [x] Implement `TraineeSetupCubit` with multi-step flow:
  - Step 1: Personal info (Name, Age, Gender, City, Country, Avatar upload).
  - Step 2: Sports selection & experience level (Beginner, Intermediate, Advanced).
  - Step 3: Training goals & preferred training type (Gym, Personal, Online).
- [x] Upload trainee avatar to Firebase Storage (`trainee_avatars/{uid}`).
- [x] Save `TraineeProfileModel` to Firestore `trainee_profiles/{uid}` and sync to Hive.
- [x] Update `users/{uid}` flag `isProfileCompleted: true`.
- [x] Navigate to Trainee Home upon completion.

### Milestone 4: Coach Registration & Document Submission
- [x] Implement `CoachSetupCubit` with 5-step registration wizard:
  - Step 1: Personal info (Full name, Photo, Location, Bio).
  - Step 2: Professional qualifications (Sports, Specialties, Years of experience, Languages).
  - Step 3: Pricing & availability draft (Session price, Currency, Preliminary working days).
  - Step 4: Verification document upload (National ID / Passport, Certificates, Proof of experience).
  - Step 5: Review summary & final submission.
- [x] Upload documents to Firebase Storage (`coach_documents/{uid}/`).
- [x] Write `coach_profiles/{uid}` with `isProfileCompleted: true`.
- [x] Write `coach_verifications/{uid}` with initial status `'pending'`.
- [x] Implement `CoachVerificationPendingView` displaying waiting message and status explanation.

### Milestone 5: Coach Verification Status & Access Control
- [x] **State**: `CoachVerificationStatusCubit`:
  - Listen to real-time status updates from `coach_verifications/{uid}` (`pending`, `approved`, `rejected`).
  - Account suspension handled at the `UserModel` level (`users/{uid}` `status: 'active' | 'suspended'`).
- [x] **Flows & Views**:
  - **Pending**: Display status explanation card, contact support, and refresh button.
  - **Approved**: Automatically navigate to `CoachDashboardView` with full coach feature access.
  - **Rejected**: Display rejection reason banner from admin; enable coach to edit profile, re-upload documents, and resubmit application.
  - **User Suspension**: Enforced at user session level (`UserModel.status`), blocking access across all user roles.

### Milestone 6: Trainee Feature 1 — Sports & Coach Discovery
- [x] **State**: `CoachDiscoveryCubit`:
  - Fetch approved coaches from `coach_profiles` collection where verification status is `'approved'`.
  - Filter state: Sport category, price range (`minPrice` / `maxPrice`), experience years, coach gender, minimum rating.
  - Sorting state: Price: Low → High, Price: High → Low, Rating: High → Low.
  - Text search: Search coaches by name or Sports.
- [x] **Widgets**:
  - `SportsHorizontalSelector`: Scrollable category chips (Gym, Football, Boxing, Swimming, Basketball, Tennis, etc.).
  - `CoachSearchBar`: Search input with debounce and filter icon.
  - `CoachFilterBottomSheet`: Sliders for price range, checkboxes for experience levels and gender, sort options.
  - `CoachCard`: Avatar, Name, Sports badges, Rating star, Experience badge, Session price chip, and Tap to view profile.
  - `EmptyDiscoveryState` & `ShimmerCoachListLoading`.

### Milestone 7: Trainee Feature 2 — Detailed Coach Profile
- [x] **State**: `CoachProfileDetailsCubit`:
  - Loads complete coach details, credentials, and schedule preview.
- [x] **Widgets**:
  - `CoachProfileHeader`: Avatar, verified badge, coach name, sport tags, city & country.
  - `CoachBioSection`: Coach biography and about text.
  - `CoachCredentialsSection`: Years of experience, certifications, spoken languages.
  - `CoachPricingCard`: Highlighted session price and included service type.
  - `CoachSchedulePreview`: Visual representation of available training days and hours.
  - `RequestTrainingButton`: Prominent sticky bottom action to start booking flow.

### Milestone 8: Coach Feature 1 — Coach Availability & Working Hours
- [ ] **State**: `CoachAvailabilityCubit`:
  - Load and update coach schedule in `coach_profiles/{uid}`: `workingDays`, `workingHours`, `sessionDurationMinutes`.
- [ ] **Widgets**:
  - `DaySelectorRow`: Toggle available days of the week (Monday — Sunday).
  - `TimeSlotConfigurator`: Select start time and end time for each active day.
  - `SlotDurationPicker`: Default session duration (e.g., 45 min, 60 min, 90 min).
  - `SaveAvailabilityButton`: Persist availability to Firestore with validation against invalid time ranges.

### Milestone 9: Marketplace Transaction — Training Request & Booking
- [ ] **State**: `BookingRequestCubit`:
  - Validate selected date against coach working days.
  - Compute available time slots for chosen date, filtering out already booked/pending sessions.
  - Submit booking request with status `'pending'` to `bookings` collection.
- [ ] **Widgets**:
  - `BookingDatePicker`: Interactive calendar / horizontal date strip showing coach's working days.
  - `TimeSlotsGridView`: Selectable time chips showing available slots for the selected day.
  - `BookingNotesInput`: Optional field for trainee to specify goals, injuries, or notes.
  - `BookingSummaryCard`: Price, coach name, sport, date, and selected time slot.
  - `ConfirmRequestButton`: Submit request and transition to `BookingSuccessView`.

### Milestone 10: Coach Feature 2 — Coach Dashboard & Request Management
- [ ] **State**: `CoachBookingsCubit`:
  - Real-time listener for incoming booking requests (`bookings` where `coachUid == currentUid`).
  - Filter tabs: `Pending Requests`, `Confirmed Sessions`, `Completed / Past`.
- [ ] **Widgets**:
  - `IncomingRequestCard`: Trainee avatar, name, requested sport, date & time, trainee notes, and Action Buttons:
    - **Accept**: Changes booking status to `'confirmed'`.
    - **Reject**: Opens dialog with optional rejection reason, updates status to `'rejected'`.
  - `ConfirmedSessionCard`: Upcoming confirmed training sessions with countdown and trainee details.
  - `EmptyBookingsState`: Illustrated placeholder when no requests are pending.

### Milestone 11: Trainee Feature 3 — Trainee Bookings & History
- [ ] **State**: `TraineeBookingsCubit`:
  - Real-time stream of trainee bookings (`bookings` where `traineeUid == currentUid`).
  - Segmented view: `Active & Pending` vs. `Completed & History`.
- [ ] **Widgets**:
  - `TraineeBookingCard`: Coach name, photo, sport badge, date, time slot, and Status Badge (`pending` = orange, `confirmed` = green, `rejected` = red).
  - `BookingDetailsModal`: Full session details, coach contact info (if confirmed), and status timeline.
  - `CancelRequestButton`: Allows trainee to cancel a pending request before coach confirmation.

### Milestone 12: Feature 4 — Push Notifications (FCM)
- [ ] **Setup & Service**:
  - Initialize Firebase Cloud Messaging in `lib/core/services/notification_service.dart`.
  - Request user notification permissions on Android 13+ and iOS.
  - Store FCM token in `fcm_tokens/{uid}` upon login.
- [ ] **Notification Triggers**:
  - **New Request**: Notify Coach: *"You have received a new training request from [Trainee Name]"*.
  - **Request Accepted**: Notify Trainee: *"Your training request with Coach [Coach Name] has been accepted!"*.
  - **Request Rejected**: Notify Trainee: *"Your training request with Coach [Coach Name] was declined"*.
- [ ] **In-App Foreground Handling**:
  - Display non-intrusive in-app banner / snackbar when a notification arrives while the app is foregrounded.
  - Deep-link user to the relevant booking screen when notification is tapped.

### Milestone 13: Localization, Accessibility & MVP Hardening
- [ ] Define all strings in both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb`.
- [ ] Run `flutter pub run intl_utils:generate` and remove every hardcoded string in the UI.
- [ ] Verify RTL layouts for Arabic: ensure back buttons, lists, cards, and icons mirror properly.
- [ ] Ensure offline resilience with `internet_connection_checker_plus` and clear network error banners.
- [ ] Write unit tests for `CoachDiscoveryCubit`, `BookingRequestCubit`, and `CoachBookingsCubit`.
- [ ] Configure Android and iOS release configurations (ProGuard, permissions, icons, launch screens).

---

## 5. File Structure Reference

```
lib/
├── core/
│   ├── constant/
│   │   └── app_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── helpers/
│   │   └── message.dart
│   ├── locator_service/
│   │   └── service_locator.dart
│   ├── navigator/
│   │   ├── app_router.dart
│   │   ├── app_routes.dart
│   │   └── auth_route_resolver.dart
│   ├── services/
│   │   ├── firestore_service.dart
│   │   ├── notification_service.dart
│   │   └── storage_service.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   └── app_theme.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── custom_app_bar.dart
│       └── status_badge.dart
├── features/
│   ├── splash/
│   │   └── presentation/views/splash_view.dart
│   ├── onboarding/
│   │   └── presentation/views/onboarding_view.dart
│   ├── auth/
│   │   ├── choose_role/
│   │   ├── sign_in/
│   │   ├── sign_up/
│   │   └── forget_password/
│   ├── trainee_setup/
│   │   ├── data/
│   │   │   ├── data_source/trainee_setup_remote_data_source.dart
│   │   │   ├── models/trainee_profile_model.dart
│   │   │   └── repos/trainee_setup_repo.dart
│   │   └── presentation/
│   │       ├── view_model/trainee_setup_cubit/
│   │       ├── views/trainee_setup_view.dart
│   │       └── widgets/
│   ├── coach_setup/
│   │   ├── data/
│   │   │   ├── data_source/coach_setup_remote_data_source.dart
│   │   │   ├── models/coach_profile_model.dart
│   │   │   └── repos/coach_setup_repo.dart
│   │   └── presentation/
│   │       ├── view_model/coach_setup_cubit/
│   │       ├── views/
│   │       │   ├── coach_registration_view.dart
│   │       │   └── coach_verification_pending_view.dart
│   │       └── widgets/
│   ├── trainee_discovery/
│   │   ├── data/
│   │   │   ├── data_source/discovery_remote_data_source.dart
│   │   │   └── repos/discovery_repo.dart
│   │   └── presentation/
│   │       ├── view_model/coach_discovery_cubit/
│   │       ├── views/trainee_home_view.dart
│   │       └── widgets/
│   │           ├── sports_horizontal_selector.dart
│   │           ├── coach_search_bar.dart
│   │           ├── coach_card.dart
│   │           └── coach_filter_bottom_sheet.dart
│   ├── coach_profile_details/
│   │   ├── presentation/
│   │   │   ├── view_model/coach_profile_details_cubit/
│   │   │   ├── views/coach_details_view.dart
│   │   │   └── widgets/
│   │   │       ├── coach_profile_header.dart
│   │   │       ├── coach_credentials_section.dart
│   │   │       ├── coach_pricing_card.dart
│   │   │       └── coach_schedule_preview.dart
│   ├── coach_availability/
│   │   ├── data/
│   │   │   └── repos/coach_availability_repo.dart
│   │   └── presentation/
│   │       ├── view_model/coach_availability_cubit/
│   │       ├── views/coach_availability_view.dart
│   │       └── widgets/
│   │           ├── day_selector_row.dart
│   │           └── time_slot_configurator.dart
│   ├── bookings/
│   │   ├── data/
│   │   │   ├── models/booking_model.dart
│   │   │   └── repos/bookings_repo.dart
│   │   └── presentation/
│   │       ├── view_model/
│   │       │   ├── booking_request_cubit/
│   │       │   ├── trainee_bookings_cubit/
│   │       │   └── coach_bookings_cubit/
│   │       ├── views/
│   │       │   ├── booking_request_view.dart
│   │       │   ├── trainee_bookings_view.dart
│   │       │   └── coach_dashboard_view.dart
│   │       └── widgets/
│   │           ├── booking_date_picker.dart
│   │           ├── time_slots_grid_view.dart
│   │           ├── incoming_request_card.dart
│   │           ├── confirmed_session_card.dart
│   │           └── trainee_booking_card.dart
│   └── notifications/
│       └── presentation/widgets/in_app_notification_banner.dart
├── firebase_options.dart
├── generated/
├── l10n/
│   ├── intl_ar.arb
│   └── intl_en.arb
└── main.dart
```

---

## 6. Features Excluded from MVP (Strictly Deferred)

To preserve speed and simplicity, the following features are intentionally **excluded** from the initial MVP release and must not be implemented until after validation:

- ❌ Online in-app payment gateways (Stripe, Paymob, Apple Pay)
- ❌ Coach digital wallets and fund withdrawals
- ❌ Recurring packages, memberships, and multi-session subscriptions
- ❌ In-app chat messaging between trainee and coach
- ❌ Voice and video calls
- ❌ Workout plans, exercise logging, and nutrition tracking
- ❌ Automated AI coach matching algorithms
- ❌ Complex public ratings and review creation system
- ❌ Advanced multi-location club or gym facility management

---

## 7. Future Expansion Roadmap

Following MVP validation of the core loop (`Find coach → View profile → Request session → Accept/Reject`), future phases will introduce:

1. **Phase A — Direct Communication**:
   - 1-on-1 text chat with media attachments.
   - Session reminder notifications.
2. **Phase B — Integrated Payments & Monetization**:
   - Digital payments for confirmed sessions.
   - Platform commission deduction.
   - Coach wallet balance and bank payout requests.
3. **Phase C — Training & Workout Management**:
   - Coach-assigned personalized workout plans.
   - Exercise video library.
   - Nutrition guidance and trainee body measurements / progress photos.
4. **Phase D — Trust & Community**:
   - Trainee verified reviews and 5-star rating breakdowns.
   - Verified Coach badge tiers.
   - Trainee reports and dispute resolution.
