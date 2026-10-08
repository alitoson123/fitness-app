# Coach & Trainee Platform — MVP Roadmap

## 1. Executive Summary

Coach & Trainee is a mobile marketplace platform that connects people looking for sports training (**Trainees**) with qualified sports coaches (**Coaches**).

The MVP will focus on one clear core workflow:

> **Find a coach → View coach profile → Request training → Coach accepts or rejects**

The platform will support multiple sports and target users across the Arab world. Trainees and Coaches will use the same Flutter mobile application, while platform administration will be handled through a separate web-based Admin Dashboard.

### MVP Goals

The MVP is intended to validate the core marketplace concept by enabling:

- Trainees to create and manage their profiles.
- Coaches to apply and submit professional/verification information.
- Admins to review and approve or reject coach applications.
- Approved coaches to become discoverable by trainees.
- Trainees to search and filter coaches.
- Trainees to view detailed coach profiles.
- Coaches to define their availability.
- Trainees to request training sessions.
- Coaches to accept or reject training requests.
- Both sides to receive relevant push notifications.
- Admins to manage users, coaches, and bookings.

### MVP Scope

The first version intentionally excludes advanced platform functionality such as:

- Online payments
- Wallets and withdrawals
- Subscriptions and packages
- In-app chat
- Voice/video calls
- Workout and nutrition plans
- Progress tracking
- AI coach matching
- Advanced analytics and reporting
- Reviews and ratings

These features may be introduced in future phases after the MVP has been validated.

### Technology Direction

The mobile application will be built with:

- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging
- Hive for appropriate local persistence
- Bloc/Cubit for state management
- Clean Architecture
- Material 3

The Admin Dashboard will be a separate web application and will share the same backend/data model where appropriate.

---

## 2. Development Approach

The project will follow a **Spec-Driven Development** workflow using **Spec Kit**.

The project will not be implemented as one large specification.

Instead, the product will be divided into independent implementation phases. Each phase represents a meaningful product capability and will go through its own Spec Kit workflow.

### Standard Phase Workflow

Each phase should follow this lifecycle:

```text
Define the Feature
      ↓
/speckit.specify
      ↓
spec.md
      ↓
/speckit.clarify
      ↓
/speckit.plan
      ↓
plan.md
      ↓
/speckit.tasks
      ↓
tasks.md
      ↓
/speckit.analyze
      ↓
/speckit.implement
      ↓
/speckit.converge
      ↓
Phase Complete
```

A phase should be considered complete only when its requirements, implementation tasks, integration points, and acceptance criteria have been satisfied.

### Important Rule

Specs should describe **what the product needs to do and why**, while the generated plan and tasks define **how that capability will be implemented**.

The AI should not independently expand the MVP scope or introduce future features unless they are explicitly required by the current specification.

---

# 3. Current Progress

The following features have already been designed/implemented and should be treated as existing project functionality:

- Splash
- Authentication
- Choose Role
- Complete Trainee Profile

These features should not be recreated as new phases unless changes are explicitly required by a future specification.

The project continues from the current state.

---

# 4. MVP Phases

## Phase 1 — Coach Profile & Application

### Objective

Allow a user who chooses the Coach role to create a professional coach profile, upload verification documents, and submit an application for admin review.

### Core capabilities

- Coach profile creation
- Profile photo
- Bio
- Sports
- Specialties
- Years of experience
- Certifications
- Languages
- Location
- Training price
- Availability information
- Identity document upload
- Certificate/experience document upload
- Application submission
- Application status
- Pending state
- Rejected state
- Resubmission after rejection

### Expected result

A coach can complete an application and submit it for review.

The coach must not become visible to trainees before approval.

---

## Phase 2 — Admin Coach Verification

### Objective

Allow administrators to review and manage coach applications.

### Core capabilities

- Admin authentication/authorization
- Admin dashboard
- Coach application list
- Pending applications
- Coach profile review
- Uploaded document review
- Approve coach
- Reject coach
- Suspend coach
- View application status
- Support coach resubmission after rejection

### Expected result

Only approved coaches can become visible in the trainee marketplace.

---

## Phase 3 — Sports & Coach Discovery

### Objective

Allow trainees to discover approved coaches based on sports and basic search/filter criteria.

### Core capabilities

- Sports browsing
- Coach listing
- Approved coaches only
- Coach cards
- Coach profile preview
- Search
- Sport filtering
- Experience filtering
- Price filtering
- Gender filtering
- Basic sorting
- Empty states
- Loading states
- Error states

### Expected result

A trainee can select a sport and discover relevant approved coaches.

---

## Phase 4 — Coach Availability

### Objective

Allow coaches to define when they are available for training sessions.

### Core capabilities

- Working days
- Working hours
- Available time slots
- Add availability
- Edit availability
- Remove availability
- Availability validation
- Prevent overlapping/invalid availability

### Expected result

The system can determine which dates and times are available for a coach.

---

## Phase 5 — Training Request & Booking

### Objective

Implement the core marketplace transaction: a trainee requests a training session with a coach.

### Core flow

```text
Trainee
   ↓
Coach Profile
   ↓
Request Training
   ↓
Select Date
   ↓
Select Available Time
   ↓
Confirm Request
   ↓
Pending
   ↓
Coach Receives Request
   ↓
Accept / Reject
```

### Core capabilities

- Create training request
- Select date
- Select available time
- Validate availability
- Booking status
- Coach request list
- Accept request
- Reject request
- Booking details

### Initial booking states

```text
Pending
Confirmed
Rejected
```

Additional states such as cancellation should only be added if explicitly required by the MVP specification.

### Expected result

A trainee can request a session and a coach can accept or reject it.

---

## Phase 6 — Notifications

### Objective

Notify users about important events in the marketplace.

### Core notifications

#### New Training Request

Coach receives a notification when a trainee sends a request.

#### Request Accepted

Trainee receives a notification when the coach accepts.

#### Request Rejected

Trainee receives a notification when the coach rejects.

### Technology

Firebase Cloud Messaging (FCM).

### Expected result

Users receive timely notifications for the core booking lifecycle.

---

## Phase 7 — Booking Management

### Objective

Provide both Trainees and Coaches with a clear view of their bookings.

### Trainee capabilities

- My bookings
- Pending bookings
- Confirmed bookings
- Rejected bookings
- Booking details

### Coach capabilities

- Training requests
- Pending requests
- Confirmed bookings
- Rejected requests
- Booking details

### Expected result

Both roles can manage and review their current booking activity.

---

## Phase 8 — Admin Management

### Objective

Give the Admin control over the main marketplace entities.

### Dashboard overview

- Total coaches
- Total trainees
- Pending coach applications
- Total bookings

### Coach management

- View coaches
- View coach profiles
- Review applications
- View documents
- Approve
- Reject
- Suspend

### Trainee management

- View trainees
- View basic profile information
- Suspend users when necessary

### Booking management

- View bookings
- Coach
- Trainee
- Date
- Time
- Booking status

### Expected result

The Admin can operate and monitor the core marketplace without requiring direct database access.

---

## Phase 9 — MVP Hardening & Release Preparation

### Objective

Stabilize the completed MVP and prepare it for release.

### Areas

- Input validation
- Error handling
- Loading states
- Empty states
- Permission handling
- Firestore security rules
- Required Firestore indexes
- Notification reliability
- Edge cases
- Localization
- Accessibility checks
- Performance checks
- Unit tests
- Widget tests
- Integration testing where appropriate
- Release configuration
- Android release preparation
- iOS release preparation

### Expected result

The core MVP is stable, secure, testable, and ready for release.

---

# 5. Overall MVP Roadmap

```text
COMPLETED
│
├── Splash
├── Authentication
├── Choose Role
└── Complete Trainee Profile
       │
       ▼
Phase 1
Coach Profile & Application
       │
       ▼
Phase 2
Admin Coach Verification
       │
       ▼
Phase 3
Sports & Coach Discovery
       │
       ▼
Phase 4
Coach Availability
       │
       ▼
Phase 5
Training Request & Booking
       │
       ▼
Phase 6
Notifications
       │
       ▼
Phase 7
Booking Management
       │
       ▼
Phase 8
Admin Management
       │
       ▼
Phase 9
MVP Hardening & Release
       │
       ▼
     MVP
```

---

# 6. Future Expansion

Future functionality should be treated separately from the MVP and should not be implemented unless a dedicated specification is created.

Potential future phases include:

### Communication

- In-app chat
- Voice calls
- Video calls

### Payments

- Online payments
- Packages
- Subscriptions
- Coach wallet
- Withdrawals
- Platform commission

### Training Management

- Workout plans
- Nutrition plans
- Exercise library
- Progress tracking
- Measurements
- Progress photos

### Platform Intelligence

- Smart coach matching
- Personalized recommendations
- Advanced search

### Trust & Community

- Reviews
- Ratings
- Verified coach badge
- Reports and complaints

---

# 7. Product Principle

Every implementation decision should protect the simplicity of the MVP.

The product's core value proposition is:

> **Find a coach → View profile → Request training → Coach accepts or rejects.**

Any feature that does not directly support this core workflow should be evaluated carefully and, unless required for the MVP, deferred to a future phase.

The goal is to build a focused, usable marketplace first — then expand based on real product needs and validated user behavior.
