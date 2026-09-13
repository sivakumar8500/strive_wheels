import { Suspense } from "react";
import { AdminDashboardClient } from "@/features/admin/dashboard/components/AdminDashboardClient";
import { SuspenseLoader } from "@/components/ui/suspense-loader";
import { RoleGuard } from "@/components/auth/RoleGuard";
import { UserRole } from "@/features/roles";

export default function AdminDashboardPage() {
  return (
    <RoleGuard allowedRoles={[UserRole.ADMIN]}>
      <Suspense
        fallback={
          <SuspenseLoader
            title="Loading Dashboard..."
            description="Fetching the latest statistics and trends."
          />
        }
      >
        <AdminDashboardClient />
      </Suspense>
    </RoleGuard>
  );
}

