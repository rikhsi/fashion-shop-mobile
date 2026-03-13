# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

Fashion Shop is a Flutter mobile app (online clothing store) built with Clean Architecture, BLoC state management, and feature-first structure. See `README.md` for full architecture and tech stack details.

### Environment

- **Flutter 3.41.4** (Dart 3.11.1) installed at `/opt/flutter`
- **Android SDK** at `/opt/android-sdk` (platform 36, build-tools 36.0.0)
- PATH must include `/opt/flutter/bin`, `/opt/flutter/bin/cache/dart-sdk/bin`, and `$ANDROID_HOME/cmdline-tools/latest/bin`
- These are already configured in `~/.bashrc`

### Common commands

Per `README.md`:

```bash
flutter pub get                                            # Install dependencies
dart run build_runner build --delete-conflicting-outputs   # Code generation (injectable, mockito mocks)
flutter analyze                                            # Lint checks
flutter test                                               # Unit tests (all use mocks, no backend needed)
flutter run -d chrome                                      # Run in Chrome (web)
flutter run -d web-server --web-port=8080                  # Run headless web server for testing
flutter build apk --debug                                  # Build Android debug APK
```

### Non-obvious caveats

- The project was created for Android/iOS only. Web platform support was added via `flutter create --platforms web .` to enable running/testing in the cloud VM (no emulator available). The `web/` directory may not be committed to `main`.
- The backend API (`https://api.fashionshop.com/v1`) is external and not included in this repo. OTP send/verify will fail at runtime, but all unit tests pass because they use Mockito mocks.
- After changing any file annotated with `@injectable` or `@mockito` annotations, re-run `dart run build_runner build --delete-conflicting-outputs` to regenerate DI config and mock classes.
- `flutter pub get` must be run before `build_runner` — the generated files depend on resolved packages.
