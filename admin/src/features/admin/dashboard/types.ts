export interface DashboardStats {
  total_users: number;
  total_customers: number;
  total_riders: number;
  active_drivers_online: number;
  active_trips_in_progress: number;
  completed_trips_today: number;
  pending_driver_registrations: number;
  total_platform_revenue: number;
  today_revenue: number;
}

export interface RevenueDataPoint {
  month: string;
  revenue: number;
  target: number;
}

export interface BookingDataPoint {
  day: string;
  bookings: number;
}
