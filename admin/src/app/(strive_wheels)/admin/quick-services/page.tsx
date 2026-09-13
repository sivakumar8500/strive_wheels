import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

import { QuickServicesClient } from "@/features/admin/quick-services";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN, UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <QuickServicesClient />
      </div>
    </RoleGuard>
  );
}

