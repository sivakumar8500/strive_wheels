"use client";

import { Button } from "@/components/ui/button";
import { Filter } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export function DashboardHeader({
  title = "Dashboard",
  ishideFilter,
  description = "Overview of your workspace activity",
}: {
  title?: string;
  ishideFilter?: boolean;
  description?: string;
}) {
  const primaryRoleLabel = "Admin";

  const getRoleClass = () => {
    return "bg-blue-50 text-blue-600 border-blue-100";
  };

  return (
    <div className="font-outfit flex flex-col justify-between gap-4 sm:flex-row sm:items-center">
      <div className="flex flex-col gap-1.5">
        <div className="flex flex-wrap items-center gap-3">
          <h1 className="text-2xl leading-tight font-black tracking-tight text-slate-900 md:text-3xl">
            {title}
          </h1>
          <Badge
            variant="outline"
            className={`rounded-xl border px-3 py-1 text-[10px] font-bold tracking-widest uppercase ${getRoleClass()}`}
          >
            {primaryRoleLabel}
          </Badge>
        </div>
        <p className="text-sm leading-relaxed font-medium text-slate-500 md:text-base">
          {description}
        </p>
      </div>

      {!ishideFilter && (
        <div className="flex shrink-0">
          <Button
            variant="outline"
            className="h-11 w-full gap-2 rounded-xl border-slate-200 bg-white px-6 font-bold shadow-sm hover:bg-slate-50 sm:w-auto"
          >
            <Filter className="h-4 w-4" />
            Filter
          </Button>
        </div>
      )}
    </div>
  );
}
