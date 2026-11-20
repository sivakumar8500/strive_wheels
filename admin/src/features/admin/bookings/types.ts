export interface BookingCustomer {
  id: number;
  user: {
    full_name: string;
    phone: string;
    email?: string;
  };
}

export interface BookingRider {
  id: number;
  user: {
    full_name: string;
    phone: string;
  };
}

export interface Booking {
  id: number;
  booking_code: string;
  customer_id: number;
  rider_id?: number | null;
  vehicle_id?: number | null;
  company_id?: number | null;
  vehicle_type_id: number;
  service_mode: "NORMAL" | "OUTSTATION" | "RENTAL" | "COURIER";
  booking_mode: "INSTANT" | "SCHEDULED" | "RESERVED";
  trip_type: "ONE_WAY" | "ROUND_TRIP";
  status:
    | "PENDING"
    | "ACCEPTED"
    | "ARRIVED"
    | "IN_TRIP"
    | "COMPLETED"
    | "CANCELLED"
    | "ADMIN_CANCELLED";
  pickup_address: string;
  pickup_lat: number;
  pickup_lng: number;
  drop_address?: string;
  drop_lat?: number;
  drop_lng?: number;
  return_drop_address?: string | null;
  return_drop_lat?: number | null;
  return_drop_lng?: number | null;
  estimated_distance_km?: number;
  estimated_duration_mins?: number;
  estimated_fare?: number;
  final_fare?: number;
  waiting_duration_mins?: number;
  scheduled_at?: string | null;
  started_at?: string | null;
  completed_at?: string | null;
  cancelled_at?: string | null;
  cancellation_reason?: string | null;
  start_otp?: string | null;
  is_drop_requested?: boolean;
  drop_request_reason?: string | null;
  drop_requested_by?: string | null;
  drop_requested_at?: string | null;
  is_drop_accepted?: boolean;
  drop_accepted_by?: string | null;
  drop_accepted_at?: string | null;
  
  // Relations returned by backend
  vehicle_type?: any | null;
  rider?: any | null;
  vehicle?: any | null;
  status_history?: any[];

  // Note: Backend does NOT return customer object. UI relies on customer_id only.
  customer?: BookingCustomer | null; // Keep optional for type safety if needed later
}

export type BookingDetails = Booking;

export interface BookingsQuery {
  skip?: number;
  limit?: number;
  status?: string;
  service_mode?: string;
  booking_mode?: string;
  customer_id?: number;
  rider_id?: number;
  search?: string;
}

export interface PaginatedBookings {
  items: Booking[];
  total: number;
  skip: number;
  limit: number;
}
