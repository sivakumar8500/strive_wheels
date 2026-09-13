import apiService from "@/services/apiService";
import DASHBOARD_ENDPOINTS from "./dashboardEndpoints";
import { getMockDashboardStats } from "../data/mockData";
import { DashboardStats, RevenueDataPoint, BookingDataPoint } from "../types";

const USE_MOCK_DATA = true;

export async function getDashboardStats(): Promise<{
  stats: DashboardStats;
  revenueData: RevenueDataPoint[];
  bookingData: BookingDataPoint[];
}> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(getMockDashboardStats());
      }, 500);
    });
  }

  // Fetch actual stats from backend
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: DashboardStats;
  }>(DASHBOARD_ENDPOINTS.STATS);

  // The backend might not provide chart data yet, so we can mock the chart data
  // but use the real stats from the API response.
  const mockCharts = getMockDashboardStats();

  return {
    stats: response.data,
    revenueData: mockCharts.revenueData,
    bookingData: mockCharts.bookingData,
  };
}

export const dashboardApi = {};
