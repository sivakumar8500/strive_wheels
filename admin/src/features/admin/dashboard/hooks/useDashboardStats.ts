"use client";

import { useQuery } from "@tanstack/react-query";
import { dashboardApi } from "../services/dashboardApi";

export function useDashboardStats() {
  return useQuery({
    queryKey: ["dashboard-stats"],
    queryFn: (dashboardApi as any).getStats,
  });
}
