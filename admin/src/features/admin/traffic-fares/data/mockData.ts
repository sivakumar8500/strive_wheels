import { TrafficMultiplier } from "../types";

export const MOCK_TRAFFIC_MULTIPLIERS: TrafficMultiplier[] = [
  {
    id: 1,
    traffic_code: "VERY_HIGH",
    multiplier: 1.5,
    description: "Severe traffic congestion surge",
    is_active: true,
  },
  {
    id: 2,
    traffic_code: "HIGH",
    multiplier: 1.25,
    description: "Heavy traffic surge (e.g., Rush Hour)",
    is_active: true,
  },
  {
    id: 3,
    traffic_code: "MODERATE",
    multiplier: 1.1,
    description: "Moderate traffic conditions",
    is_active: true,
  },
  {
    id: 4,
    traffic_code: "LOW",
    multiplier: 1.0,
    description: "Smooth flowing traffic",
    is_active: true,
  },
];
