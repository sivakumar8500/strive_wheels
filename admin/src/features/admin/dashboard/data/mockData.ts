import { DashboardStats, RevenueDataPoint, BookingDataPoint } from "../types";

export const getMockDashboardStats = (): {
  stats: DashboardStats;
  revenueData: RevenueDataPoint[];
  bookingData: BookingDataPoint[];
} => {
  const stats: DashboardStats = {
    total_users: 15420,
    total_customers: 12850,
    total_riders: 2570,
    active_drivers_online: 430,
    active_trips_in_progress: 84,
    completed_trips_today: 1250,
    pending_driver_registrations: 18,
    total_platform_revenue: 458920.50,
    today_revenue: 34500.00,
  };

  const revenueData: RevenueDataPoint[] = [
    { month: "Jan", revenue: 24000, target: 20000 },
    { month: "Feb", revenue: 28000, target: 22000 },
    { month: "Mar", revenue: 32000, target: 25000 },
    { month: "Apr", revenue: 30000, target: 28000 },
    { month: "May", revenue: 38000, target: 30000 },
    { month: "Jun", revenue: 45231, target: 35000 },
  ];

  const bookingData: BookingDataPoint[] = [
    { day: "Mon", bookings: 45 },
    { day: "Tue", bookings: 52 },
    { day: "Wed", bookings: 38 },
    { day: "Thu", bookings: 65 },
    { day: "Fri", bookings: 88 },
    { day: "Sat", bookings: 110 },
    { day: "Sun", bookings: 95 },
  ];

  return { stats, revenueData, bookingData };
};
