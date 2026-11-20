import { Suspense } from "react";
import { SuspenseLoader } from "@/components/ui/suspense-loader";
import NotificationsClient from "@/features/settings/components/NotificationsClient";

export default function NotificationsPage() {
  return (
    <Suspense
      fallback={
        <SuspenseLoader
          title="Loading Notifications..."
          description="Fetching your notification settings."
        />
      }
    >
      <NotificationsClient />
    </Suspense>
  );
}
