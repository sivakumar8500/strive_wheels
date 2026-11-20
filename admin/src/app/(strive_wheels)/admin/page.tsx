import { Suspense } from "react";
import { AdminDashboardClient } from "@/features/admin/dashboard/components/AdminDashboardClient";
import { SuspenseLoader } from "@/components/ui/suspense-loader";
export default function AdminDashboardPage() {
  return (
    <Suspense
        fallback={
          <SuspenseLoader
            title="Loading Dashboard..."
            description="Fetching the latest statistics and trends."
          />
        }
      >
        <div className="flex flex-col gap-4 p-4 md:p-8">
          <AdminDashboardClient />
        </div>
      </Suspense>
  );
}

