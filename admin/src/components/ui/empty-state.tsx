import * as React from "react";
import Image from "next/image";
import { Button } from "@/components/ui/button";

interface EmptyStateProps {
  title?: string;
  description?: string;
  actionLabel?: string;
  onAction?: () => void;
  icon?: React.ReactNode;
  className?: string;
}

export function EmptyState({
  title = "No data Available",
  description,
  actionLabel,
  onAction,
  icon,
  className = "",
}: EmptyStateProps) {
  return (
    <div
      className={`flex flex-col items-center justify-center p-12 text-center animate-in fade-in-50 rounded-2xl border border-dashed border-slate-200 bg-slate-50/50 ${className}`}
    >
      <div className="mb-6 flex justify-center">
        {icon ? (
          icon
        ) : (
          <div className="relative h-16 w-48 opacity-60 grayscale transition-all hover:grayscale-0">
            <Image
              src="/logo.png"
              alt="No Data"
              fill
              className="object-contain"
            />
          </div>
        )}
      </div>

      <h3 className="text-xl font-bold text-slate-800 mb-2">{title}</h3>

      {description && (
        <p className="text-sm text-slate-500 max-w-sm mb-6">{description}</p>
      )}

      {actionLabel && onAction && (
        <Button
          onClick={onAction}
          variant="default"
          className="mt-2 bg-primary text-white shadow-md hover:shadow-lg transition-all"
        >
          {actionLabel}
        </Button>
      )}
    </div>
  );
}
