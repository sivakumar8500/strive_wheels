import { BookingsManagementClient } from "@/features/admin/bookings/components/BookingsManagementClient";
import { Metadata } from "next";
import { Suspense } from "react";
import { SuspenseLoader } from "@/components/ui/suspense-loader";
export const metadata: Metadata = {
  title: "Bookings | Admin Dashboard",
  description: "Manage bookings across the system",
};

export default function BookingsPage() {
  return (
    <div className="flex flex-col gap-4 px-8 py-4">
        <Suspense
          fallback={
            <SuspenseLoader
              title="Loading Bookings..."
              description="Fetching your bookings data."
            />
          }
        >
          <BookingsManagementClient />
        </Suspense>
      </div>
  );
}

