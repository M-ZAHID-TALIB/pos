# POS (classicon_vs)

This repository contains a Flutter-based Point of Sale (POS) application used for retail checkout, inventory management, and basic reporting. The app is configured for Firebase services (Authentication, Firestore, Storage) and targets Android, iOS, web, and desktop platforms.

**Contents**

- **Overview**: What the app does and high-level architecture.
- **Features**: Core user-facing capabilities.
- **Prerequisites**: Tools required to develop and build the app.
- **Quick start (Windows)**: Steps to run locally on Android (most common).
- **Firebase setup**: How to configure Firebase for local development.
- **Building & Release**: Common build commands and notes.
- **Project structure**: Short explanation of important folders under `lib/`.
- **Troubleshooting**: Common issues and fixes.
- **Contributing & License**: How to contribute and license notes.

## Overview

This POS app provides a lightweight point-of-sale experience for small retailers. It supports:

- Product lookup and barcode scanning (where a scanner is available)
- Adding/removing items to a sale, applying discounts, and calculating totals
- Multiple payment methods integration (offline cash first; plugin-based for card/printer)
- Inventory sync and basic reporting backed by Firebase Firestore

The app follows a Flutter provider/state-management pattern and is structured to isolate services (Firebase, local storage, printing) from UI code.

## Features

- Sales screen with item search and quick-add
- Persistent transaction history (Firestore)
- Basic inventory management (add/edit products)
- User authentication and role-based UI
- Receipt printing via supported printer plugins
- Offline-first behavior for core sales operations (limited offline persistence)

## Prerequisites

- Flutter SDK (stable) installed and on your PATH
- Android SDK and Android Studio (for Android builds)
- Xcode (macOS only, for iOS builds)
- A device or emulator for testing
- Firebase project (Firestore + Authentication + Storage) — see Firebase setup below

Recommended: run `flutter doctor` to validate your environment before starting.

## Quick start (Windows, Android emulator or device)

1. Open a terminal at the repo root: `C:\FlutterDev\PROJECTS\pos`
2. Get packages:

```powershell
flutter pub get
```

3. If using Android emulator, start it from Android Studio or via AVD manager.
4. Configure Firebase (see Firebase setup) or use the existing `app/google-services.json` for a configured debug project.
5. Launch the app:

```powershell
flutter run -d <device-id>
```

Replace `<device-id>` with the result of `flutter devices` or omit to use the default.

## Firebase setup

The app expects Firebase to be configured. A basic setup:

1. Create a Firebase project at https://console.firebase.google.com
2. Add an Android app and download `google-services.json`. Place it in `app/` (Android) — this repo already contains `app/google-services.json` for reference.
3. Add an iOS app and download `GoogleService-Info.plist` (place under the iOS Runner project when building on macOS).
4. In your Flutter project, ensure `firebase_options.dart` is generated (this repo contains `lib/firebase_options.dart` produced by `flutterfire configure`). If you need to regenerate, install and run the FlutterFire CLI:

```powershell
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Enable Authentication and Firestore rules appropriate for development. For local development, make rules permissive then tighten them before production.

## Building & Release

- Debug (run on device/emulator): `flutter run`
- APK (debug): `flutter build apk --debug`
- APK (release): `flutter build apk --release`
- Android App Bundle: `flutter build appbundle`
- iOS (on macOS): `flutter build ios --release`

Before releasing, make sure to:

- Replace demo/test Firebase config with production project settings
- Update `version` and `buildNumber` in `pubspec.yaml` and Android/iOS configs
- Test printing and payment integrations on real hardware

## Project structure (lib/)

- `lib/main.dart` — App entrypoint and environment/bootstrap
- `lib/constants/` — App-wide constants and keys
- `lib/models/` — Data models (Product, Sale, User, etc.)
- `lib/providers/` — State management (ChangeNotifiers / providers)
- `lib/screens/` — UI pages and routing
- `lib/services/` — Integrations (Firebase, printing, payment, local DB)
- `lib/theme/` — Theme and styling helpers
- `lib/utils/` — Utility helpers and extensions
- `lib/widgets/` — Reusable UI components

This separation keeps services testable and UI declarative.

## Common tasks

- Run unit tests (if present): `flutter test`
- Format code: `flutter format .` or use your editor's formatter
- Analyze for issues: `flutter analyze`

## Troubleshooting

- If `firebase_options.dart` is missing or out of date, run `flutterfire configure` to regenerate.
- Google services errors on Android: ensure `app/google-services.json` is present and package name matches the Firebase project.
- Plugin build errors: run `flutter clean` then `flutter pub get`.
- If native build fails on Windows for plugins, ensure all required native toolchains (MSVC, Android SDK) are installed.

## Contributing

Contributions are welcome. Suggested workflow:

1. Fork the repo and create a feature branch
2. Implement changes and add tests where applicable
3. Run `flutter format .` and `flutter analyze`
4. Open a PR with a clear description of changes

Please follow the existing code style and provider-based state management.

## License

This project currently does not include a license file. If you want to reuse or distribute this code, add a suitable `LICENSE` file and update the README accordingly.

---

If you'd like, I can further tailor the README with screenshots, environment-specific notes (macOS/iOS), or CI/CD instructions. Tell me which additions you prefer.
