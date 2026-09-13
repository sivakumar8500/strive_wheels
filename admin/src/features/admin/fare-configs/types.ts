export interface VehicleFareConfig {
  id?: number;
  vehicle_type_id: number;
  vehicle_type_name?: string;
  base_fare: number;
  per_km_rate: number;
  is_active?: boolean;
}

export interface FareConfigurationsResponse {
  global_base_fare: number | null;
  global_per_km_rate: number | null;
  global_surge_multiplier: number;
  configs: VehicleFareConfig[];
}

export interface BulkUpdateFareConfigRequest {
  global_base_fare: number | null;
  global_per_km_rate: number | null;
  global_surge_multiplier: number;
  configs: {
    vehicle_type_id: number;
    base_fare: number;
    per_km_rate: number;
  }[];
}
