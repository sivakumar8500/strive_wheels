import { Suspense } from "react";
import { SuspenseLoader } from "@/components/ui/suspense-loader";
import AccountDetailsClient from "@/features/settings/components/AccountDetailsClient";

export default function AccountDetailsPage() {
  return (
    <Suspense
      fallback={
        <SuspenseLoader
          title="Loading Account Details..."
          description="Fetching your account information."
        />
      }
    >
      <AccountDetailsClient />
    </Suspense>
  );
}
