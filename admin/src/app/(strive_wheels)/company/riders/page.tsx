import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";
import { CompanyRidersClient } from "@/features/company-admin/riders";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.COMPANY_ADMIN, UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <CompanyRidersClient />
      </div>
    </RoleGuard>
  );
}

