# 🚲 StriveWheels

**StriveWheels** is a high-performance, dual-application Flutter platform designed with strict **Clean Architecture**, **BLoC State Management**, and **Freezed** immutable models.

---

## 📌 Project Overview

The repository is structured as a monorepo containing two core Flutter applications:

| Application | Directory | Description |
| :--- | :--- | :--- |
| **Wheels User** | [`/wheels_user`](./wheels_user) | End-user mobile app for browsing, booking, and tracking rides. |
| **Wheels Rider** | [`/wheels_rider`](./wheels_rider) | Driver/Rider app for managing incoming ride requests, navigation, and earnings. |

---

## 🏗️ Architecture & Development Rules

All features across both applications follow non-negotiable guidelines enforced by [`AGENTS.md`](./AGENTS.md):

- **Clean Architecture**: Strictly separated into `presentation/`, `domain/`, and `data/`.
- **State Management**: **BLoC Pattern only** (zero `setState` in screen logic).
- **Dependency Injection**: Centralized DI via `GetIt` / `Injectable`.
- **Models**: Immutable models generated via `Freezed`.
- **Testing & Coverage**: Minimum **85% code coverage** required for PR approval.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.2` or later)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / Xcode (for mobile emulators)

---

## 💻 Commands to Run

### 1. Install Dependencies

Run `flutter pub get` in both project directories:

```bash
# For Wheels User App
cd wheels_user
flutter pub get
cd ..

# For Wheels Rider App
cd wheels_rider
flutter pub get
cd ..
```

---

### 2. Code Generation (Freezed, JSON, DI)

Whenever models, freezed annotations, or DI registrations are modified:

```bash
# Wheels User
cd wheels_user
flutter pub run build_runner build --delete-conflicting-outputs

# Wheels Rider
cd wheels_rider
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 3. Run Applications Locally

#### Run Wheels User App:
```bash
cd wheels_user
flutter run
```

#### Run Wheels Rider App:
```bash
cd wheels_rider
flutter run
```

#### Specify Platform or Device:
```bash
flutter run -d chrome       # Run on Web
flutter run -d android      # Run on Android Emulator
flutter run -d iphone       # Run on iOS Simulator
```

---

### 4. Run Tests & Check Code Coverage

Target coverage must be **≥ 85%**:

```bash
# Run tests with coverage in wheels_user
cd wheels_user
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run tests with coverage in wheels_rider
cd wheels_rider
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

### 5. Static Code Analysis & Formatting

```bash
# Static analysis
flutter analyze

# Format code
dart format .
```

---

### 6. Automated PR Code Review Command

To trigger the automated PR Code Review Agent:

```bash
review pr <PR_NUMBER>
# Example: review pr 23
```

---

## 📄 License & Guidelines

Refer to [`AGENTS.md`](./AGENTS.md) and [`PR_REVIEW_AGENT.md`](./PR_REVIEW_AGENT.md) for full contribution protocols and PR audit rules.
