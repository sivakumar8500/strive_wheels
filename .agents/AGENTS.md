# AGENT.md

## 🚨 Mandatory Development Guidelines (Strict Enforcement)

This document defines **non-negotiable rules** for the Flutter project.
Any violation must result in **PR rejection**.

---

# 1. Architecture (Clean Architecture - Mandatory)

* The entire application must follow **Clean Architecture**:

  * **Presentation Layer** → UI + BLoC
  * **Domain Layer** → Entities + UseCases
  * **Data Layer** → Models + Repositories + Data Sources

### Rules:

* ❌ No direct API/DB calls from UI
* ❌ No cross-layer dependency violations
* ✅ Strict separation of concerns

---

# 2. State Management (BLoC Only)

* **BLoC Pattern is mandatory**

### Not Allowed:

* ❌ Provider
* ❌ GetX
* ❌ setState (except trivial UI-only cases)

### Required:

* Bloc
* Event
* State

---

# 3. Dependency Injection (DI - Mandatory)

* All classes must use **Dependency Injection**

### Rules:

* ❌ No direct object creation inside classes
* ✅ Use centralized DI (GetIt / Injectable)

---

# 4. Models (Freezed Only)

* All models must use **Freezed**

### Rules:

* Immutable models only
* Use `copyWith`
* Use union/sealed classes where needed

---

# 5. Code Generation (Mandatory)

Used for:

* Freezed
* JSON serialization
* DI

### Command:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

# 6. Loose Coupling (Critical)

* All classes must be **loosely coupled**

### Rules:

* Use interfaces / abstract classes
* Communication via repository contracts
* ❌ No tight coupling

---

# 7. Feature Development Rules

Every feature MUST include:

* UI (Presentation)
* Bloc
* UseCase
* Repository Interface
* Repository Implementation
* Data Source
* Freezed Model

### Strict Rule:

> ❌ Do NOT create any feature without following full architecture

---

# 8. Theming (Light & Dark - Mandatory)

### Rules:

* App must support **Light & Dark themes**
* ❌ No hardcoded colors
* Every new color must have Light + Dark variant
* Use:

```dart
Theme.of(context)
```

---

# 9. Utilities (Centralized Management - Mandatory)

All reusable items must be placed in:

```
lib/core/utils/
```

### Must Include:

* Strings
* Constants (int, double)
* Enums
* Permissions
* Snackbar
* Toast
* Validators / Helpers

### Not Allowed:

* ❌ Hardcoded values in UI or logic
* ❌ Duplicate constants
* ❌ Inline snackbar/toast logic

---

# 10. Reusable Components (Mandatory)

All common UI components must be **reusable and centralized**.

### Location:

```
lib/core/widgets/
```

### Must Be Reusable:

* Buttons
* TextFields
* AppBars
* Dialogs
* BottomSheets
* Loaders / Progress indicators
* Empty / Error states
* List items / Cards

---

### Rules:

* ❌ Do NOT create duplicate UI components in multiple screens

* ❌ Do NOT write UI repeatedly

* ❌ Do NOT hardcode styles inside widgets

* ✅ Create generic, configurable components

* ✅ Use parameters for customization

* ✅ Follow theme and design system

---

### Example:

```dart
AppButton(
  title: AppStrings.login,
  onTap: () {},
  isLoading: false,
)
```

---

### Design Rule:

* All components must:

  * Follow Light/Dark theme
  * Use centralized styles
  * Be scalable and reusable

---

# 11. Testing & Code Coverage (Strict Rule)

## Coverage Requirement:

* ✅ Minimum coverage: **85%**
* ❌ <85% → Reject PR

---

## Testing Rule:

* Tests must be written alongside every feature
* ❌ No feature without tests

---

## Required Tests:

* Unit Tests
* Bloc Tests
* Widget Tests

---

## Commands:

```bash
flutter test --coverage
```

```bash
genhtml coverage/lcov.info -o coverage/html
```

---

## CI Enforcement:

* Coverage < 85% → ❌ FAIL BUILD
* Missing tests → ❌ REJECT PR

---

# 12. Strict Enforcement Policy

Any violation of:

* Clean Architecture
* BLoC Pattern
* DI
* Freezed Models
* Loose Coupling
* Theming Rules
* Utilities Rules
* Reusable Component Rules
* Testing Rules

➡️ **Code must NOT be merged**

---

# 13. Final Rule

> Without following all above rules,
> ❌ DO NOT create any class, feature, or implementation.

---

# 14. PR Code Review Agent Protocol (Mandatory PR Validation)

When the user pushes code from an internal branch and opens a PR to `main` (or provides a PR number/branch diff for review):

### Code Review Execution Protocol:
1. **Branch & Diff Inspection**:
   - Inspect all added/modified files in the PR branch relative to `main`.
2. **Mason & Clean Architecture Structure Verification**:
   - Ensure all feature files are structured using Mason conventions and strict Clean Architecture:
     - `presentation/` (UI + BLoC)
     - `domain/` (Entities + UseCases)
     - `data/` (Models + Repositories + Data Sources)
3. **State Management & `setState` Audit**:
   - Strictly enforce **BLoC Pattern**.
   - ❌ Reject if `setState` is used (outside trivial UI animation widgets), or if Provider / GetX are present.
4. **Code Coverage Validation (> 85%)**:
   - Run `flutter test --coverage`.
   - Calculate total test coverage percentage across unit tests, bloc tests, and widget tests.
   - ❌ Reject PR if code coverage is **< 85%**.
5. **Freezed & Dependency Injection Check**:
   - Validate that all models use **Freezed** (`copyWith`, immutability).
   - Validate DI registrations via GetIt/Injectable.
6. **PR Verdict Output**:
   - Present a detailed checklist audit report.
   - If 100% compliant: Output **`✅ APPROVE PR`**.
   - If any violation or coverage < 85%: Output **`❌ REJECT PR`** with explicit line-by-line violation details.

---

# ✅ Summary

| Rule                      | Status    |
| ------------------------- | --------- |
| Clean Architecture        | Mandatory |
| BLoC Pattern              | Mandatory |
| Dependency Injection      | Mandatory |
| Freezed Models            | Mandatory |
| Loose Coupling            | Mandatory |
| Light/Dark Theme          | Mandatory |
| Utilities Centralization  | Mandatory |
| Reusable Components       | Mandatory |
| Code Coverage ≥ 85%       | Mandatory |
| Mason Template Structure  | Mandatory |
| Automated PR Review Agent | Mandatory |
| Testing for Every Feature | Mandatory |

---

🔥 **These rules are NON-NEGOTIABLE and must be enforced in every PR.**
