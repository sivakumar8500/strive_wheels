import * as React from "react";
import { cn } from "@/lib/utils";
import { Info } from "lucide-react";

export interface InfoBannerProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
}

export function InfoBanner({ children, className, ...props }: InfoBannerProps) {
  return (
    <div
      className={cn(
        "rounded-xl bg-primary/10 border-l-[4px] border-l-primary px-5 py-4 text-[14.5px] text-primary font-medium flex items-center gap-2",
        className,
      )}
      {...props}
    >
      <Info className="w-4 h-4 text-primary" />
      {children}
    </div>
  );
}
