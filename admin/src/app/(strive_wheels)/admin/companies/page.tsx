import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";
import { CompaniesClient } from "@/features/admin/companies";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.SUPER_ADMIN, UserRole.ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <CompaniesClient />
      </div>
    </RoleGuard>
  );
}
