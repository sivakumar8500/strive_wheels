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
  distance_km?: number;
  duration_mins?: number;
  final_fare?: number;
  created_at: string;
}

export interface BookingDetails extends Booking {
  vehicle_type_id: number;
  estimated_fare?: number;
  cancellation_reason?: string | null;
  otp?: string;
  customer: BookingCustomer;
  rider?: BookingRider | null;
}

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
