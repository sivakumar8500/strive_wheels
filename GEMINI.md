# Gemini Agent Change Log

## Date: 2026-09-17
**User:** Git User: dsriharikrishna19
**Module:** UI Standardization & Linting

### Files Modified:
- `admin/src/features/admin/dashboard/components/AdminDashboardClient.tsx`
- `admin/src/features/company-admin/employees/components/EmployeeDialog.tsx`
- `admin/src/features/company-admin/riders/components/RiderDialog.tsx`
- `admin/src/features/admin/bookings/components/CancelBookingDialog.tsx`
- `admin/src/features/admin/driver-registrations/components/DriverRegistrationDetailsClient.tsx`
- `admin/src/features/admin/coupons/components/CouponsClient.tsx`
- `admin/src/features/admin/quick-services/components/QuickServicesClient.tsx`
- `admin/src/components/shared/FormDialogHeader.tsx`
- `docs/ARCHITECTURE.md`
- `docs/roles/admin_role.md`

### Description:
Standardized UI across all admin and company admin client pages by enforcing the `PageHeader` component and extracting repeating table action menus into standardized useMemo `actions` props. Migrated all CRUD dialogs (Employees, Riders, Bookings, etc.) to use `react-hook-form` with `FormProvider` and centralized custom inputs from `components/forms/`. Enhanced `FormDialogHeader` with a `description` prop for better UX. Resolved static-component lint errors by moving inner components (e.g., `InfoItem`) outside the render cycle. Cleared all ESLint warnings (unused vars, exhaustive-deps, Next.js image tags) ensuring a stable, zero-warning production build.

---

## Date: 2026-09-15
**User:** Git User: dsriharikrishna19
**Module:** Authentication & RBAC

### Files Modified:
- `admin/src/app/(strive_wheels)/*/page.tsx` (Removed `<RoleGuard>`)
- `admin/middleware.ts` (Implemented Global Edge RBAC)
- `admin/src/features/auth/hooks/use-login.ts` (Added user_role cookie)
- `admin/src/lib/logout.ts` (Cleared user_role cookie)
- `admin/src/features/company_admin` (Deleted duplicate folder)
- `docs/ARCHITECTURE.md` (Updated RBAC and routing flow)
- `docs/auth_and_state.md` (Updated auth flow)
- `docs/logs.md` (Created logs file to store logs before every commit)

### Description:
Successfully mapped the application's routes and removed duplicate \company_admin\ feature folder. Migrated the Role-Based Access Control (RBAC) engine from a client-side Component wrapper (\<RoleGuard>\) strategy to a true Global Edge Middleware approach. The \user_role\ is now synced into a cookie on login, enabling the Next.js middleware to instantly route users securely without flashing unauthorized content.



- [logs](docs/logs.md)
