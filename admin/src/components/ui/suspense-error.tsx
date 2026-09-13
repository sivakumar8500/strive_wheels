import { AlertCircle } from "lucide-react";

interface SuspenseErrorProps {
  title?: string;
  description?: string;
}

export function SuspenseError({
  title = "Something went wrong",
  description = "We encountered an error while trying to fetch this data. Please try refreshing the page.",
}: SuspenseErrorProps) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[400px] w-full p-8 text-center bg-white border border-red-200 rounded-xl">
      <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center mb-4">
        <AlertCircle className="w-6 h-6 text-red-600" />
      </div>
      <h3 className="text-lg font-bold text-slate-900 mb-2">{title}</h3>
      <p className="text-slate-500 text-sm max-w-[300px]">{description}</p>
    </div>
  );
}
