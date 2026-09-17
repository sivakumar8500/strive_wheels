# Commit Logs

This file is used to store logs and summaries of changes before every commit.

## Format Template
```markdown
### Date: [YYYY-MM-DD]
- **Author**: [USERNAME]
- **Files Modified**: [List all files modified]
- **Summary**: [Brief summary of changes]
```

---

### Date: 2026-09-17
- **Author**: dsriharikrishna19 (Gemini Agent)
- **Files Modified**: 
  - `admin/src/features/admin/traffic-fares/services/api.ts`
  - `admin/src/features/admin/traffic-fares/data/mockData.ts` (Deleted)
  - `admin/src/features/admin/weather-fares/services/api.ts`
  - `admin/src/features/admin/weather-fares/data/mockData.ts` (Deleted)
  - `admin/src/features/admin/quick-services/data/mockData.ts` (Deleted)
  - `admin/src/features/admin/popular-locations/services/api.ts`
  - `admin/src/features/admin/popular-locations/types.ts`
  - `admin/src/features/admin/popular-locations/components/PopularLocationsClient.tsx`
  - `admin/src/features/admin/driver-registrations/services/endpoints.ts`
  - `admin/src/features/admin/driver-registrations/services/api.ts`
  - `admin/src/features/admin/driver-registrations/hooks/use-drivers.ts`
  - `admin/src/features/admin/driver-registrations/components/DriverRegistrationsClient.tsx`
  - `admin/src/features/admin/driver-registrations/components/DriverRegistrationDetailsClient.tsx` (New)
  - `admin/src/app/(strive_wheels)/admin/driver-registrations/[id]/page.tsx` (New)
  - `admin/src/features/admin/driver-registrations/components/KycReviewDialog.tsx` (Deleted)
  - `admin/src/features/admin/driver-registrations/data/mockData.ts` (Deleted)
- **Summary**: Removed hardcoded mock data for traffic fares, weather dynamic fares, quick services, popular locations, and driver registrations. Updated their respective `api.ts` files to fetch and update data using real backend REST API endpoints (`/api/v1/admin/traffic-fares`, `/api/v1/admin/weather-fares`, `/api/v1/admin/quick-services`, `/api/v1/admin/popular-locations`, and `/api/v1/admin/driver-registrations`). Extracted action columns across tables into the native `actions` prop. Replaced `KycReviewDialog` with a dedicated details page at `/admin/driver-registrations/[id]` to present the driver's full KYC data and verification controls neatly, mapping to the real `REVIEW` API paths instead of mock logic.

---
### Date: 2026-09-15
- **Author**: dsriharikrishna19
- **Files Modified**: 
  - `admin/src/app/(strive_wheels)/*/page.tsx`
  - `admin/middleware.ts`
  - `admin/src/features/auth/hooks/use-login.ts`
  - `admin/src/lib/logout.ts`
  - `admin/src/features/company_admin` (Deleted)
  - `docs/ARCHITECTURE.md`
  - `docs/auth_and_state.md`
  - `GEMINI.md`
  - `docs/logs.md`
- **Summary**: Refactored Role-Based Access Control (RBAC) to use Next.js Edge Middleware for true global routing protection. Unified role management by syncing a `user_role` cookie on login/logout. Removed redundant `<RoleGuard>` wrappers across 16 pages and deleted the duplicate `company_admin` folder. Updated architecture and auth documentation to reflect the new middleware routing flow.

---

### Date: 2026-09-15
- **Author**: dsriharikrishna19 (Gemini Agent)
- **Files Modified**: 
  - `admin/src/features/vehicle-types/components/VehicleTypeFormDialog.tsx`
  - `admin/src/features/vehicle-types/validations/vehicle-type-schema.ts` (New)
  - `admin/src/components/forms/ImageUploadInput.tsx` (New)
  - `admin/src/services/tempUploadService.ts`
  - `docs/ARCHITECTURE.md`
- **Summary**: Extracted Zod validation schema for vehicle types into its own file. Created a reusable `ImageUploadInput` component that integrates seamlessly with React Hook Form, features dropzone-to-preview toggling, error handling, and robust fallbacks. Updated `tempUploadService` types to perfectly match the backend API schema. Refactored `VehicleTypeFormDialog` to use the new unified upload component and standard `FormDialogHeader`. Added documentation to `ARCHITECTURE.md` covering form image uploads.
