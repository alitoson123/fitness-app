# CoachHub (`fitness_app`)

A Flutter mobile marketplace connecting **Trainees** with verified **Sports & Fitness Coaches** across 15+ sports. CoachHub supports passwordless phone OTP authentication, per-sport online and multi-location physical training, dual USD pricing (per session and monthly packages), granular session-level rescheduling, bilingual English/Arabic localization, and real-time push & in-app notifications powered by Firebase.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Supported Sports](#supported-sports)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Firebase & Firestore Schema](#firebase--firestore-schema)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Additional Documentation](#additional-documentation)

---

## Overview

CoachHub serves two primary user roles inside one mobile application:

- **Trainees** discover verified coaches by sport, price, experience, gender, and rating, book either **single sessions** or **monthly training packages** (online or at a coach's physical club/gym), manage booking updates and reschedules, and track completed training days.
- **Coaches** complete a multi-step onboarding and document verification flow, configure weekly availability, set USD session and monthly rates, define online/in-person venues per sport, and manage incoming requests with approve, reject-with-reason, reschedule, and session-completion actions.

> **Note:** A companion Flutter Web Admin Dashboard (`fitness_app_dashboard`) shares the same Firebase backend (`coach-hub-app-522cd`) for coach verification review, user moderation, and admin notifications. See [`ADMIN_WEB_ROADMAP.md`](ADMIN_WEB_ROADMAP.md) for details.

---

## Key Features

### Authentication & Role Routing
- **Phone OTP Sign-In**: SMS verification via Firebase Auth and 6-digit PIN input (`pinput`), with carrier-prefix validation for **Egypt (`+20`)** and **Lebanon (`+961`)**.
- **Role Selection & Smart Routing**: First-time users choose between **Trainee** and **Coach** (`ChooseRoleView`). `AuthRouteResolver` automatically routes returning users based on account status (`active` / `suspended`), profile completion, and coach verification approval.
- **Account Management**: Sign out and account deletion flows with Hive local cache cleanup.

### Trainee Experience
- **Multi-Step Onboarding**: Personal details, profile avatar upload, sport interests, experience level (`Beginner`, `Intermediate`, `Advanced`), and training goals.
- **Coach Discovery**: Real-time listing of approved coaches with text search, horizontal sport chips, sorting, and a filter sheet (USD price range, minimum years of experience, coach gender, and minimum rating).
- **Coach Profile Details**: Verified badge, bio, qualifications, spoken languages, dual USD pricing comparison, per-sport delivery modes (`Online` / physical locations), and weekly availability preview.
- **Flexible Booking Flow**:
  - Choose **Single Session** or **Monthly Package** in **USD (`$`)**.
  - Select the sport and preferred delivery mode (`Online` or one of the coach's configured physical venues for that sport).
  - Real-time slot conflict checking against existing pending/confirmed bookings.
- **Bookings & Reschedule Resolution**: Real-time booking list with status badges, ability to accept or decline coach reschedule proposals (single or individual monthly sessions), and ability to request reschedules on active monthly sessions.
- **Training Insights & Profile**: Edit profile/avatar, switch app language (**English / Arabic**), toggle notifications, and track unique completed training days across **Day / Month / Year** periods.

### Coach Experience
- **5-Step Verification Wizard**:
  1. Personal information & profile photo
  2. Professional info, sports, and **per-sport delivery configuration** (Online availability + multiple physical clubs/gyms)
  3. Dual USD pricing (`sessionPriceUSD`, `monthlyPriceUSD`) & preliminary working schedule
  4. Identity & certificate document uploads to Firebase Storage
  5. Review summary & submission (with local Hive draft persistence)
- **Verification Gate**: Real-time status monitoring (`pending`, `approved`, `rejected`) displaying admin rejection reasons and allowing coaches to edit and resubmit applications.
- **4-Tab Coach Shell**:
  - **Dashboard**: Summary metrics and quick navigation.
  - **Bookings**: Pending request counter badge and 3-way actions (**Approve**, **Reject with Reason**, **Propose Reschedule**).
  - **Availability**: Configure working days, time ranges, and session durations.
  - **Profile**: View/edit public details, per-sport locations, USD rates, verification certificates, language, and account controls.
- **Granular Monthly Package Management**: Pick a specific session inside a monthly package to propose a reschedule without disrupting other sessions, view full chronological session rosters (`MonthlySessionsScheduleSheet`), and mark individual sessions as **Completed**.

### Notifications & Localization
- **Unified Multi-Role Notification Engine**: Bilingual (`en` / `ar`) Firestore notifications (`notifications` & `admin_notifications`) dispatched across booking creation, approval, rejection, cancellation, single/monthly reschedules, and session completions.
- **Push & Foreground Alerts**: Firebase Cloud Messaging (`firebase_messaging`) integrated with `flutter_local_notifications` for high-priority Android alerts, FCM token sync (`fcm_tokens/{uid}`), and deep-linking directly to booking details.
- **In-App Notification Center**: Unread badge indicator (`NotificationIconButton`), category filters (`All`, `Bookings`, `Admin`), mark-all-as-read, and swipe-to-delete.
- **Bilingual RTL/LTR & Theme**: Full English (LTR) and Arabic (RTL) localization via `intl_utils` ARB files (`lib/l10n/intl_en.arb`, `lib/l10n/intl_ar.arb`), styled in a sporty dark Material 3 theme scaled with `flutter_screenutil`.

---

## Supported Sports

15 predefined sports with localized names and icons, plus support for adding custom sports:

`Football` • `Basketball` • `Swimming` • `Tennis` • `Running` • `Boxing` • `Gym` • `Cycling` • `Martial Arts` • `Volleyball` • `Padel` • `Badminton` • `Table Tennis` • `CrossFit` • `Handball` • `+ Custom Sport`

---

## Tech Stack

| Category | Packages / Tools |
| :--- | :--- |
| **Framework** | Flutter, Dart (`sdk: ^3.10.4`) |
| **State Management** | `flutter_bloc` (Cubit pattern) |
| **Dependency Injection** | `get_it` |
| **Navigation** | `go_router` |
| **Backend & Cloud** | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging` |
| **Local Persistence** | `hive`, `hive_flutter`, `shared_preferences` |
| **UI & Responsiveness** | `flutter_screenutil`, `google_fonts`, `cached_network_image`, `pinput`, `modal_progress_hud_nsn` |
| **Media & Files** | `image_picker`, `file_picker` |
| **Notifications** | `flutter_local_notifications` |
| **Localization** | `flutter_localizations`, `intl`, `intl_utils` |
| **Utilities** | `dartz`, `dio`, `internet_connection_checker_plus` |

---

## Architecture

The codebase follows a **pragmatic feature-first layered architecture** designed to avoid unnecessary boilerplate while keeping UI, state, and data access strictly separated:

```text
Core Services (AuthService, FirestoreService, StorageService, NotificationService, Hive)
   └──▶ Data Sources (*RemoteDataSource / *LocalDataSource)
           └──▶ Concrete Repositories (*Repo / *Repository)
                   └──▶ Cubits (flutter_bloc)
                           └──▶ Views & Modular Widgets (< 150 lines/file)
```

- **No separate Domain Entities or UseCase classes**: Data models (`UserModel`, `CoachProfileModel`, `TraineeProfileModel`, `BookingModel`, `BookingSessionModel`, `SportLocationModel`, `NotificationModel`) are shared directly across layers.
- **Centralized DI & Routing**: All services, repositories, and Cubits are wired in `lib/core/locator_service/service_locator.dart`, with routes centralized in `lib/core/navigator/app_router.dart`.

---

## Project Structure

```text
lib/
├── core/
│   ├── app_settings/         # Locale (EN/AR) & notification toggle settings
│   ├── constant/             # AppConstants (collections, Hive boxes) & AppSports
│   ├── errors/               # Failure & FirebaseFailure mapping
│   ├── helpers/              # Phone validation, snackbars, sport icons
│   ├── locator_service/      # get_it dependency injection setup
│   ├── models/               # Shared models (e.g., DayAvailability)
│   ├── navigator/            # GoRouter configuration, AppRoutes, AuthRouteResolver
│   ├── services/             # Auth, Firestore, Storage, Hive, Media, Logger, FCM
│   ├── theme/                # Sporty dark Material 3 theme, colors, spacing, typography
│   ├── utils/                # Localization helpers
│   └── widgets/              # Reusable UI components (buttons, fields, selectors, avatars)
├── features/
│   ├── splash/               # App launch & initial session/route resolution
│   ├── onboarding/           # First-time walkthrough
│   ├── auth/                 # Phone OTP sign-in, role selection, session management
│   ├── trainee_setup/        # Trainee multi-step onboarding
│   ├── trainee_discovery/    # Coach browsing, search, filters & trainee shell
│   ├── coach_profile_details/# Public coach profile viewed by trainees
│   ├── booking_request/      # Single session & monthly package booking creation
│   ├── trainee_bookings/     # Trainee bookings & reschedule resolution
│   ├── trainee_profile/      # Trainee profile editing & training insights
│   ├── coach_setup/          # 5-step coach registration & verification status gate
│   ├── coach_dashboard/      # Coach main shell, requests & monthly session controls
│   ├── coach_availability/   # Working days, time slots & session duration setup
│   ├── coach_profile/        # Dedicated coach profile & edit flows
│   ├── booking_details/      # Shared booking detail view & deep-link target
│   └── notifications/        # Bilingual dispatcher, Notification Center & badge
├── l10n/                     # intl_en.arb & intl_ar.arb localization source files
├── generated/                # Generated S localization delegates
├── firebase_options.dart     # FlutterFire configuration
└── main.dart                 # App initialization & entry point
```

---

## Firebase & Firestore Schema

The mobile app connects to Firebase project `coach-hub-app-522cd` using the following Firestore collections:

| Collection | Document ID | Purpose |
| :--- | :--- | :--- |
| `users` | `uid` | Base user record (`phoneNumber`, `countryCode`, `role`, `status`) |
| `coach_profiles` | `coachUid` | Public coach data, `sportLocations`, USD rates, working days/hours |
| `coach_verifications` | `coachUid` | Verification status (`pending` / `approved` / `rejected`), ID & certificate URLs |
| `trainee_profiles` | `uid` | Trainee demographics, sports, skill level, and fitness goals |
| `bookings` | `bookingId` | Single-session and monthly bookings (`sessions[]`, location/online, USD price, status) |
| `notifications` | `notificationId` | Bilingual (`titleEn`/`titleAr`, `bodyEn`/`bodyAr`) user notification feed |
| `admin_notifications` | `notificationId` | Event queue consumed by the Admin Web Dashboard |
| `fcm_tokens` | `uid` | Registered FCM device tokens and platform metadata |

---

## Getting Started

### Prerequisites
- Flutter SDK (compatible with Dart `^3.10.4` as specified in [`pubspec.yaml`](pubspec.yaml))
- Android Studio / Xcode for mobile emulators or physical device builds
- Firebase CLI & FlutterFire CLI (only needed if pointing to your own Firebase project)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd fitness_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Regenerate localization files** *(if you modify `lib/l10n/*.arb`)*
   ```bash
   flutter pub run intl_utils:generate
   ```

4. **Firebase Configuration**
   - This repository already includes `firebase.json`, `lib/firebase_options.dart`, `android/app/google-services.json`, and `storage.rules` configured for `coach-hub-app-522cd`.
   - To connect your own Firebase project instead:
     1. Enable **Phone Authentication** (with test numbers or SHA-1/SHA-256 fingerprints on Android), **Cloud Firestore**, **Firebase Storage**, and **Cloud Messaging** in the Firebase Console.
     2. Run `flutterfire configure` to regenerate `lib/firebase_options.dart` and platform config files.

5. **Run the app**
   ```bash
   flutter run
   ```

---

## Testing

The `test/` directory includes 34 unit and widget test files covering models, serializers, data sources, localization/calculation helpers, deep-link handling, notification dispatching, and Cubits.

Run the full test suite with:
```bash
flutter test
```

---

## Additional Documentation

- [`PROJECT_ROADMAP.md`](PROJECT_ROADMAP.md) — MVP architecture standards and Phase 1 milestones.
- [`PROJECT_ROADMAP_PHASE_2.md`](PROJECT_ROADMAP_PHASE_2.md) — Phase 2 expansion (Phone Auth, Dual USD Pricing, Per-Sport Locations, Monthly Session Rescheduling, Coach Profile, and Unified Notification Engine).
- [`ADMIN_WEB_ROADMAP.md`](ADMIN_WEB_ROADMAP.md) — Companion Admin Web Dashboard specification.
