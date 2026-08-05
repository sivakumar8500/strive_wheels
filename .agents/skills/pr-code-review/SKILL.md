---
name: pr-code-review
description: Automated PR review agent for Flutter projects. Triggered on commands like 'review pr 23' or 'review branch <name>'. Fetches git diff against main, verifies Clean Architecture, BLoC state management (zero setState), Freezed models, DI, code coverage > 85%, and lint quality before issuing APPROVE PR or REJECT PR, then posts the review summary comment directly to the GitHub PR.
---

# 🤖 PR Code Review Agent Skill

This skill automatically executes whenever the user enters a terminal/chat command like:
- `review pr 23` (or `review PR #23`)
- `review branch feature/user-auth`
- `pr review 23`

---

## 🛠️ Step-by-Step Execution Workflow

### Step 1: Fetch PR Diff & Branch Details
Execute terminal commands to fetch the PR diff relative to `main`:
```bash
# If PR number is given (e.g. 23):
gh pr diff 23
# Or via git:
git fetch origin pull/23/head:pr-23
git diff main...pr-23
```
If `gh` is unavailable or reviewing a local branch:
```bash
git diff main...<branch_name>
```

### Step 2: Code Quality & Analysis Audit
Run static code analysis on changed files:
```bash
flutter analyze
```
Check for:
- Linting warnings or errors.
- Unused variables/imports.
- Formatting issues (`dart format --output=none --set-exit-if-changed .`).

### Step 3: Mason & Clean Architecture Alignment Check
Inspect all added/modified files in the diff to ensure feature compliance:
- **Presentation Layer**: UI Widgets + BLoC only (`lib/features/<feature_name>/presentation/`)
- **Domain Layer**: Entities + UseCases + Repository Contracts (`lib/features/<feature_name>/domain/`)
- **Data Layer**: Freezed Models + Repositories + Data Sources (`lib/features/<feature_name>/data/`)

### Step 4: State Management & `setState` Audit
- Enforce **BLoC / Cubit** pattern exclusively.
- Check for banned items:
  - ❌ `setState` (outside basic UI animation controllers).
  - ❌ `Provider` / `GetX` / `MobX`.
  - ❌ Direct API/DB calls from UI widgets.

### Step 5: Test Execution & Coverage Audit
Run automated tests and generate coverage:
```bash
flutter test --coverage
```
Calculate code coverage across changed/total files:
- ❌ **Reject PR** if total coverage is **< 85%**.
- Ensure Unit Tests, Bloc Tests, and Widget Tests exist for new code.

### Step 6: Post Review Comment to GitHub PR
After generating the final audit summary, automatically post the verdict as a comment directly to the GitHub PR (or upon user typing `yes`):
```bash
gh pr comment <PR_NUMBER> --body-file <PATH_TO_SUMMARY_FILE>
# or
gh pr comment <PR_NUMBER> --body "<AUDIT_SUMMARY_MARKDOWN>"
```

---

## 📢 Standardized Output Summary Format

Produce a full Code Quality & Audit Summary in the chat:

```markdown
# 📢 PR Audit Report: PR #<NUMBER>

## 📉 Executive Summary
- **Target Branch**: `main`
- **Files Modified**: `<count>` files
- **Static Analysis**: 0 Errors, 0 Warnings
- **Code Coverage**: `<coverage_percentage>%` (Target: ≥ 85%)

---

## 📋 Comprehensive Audit Checklist

| Requirement | Status | Findings / Notes |
| :--- | :---: | :--- |
| **Clean Architecture Alignment** | ✅ / ❌ | Presentation, Domain, Data layers verified |
| **BLoC Pattern & Zero `setState`** | ✅ / ❌ | Checked for banned setState / Provider / GetX |
| **Freezed Models & DI** | ✅ / ❌ | Checked `@freezed` models and GetIt DI |
| **Theme & Utility Centralization** | ✅ / ❌ | Light/Dark theme & centralized widgets checked |
| **Code Coverage ≥ 85%** | ✅ / ❌ | Current coverage: X% |
| **Code Quality & Linting** | ✅ / ❌ | `flutter analyze` clean output |

---

## 🔍 Line-by-Line Findings & Violations
- ❌ `lib/features/auth/presentation/login_view.dart:45`: Banned `setState` usage found.
- ❌ `coverage`: Code coverage is 78%, which is below the mandatory 85% threshold.

---

## 🏁 Final PR Verdict: [ ✅ APPROVE PR | ❌ REJECT PR ]
```
