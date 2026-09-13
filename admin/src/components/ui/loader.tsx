"use client";

import { cn } from "@/lib/utils";
import { Loader2 } from "lucide-react";

interface LoaderProps {
  className?: string;
  size?: "sm" | "md" | "lg" | "xl";
  label?: string;
  fullPage?: boolean;
}

const sizes = {
  sm: "h-4 w-4 stroke-[2.5px]",
  md: "h-8 w-8 stroke-[2px]",
  lg: "h-12 w-12 stroke-[1.5px]",
  xl: "h-16 w-16 stroke-[1px]",
};

export function Loader({
  className,
  size = "md",
  label,
  fullPage = false,
}: LoaderProps) {
  const loader = (
    <div
      className={cn(
        "flex flex-col items-center justify-center gap-4",
        className,
      )}
    >
      <div className="relative">
        {/* Outer Glow / Background Ring */}
        <div
          className={cn(
            "absolute inset-0 rounded-full border-2 border-zinc-200",
            size === "sm" && "border",
            sizes[size],
          )}
        />

        {/* Animated Spinner */}
        <Loader2
          className={cn(
            "text-primary animate-spin transition-all duration-300",
            sizes[size],
          )}
        />
      </div>

      {label && (
        <p className="animate-pulse text-sm font-medium text-zinc-500">
          {label}
        </p>
      )}
    </div>
  );

  if (fullPage) {
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-white/80 backdrop-blur-sm transition-all duration-500">
        {loader}
      </div>
    );
  }

  return loader;
}

export function PageLoader() {
  return (
    <div className="flex h-[50vh] w-full items-center justify-center">
      <Loader size="lg" label="Loading..." />
    </div>
  );
}
