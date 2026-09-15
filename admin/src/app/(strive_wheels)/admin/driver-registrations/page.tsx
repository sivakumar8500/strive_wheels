import { DriverRegistrationsClient } from "@/features/admin/driver-registrations";

export default function Page() {
  return (
    <div className="flex flex-col gap-4 p-4 md:p-8">
        <DriverRegistrationsClient />
      </div>
  );
}

