import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";
import { UsersClient } from "@/features/admin/users";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.SUPER_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <UsersClient />
      </div>
    </RoleGuard>
  );
}
