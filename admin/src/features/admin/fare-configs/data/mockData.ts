import { FareConfigurationsResponse } from "../types";

export const MOCK_FARE_CONFIGS: FareConfigurationsResponse = {
  global_base_fare: null,
  global_per_km_rate: null,
  global_surge_multiplier: 1.2,
  configs: [
    {
      id: 1,
      vehicle_type_id: 1,
      vehicle_type_name: "Economy Car",
      base_fare: 50.0,
      per_km_rate: 12.0,
      is_active: true,
    },
    {
      id: 2,
      vehicle_type_id: 2,
      vehicle_type_name: "Premium Sedan",
      base_fare: 80.0,
      per_km_rate: 18.0,
      is_active: true,
    },
    {
      id: 3,
      vehicle_type_id: 3,
      vehicle_type_name: "SUV / XL",
      base_fare: 120.0,
      per_km_rate: 22.0,
      is_active: true,
    },
    {
      id: 4,
      vehicle_type_id: 4,
      vehicle_type_name: "Bike Taxi",
      base_fare: 20.0,
      per_km_rate: 8.0,
      is_active: true,
    },
  ],
};
