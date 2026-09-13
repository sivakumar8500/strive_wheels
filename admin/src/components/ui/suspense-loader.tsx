import { Loader2 } from "lucide-react";

interface SuspenseLoaderProps {
  title?: string;
  description?: string;
}

export function SuspenseLoader({
  title = "Loading...",
  description = "Please wait while we fetch the data.",
}: SuspenseLoaderProps) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[400px] w-full p-8 text-center bg-white border border-slate-200 rounded-xl">
      <Loader2 className="w-10 h-10 text-primary animate-spin mb-4" />
      <h3 className="text-lg font-bold text-slate-900 mb-2">{title}</h3>
      <p className="text-slate-500 text-sm max-w-[250px]">{description}</p>
    </div>
  );
}
