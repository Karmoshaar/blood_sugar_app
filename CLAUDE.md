# CLAUDE.md

Flutter app (working name Pulsey, planned rename «قطرة / Qatra») for logging
blood sugar readings. Talk to the user in Arabic.

## Start here
- `docs/ROADMAP.md`: the 10-phase plan; tick tasks you finish.
- `README.md`: architecture (feature-first, domain/data/presentation per feature).

## Commands
```bash
flutter pub get
flutter analyze      # must report "No issues found!"
flutter test         # all tests must pass before every push
dart format lib test
```

## Conventions
- New code goes in `lib/features/<feature>/{domain,data,presentation}`;
  shared code in `lib/core/`. Screens never touch SharedPreferences: screen →
  Riverpod controller → repository.
- Riverpod 3: `Notifier`/`AsyncNotifier` + `NotifierProvider`. In tests use
  `ProviderContainer.test` and `testOverrides()` from `test/test_helpers.dart`;
  the `Override` type comes from `package:flutter_riverpod/misc.dart`.
- Glucose values are stored in mg/dL; convert only for display via
  `GlucoseUnit` (`lib/features/settings/domain/app_settings.dart`).
- Storage keys are namespaced (`readings.items`, `profile.user`,
  `settings.*`). Changing a stored format needs a fallback for old data.
- Don't put user-facing claims like "treats/lowers diabetes" in the UI.

## Gotchas
- CI (`.github/workflows/flutter_ci.yml`) only runs for pushes/PRs to `main`.
- No Android SDK or Xcode in cloud sessions: Android/iOS builds and
  notifications can only be verified on the user's device.
