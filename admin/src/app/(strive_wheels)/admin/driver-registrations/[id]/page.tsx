import { DriverRegistrationDetailsClient } from "@/features/admin/driver-registrations/components/DriverRegistrationDetailsClient";

export default async function Page({ params }: { params: Promise<{ id: string }> }) {
  const resolvedParams = await params;
  const driverId = parseInt(resolvedParams.id, 10);
  return (
    <div className="flex flex-col gap-4 p-4 md:p-8">
      <DriverRegistrationDetailsClient driverId={driverId} />
    </div>
  );
}
