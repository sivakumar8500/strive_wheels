# 🤖 PR Code Review Agent Protocol

This document defines the specialized agent workflow for automated pull request validation and code reviews when developer code is pushed from an internal feature branch and a PR is opened to the `main` branch.

---

## 🎯 Primary Purpose

To perform strict, automated quality control, static code analysis, and architecture compliance audits on Git Pull Requests before code can be merged into `main`, and automatically post the resulting review summary comment to the GitHub PR.

---

## 💬 Terminal / Chat Command Triggers

The Agent will automatically trigger this audit whenever a command like the following is entered:
- `review pr 23`
- `review PR #23`
- `review branch feature/user-auth`
- `pr review 23`

---

## 📋 Execution Steps on `review pr <number>` Command

When `review pr <number>` is invoked:

1. **Fetch PR Diff**:
   - `gh pr diff <number>` or `git diff main...<branch>`
2. **Static Analysis & Linting**:
   - `flutter analyze`
   - Check code quality, unused variables, imports, formatting.
3. **Clean Architecture & Mason Alignment Check**:
   - Verify `presentation/` (UI + BLoC), `domain/` (Entities + UseCases), `data/` (Freezed Models + Repositories).
4. **State Management & `setState` Audit**:
   - Strict BLoC pattern enforcement.
   - ❌ Reject if `setState` is found (outside trivial UI animation widgets) or if Provider/GetX are used.
5. **Code Coverage (> 85%) Audit**:
   - `flutter test --coverage`
   - Reject PR if coverage is **< 85%**.
6. **Post Review Comment to GitHub PR**:
   - Automatically or upon user confirmation (`yes`), post the full audit summary comment to GitHub PR `<number>`:
     `gh pr comment <number> --body-file summary.md` or `gh pr comment <number> --body "<MARKDOWN_SUMMARY>"`

---

## 📊 PR Audit Verdict Standard Output Format

```markdown
# 📢 PR Audit Report: PR #<PR_NUMBER>

## 📈 Executive Summary
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
- ❌ `coverage`: Code coverage is 78%, which is below mandatory 85% threshold.

---

## 🏁 Final PR Verdict: [ ✅ APPROVE PR | ❌ REJECT PR ]
```

---

🔥 **No PR shall be merged until all checklist items pass with `✅ APPROVE PR`.**
