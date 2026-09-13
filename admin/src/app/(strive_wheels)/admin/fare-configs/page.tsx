import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

import { FareConfigsClient } from "@/features/admin/fare-configs";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN, UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <FareConfigsClient />
      </div>
    </RoleGuard>
  );
}

