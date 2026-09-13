import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

import { DriverRegistrationsClient } from "@/features/admin/driver-registrations";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN, UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <DriverRegistrationsClient />
      </div>
    </RoleGuard>
  );
}

