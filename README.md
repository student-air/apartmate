```markdown
# Apart Mate Pro

**Society & apartment management, built for owners and admins.**

Apart Mate Pro is a Flutter app that helps society owners manage buildings, residents, owners, staff, join requests, complaints, and community updates — from one clean dashboard.

---

## Overview

Running a housing society means juggling approvals, occupancy, maintenance signals, and day-to-day communication. Apart Mate Pro brings those workflows into a mobile-first experience with a clear admin dashboard, structured request flows, and a codebase designed to grow from local demo data to a real backend.

| Area | What you get |
|------|----------------|
| **Dashboard** | Live stats, pending approvals, quick actions, activity, occupancy |
| **People** | Residents, owners, committee, staff |
| **Requests** | Owner & tenant join requests with accept / reject + reason |
| **Operations** | Complaints, updates / notices, society join code |
| **Auth** | Email/password and Google Sign-In (Firebase) |

---

## Features

### Dashboard
- Greeting, society identity, and join-code copy control  
- Metric cards: Buildings, Owners, Residents, Committee  
- Pending requests by category (owners, tenancy, property)  
- Quick actions with badges (e.g. open complaints)  
- Residents overview (owners vs tenants)  
- Recent activity and per-building occupancy  

### Residents & owners
- Resident list with rent / maintenance status signals  
- Detail screens and payment toggles  
- Owners directory with call actions  

### Requests
- Separate **Owners** and **Tenants** tabs  
- Accept → register as owner or resident  
- Reject → reason dialog + resubmission guidance  

### Complaints & updates
- Track and resolve complaints  
- Broadcast updates / notices to the community  

### Architecture
- **GetX** for routing and state  
- **Repository pattern** (`IAuthRepository`, `IRequestRepository`, …) so UI stays independent of data source  
- Swap local mocks for Firebase / API without rewriting screens  

---

## Tech stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter |
| State & routing | GetX |
| Auth | Firebase Auth (Email, Google) |
| Structure | Clean feature folders + domain interfaces |
| UI | Custom design system (`AppColors`, `AppTextStyles`, shared widgets) |

---

## Project structure

```text
lib/
├── core/                 # colors, dimens, text styles, shared widgets, bindings
├── data/
│   ├── models/
│   └── repositories/     # local + firebase implementations
├── domain/
│   └── repositories/     # abstract interfaces (I*Repository)
├── presentation/         # feature screens, controllers, bindings
├── routes/
└── main.dart
```

---

## Getting started

### Prerequisites
- Flutter SDK (stable)
- Android Studio / Xcode for device builds  
- Firebase project (for auth)  

### Setup

```bash
git clone https://github.com/student-air/apartmate.git
cd apartmate
flutter pub get
```

Configure Firebase for your platforms (`flutterfire configure` or place `google-services.json` / `GoogleService-Info.plist` as required).

### Run

```bash
flutter run
```

### Build release APK

```bash
flutter build apk
# or smaller per-ABI builds:
flutter build apk --split-per-abi
```

Output: `build/app/outputs/flutter-apk/`

---

## Configuration notes

- **App display name:** set in Android `AndroidManifest` (`android:label`) and iOS `Info.plist` (`CFBundleDisplayName`).  
- **Package / import name** stays `apartmate` unless you intentionally rename the Dart package.  
- **SHA-1** is required for Google Sign-In on Android (debug and release keystores).  

---

## Roadmap ideas

- [ ] Full Firebase / cloud sync for residents, requests, and complaints  
- [ ] Owner “live here / rented out” occupancy on join  
- [ ] Push notifications for applicants on accept / reject  
- [ ] Staff join request pipeline  
- [ ] Property update request type  

---

## Contributing

This is primarily a product / portfolio project. Suggestions and issues are welcome via GitHub Issues.

---

## License

Specify your license here (e.g. MIT). If private coursework or client work, note that access is restricted.

---

<p align="center">
  <b>Apart Mate Pro</b> · Built with Flutter
</p>
```

Save as `README.md` in the repo root. Swap the clone URL if your remote differs, and fill in **License** when you decide.
