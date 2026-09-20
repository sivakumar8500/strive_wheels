# 🎭 StriveWheels Playwright E2E Automation Framework

A production-grade, reusable Playwright end-to-end (E2E) automation framework built for the StriveWheels Next.js Admin Panel.

---

## 🏛️ Framework Architecture

The framework is strictly layered according to SOLID and DRY principles:

```text
Tests (features/*/tests/*.spec.ts)
  ↓
Feature Pages & Modals (features/*/pages/*Page.ts, components/*Component.ts)
  ↓
Reusable UI Components (core/components/Table.ts, Form.ts, Dialog.ts, Select.ts, Toast.ts...)
  ↓
Core Base Layer (core/base/BasePage.ts, BaseComponent.ts, BaseModal.ts)
  ↓
Playwright Test Engine (@playwright/test)
  ↓
Next.js Application
```

### Key Architectural Strengths

1. **Composition Over Duplication**:
   - Every table in the application (`Users`, `Bookings`, `Coupons`, `Fare Configs`, etc.) reuses the same [`Table`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/components/Table.ts) and [`Pagination`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/components/Pagination.ts) components.
   - All forms reuse the centralized [`Form`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/components/Form.ts), [`Select`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/components/Select.ts), [`DatePicker`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/components/DatePicker.ts), and [`FileUpload`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/components/FileUpload.ts) components.
   - All modals inherit from [`BaseModal`](file:///c:/PROJECTS/strive_wheels/admin/playwright/core/base/BaseModal.ts), standardizing header titles, descriptions, submit buttons, and delete confirmations.
2. **Business-Level Page Objects**:
   - Tests read like plain English specifications (`Given` / `When` / `Then`).
   - Zero low-level selector soup (`nth-child`, fragile CSS classes) in test files.
3. **Session & Cookie Injection for Speed**:
   - `auth.fixture.ts` injects the necessary Edge Middleware cookies (`auth_token`, `user_role`) and Zustand store state (`localStorage.getItem("auth-storage")`) directly into the browser context.
   - Avoids repetitive UI logins for every test, while dedicated auth tests in `login.spec.ts` thoroughly validate the login screen itself.
4. **Resilient Locators**:
   - Prioritizes accessible roles, labels, placeholders, and stable IDs over brittle CSS paths.
5. **Collision-Free Data Builders**:
   - Builders (`UserBuilder`, `BookingBuilder`, `CouponBuilder`) generate unique, timestamped data to allow safe parallel execution.

---

## 🚀 Getting Started

### Prerequisites
* Node.js v18+
* Dependencies installed: `npm install` inside `admin/`

### Running Tests

```bash
# Run all E2E tests
npm run test:e2e

# Run tests in headed browser mode
npm run test:e2e:headed

# Run tests in Playwright Inspector debug mode
npm run test:e2e:debug

# Run only smoke tests (@smoke)
npm run test:e2e:smoke

# Run only regression tests (@regression)
npm run test:e2e:regression

# Open HTML test report
npm run test:e2e:report
```

---

## 📁 Directory Structure

```text
admin/playwright/
├── config/
│   ├── environments.ts             # Base URLs & timeout configuration per environment
│   └── playwright.config.ts        # Playwright runner settings, reporters, retries
│
├── core/
│   ├── base/
│   │   ├── BasePage.ts             # Navigation, URL check, page headers, loaders
│   │   ├── BaseComponent.ts        # Scoped locator wrapper
│   │   └── BaseModal.ts            # Dialog title, close, submit, cancel
│   │
│   ├── components/
│   │   ├── Table.ts                # DataTable rows, cells, action buttons
│   │   ├── Form.ts                 # TextInput, ToggleSwitch, validation errors
│   │   ├── Dialog.ts               # ConfirmDialog and DeleteDialog
│   │   ├── Select.ts               # Radix DropdownMenu and Select wrapper
│   │   ├── DatePicker.ts           # DateInput calendar popover
│   │   ├── FileUpload.ts           # FileDropzone and ImageUploadInput
│   │   ├── Pagination.ts           # Page items, page change, rows per page
│   │   ├── Toast.ts                # Sonner toast notifications
│   │   └── Navigation.ts           # Sidebar navigation and logout
│   │
│   ├── actions/
│   │   ├── table.actions.ts        # Row edit/delete/verify helpers
│   │   ├── form.actions.ts         # Multi-field input helpers
│   │   └── navigation.actions.ts   # Route switching helpers
│   │
│   ├── assertions/
│   │   ├── page.assertions.ts      # Page URL & title assertions
│   │   ├── table.assertions.ts     # Row visibility assertions
│   │   └── form.assertions.ts      # Field and validation error assertions
│   │
│   └── utils/
│       ├── random.utils.ts         # Unique emails, names, codes
│       ├── date.utils.ts           # Date formatters (date-fns)
│       ├── file.utils.ts           # Dummy asset generation for uploads
│       └── wait.utils.ts           # Network and condition synchronization
│
├── fixtures/
│   ├── base.fixture.ts             # Base test fixture (ApiClient, Toast)
│   ├── auth.fixture.ts             # Authenticated contexts (adminPage, companyAdminPage)
│   └── feature.fixture.ts          # Page object injection for tests
│
├── api/
│   ├── ApiClient.ts                # HTTP request wrapper for API calls
│   └── auth.api.ts                 # Direct API login helper
│
├── data/
│   ├── builders/
│   │   ├── UserBuilder.ts          # Test data builder for admin users
│   │   ├── BookingBuilder.ts       # Booking query & cancellation test data
│   │   └── CouponBuilder.ts        # Promo code test data
│   └── constants/
│       ├── credentials.ts          # Configurable test accounts
│       ├── roles.ts                # UserRole enum
│       └── routes.ts               # Centralized route strings
│
└── features/
    ├── auth/                       # LoginPage & login.spec.ts
    ├── dashboard/                  # DashboardPage & dashboard.spec.ts
    ├── users/                      # UsersPage, UserDialogComponent, & users.spec.ts
    ├── bookings/                   # BookingsPage, CancelBookingDialogComponent, & bookings.spec.ts
    └── coupons/                    # CouponsPage, CouponDialogComponent, & coupons.spec.ts
```

---

## 🏷️ Test Categorization Strategy

Tests use Playwright annotations for scalable test execution:

* **`@smoke`**: Fast sanity checks validating core availability, navigation, table rendering, and authentication.
* **`@regression`**: Comprehensive business logic covering end-to-end CRUD operations, dialog workflows, form validations, search filters, and delete confirmations.
* **`@e2e`**: Complete end-to-end multi-module operational flows.

---

## 💡 How to Add a New Feature in 3 Steps

When adding a new feature (e.g. `Vehicle Types`):

1. **Create Data Builder** in `data/builders/VehicleTypeBuilder.ts` with `valid()` and edge case data.
2. **Create Page Object** in `features/vehicle-types/pages/VehicleTypesPage.ts`:
   * Inherit from `BasePage`
   * Instantiate existing `Table`, `Pagination`, and `DeleteDialog`
   * Create modal component inheriting from `BaseModal`
3. **Write Specs** in `features/vehicle-types/tests/vehicle-types.spec.ts` using business-level actions.
