# Fashion Shop Mobile

A Flutter application for an online clothing store, built with Clean Architecture and feature-first project structure.

## Architecture

This project follows **Clean Architecture** with three layers:

- **Presentation** — UI, pages, widgets, BLoC state management
- **Domain** — Business logic, entities, repository interfaces, use cases
- **Data** — API calls, local storage, models, repository implementations

## Project Structure

```
lib/
  core/
    constants/       # App-wide constants and strings
    errors/          # Failure and exception classes
    network/         # API client with Dio, interceptors
    utils/           # Validators, base use case
    theme/           # Colors, text styles, theme data
    widgets/         # Shared UI components
    di/              # Dependency injection (GetIt)
    router/          # GoRouter configuration

  features/
    auth/
      data/          # Models, datasources, repository impl
      domain/        # Entities, repository interface, use cases
      presentation/  # Pages, widgets, BLoC

  shared/
    widgets/
    services/
    models/

  app.dart           # MaterialApp configuration
  main.dart          # Entry point
```

## Features

### Auth (Login by Phone)
- Phone number input with country code
- OTP verification (6-digit code)
- BLoC state management with two-step flow

## Tech Stack

| Category             | Package        |
|----------------------|----------------|
| State Management     | flutter_bloc   |
| Networking           | dio            |
| DI                   | get_it         |
| Routing              | go_router      |
| Functional           | dartz          |
| Testing              | mockito, bloc_test |

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Running Tests

```bash
flutter test
```
