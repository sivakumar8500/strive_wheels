export interface WeatherMultiplier {
  id?: number;
  weather_code: string;
  multiplier: number;
  description: string;
  is_active: boolean;
}

export interface BulkUpdateWeatherRequest {
  items: WeatherMultiplier[];
}
