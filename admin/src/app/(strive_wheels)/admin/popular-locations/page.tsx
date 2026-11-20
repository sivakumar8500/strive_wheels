import { PopularLocationsClient } from "@/features/admin/popular-locations";

export default function Page() {
  return (
    <div className="flex flex-col gap-4 p-4 md:p-8">
        <PopularLocationsClient />
      </div>
  );
}

