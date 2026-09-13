import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";
import { VehicleTypesClient } from "@/features/vehicle-types/components/VehicleTypesClient";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN]}>
      <VehicleTypesClient />
    </RoleGuard>
  );
}

