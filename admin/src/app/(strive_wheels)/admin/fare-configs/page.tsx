import { FareConfigsClient } from "@/features/admin/fare-configs";

export default function Page() {
  return (
    <div className="flex flex-col gap-4 p-4 md:p-8">
        <FareConfigsClient />
      </div>
  );
}

