import { UsersClient } from "@/features/admin/users";

export default function Page() {
  return (
    <div className="flex flex-col gap-4 p-4 md:p-8">
        <UsersClient />
      </div>
  );
}
