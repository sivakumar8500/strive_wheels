import { VehicleType } from "../types";

export const mockVehicleTypes: VehicleType[] = [
  {
    id: 1,
    code: "CAB",
    name: "Sedan / Hatchback Cab",
    description: "Comfortable 4-seater air-conditioned car",
    icon_url: "https://cdn.strive.com/icons/cab.png",
    max_passengers: 4,
    max_weight_kg: 150.0,
    is_active: true,
    created_at: "2026-01-01T00:00:00Z",
  },
  {
    id: 2,
    code: "AUTO",
    name: "Auto Rickshaw",
    description: "Quick 3-seater city rides",
    icon_url: "https://cdn.strive.com/icons/auto.png",
    max_passengers: 3,
    max_weight_kg: 50.0,
    is_active: true,
    created_at: "2026-01-01T00:00:00Z",
  },
  {
    id: 3,
    code: "BIKE",
    name: "Moto",
    description: "Affordable bike rides for one",
    icon_url: "https://cdn.strive.com/icons/bike.png",
    max_passengers: 1,
    max_weight_kg: 100.0,
    is_active: true,
    created_at: "2026-01-01T00:00:00Z",
  },
];
