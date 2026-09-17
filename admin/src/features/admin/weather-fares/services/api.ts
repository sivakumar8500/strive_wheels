import apiService from "@/services/apiService";
import WEATHER_FARES_ENDPOINTS from "./endpoints";
import { WeatherMultiplier, BulkUpdateWeatherRequest } from "../types";

export async function getWeatherFares(): Promise<WeatherMultiplier[]> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: WeatherMultiplier[];
  }>(WEATHER_FARES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function bulkUpdateWeatherFares(
  data: BulkUpdateWeatherRequest
): Promise<any> {
  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: any;
  }>(WEATHER_FARES_ENDPOINTS.BULK_UPDATE, data);

  return response.data;
}
