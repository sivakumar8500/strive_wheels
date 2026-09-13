import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

import { PopularLocationsClient } from "@/features/admin/popular-locations";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN, UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <PopularLocationsClient />
      </div>
    </RoleGuard>
  );
}

