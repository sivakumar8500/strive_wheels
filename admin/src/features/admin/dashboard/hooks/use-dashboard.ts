import { useQuery } from "@tanstack/react-query";
import { getDashboardStats } from "../services/dashboardApi";

export const DASHBOARD_QUERY_KEY = ["dashboardStats"];

export function useDashboardStats() {
  return useQuery({
    queryKey: DASHBOARD_QUERY_KEY,
    queryFn: getDashboardStats,
  });
}
