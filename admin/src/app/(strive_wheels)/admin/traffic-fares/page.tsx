import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

import { TrafficFaresClient } from "@/features/admin/traffic-fares";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN, UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <TrafficFaresClient />
      </div>
    </RoleGuard>
  );
}

