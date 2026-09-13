import { WeatherMultiplier } from "../types";

export const MOCK_WEATHER_MULTIPLIERS: WeatherMultiplier[] = [
  {
    id: 1,
    weather_code: "HEAVY_RAIN",
    multiplier: 1.4,
    description: "Heavy rainfall surge multiplier",
    is_active: true,
  },
  {
    id: 2,
    weather_code: "LIGHT_RAIN",
    multiplier: 1.15,
    description: "Light drizzle surge multiplier",
    is_active: true,
  },
  {
    id: 3,
    weather_code: "SNOW",
    multiplier: 1.8,
    description: "Snowstorm surge multiplier",
    is_active: false,
  },
  {
    id: 4,
    weather_code: "CLEAR",
    multiplier: 1.0,
    description: "Clear skies - standard pricing",
    is_active: true,
  },
];
