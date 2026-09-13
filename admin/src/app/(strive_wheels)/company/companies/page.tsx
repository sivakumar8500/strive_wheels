import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

export default function Page() {
  return (
    <RoleGuard allowedRoles={[UserRole.COMPANY_ADMIN]}>
      <div className="flex flex-col gap-4 p-4 md:p-8">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold tracking-tight">Company Companies</h1>
        </div>
        <div className="rounded-md border p-8 text-center text-muted-foreground">
          <p>Company Companies table will be implemented here.</p>
        </div>
      </div>
    </RoleGuard>
  );
}

