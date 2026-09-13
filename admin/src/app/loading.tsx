import { Loader } from "@/components/ui/loader";

export default function Loading() {
  return (
    <div className="animate-in fade-in flex h-screen w-full flex-col items-center justify-center duration-500">
      <Loader size="lg" label="Loading application..." />
    </div>
  );
}
