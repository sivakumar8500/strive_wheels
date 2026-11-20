export interface VehicleFareConfig {
  id?: number;
  vehicle_type_id: number;
  vehicle_type_name?: string;
  base_fare: number;
  min_fare?: number;
  per_km_rate: number;
  per_min_rate?: number;
  waiting_per_min_rate?: number;
  cancellation_fee?: number;
  night_charge_multiplier?: number;
  surge_multiplier?: number;
  platform_commission_pct?: number;
  ac_per_km?: number | null;
  non_ac_per_km?: number | null;
  short_distance_ac_per_km?: number | null;
  outstation_ac_per_km?: number | null;
  outstation_non_ac_per_km?: number | null;
  vehicle_age_tier?: string | null;
  outstation_min_km_per_day?: number | null;
  outstation_min_hours_per_day?: number | null;
  is_active?: boolean;
}

export interface FareConfigurationsResponse {
  global_base_fare: number | null;
  global_per_km_rate: number | null;
  global_surge_multiplier: number;
  configs: VehicleFareConfig[];
}

export interface FareConfigUpdateItem {
  vehicle_type_id: number;
  base_fare?: number | null;
  min_fare?: number | null;
  per_km_rate?: number | null;
  per_min_rate?: number | null;
  waiting_per_min_rate?: number | null;
  cancellation_fee?: number | null;
  night_charge_multiplier?: number | null;
  surge_multiplier?: number | null;
  platform_commission_pct?: number | null;
  ac_per_km?: number | null;
  non_ac_per_km?: number | null;
  short_distance_ac_per_km?: number | null;
  outstation_ac_per_km?: number | null;
  outstation_non_ac_per_km?: number | null;
  vehicle_age_tier?: string | null;
  outstation_min_km_per_day?: number | null;
  outstation_min_hours_per_day?: number | null;
}

export interface BulkUpdateFareConfigRequest {
  global_base_fare: number | null;
  global_per_km_rate: number | null;
  global_surge_multiplier: number;
  configs: FareConfigUpdateItem[];
}
