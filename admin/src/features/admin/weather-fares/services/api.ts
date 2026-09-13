import apiService from "@/services/apiService";
import WEATHER_FARES_ENDPOINTS from "./endpoints";
import { WeatherMultiplier, BulkUpdateWeatherRequest } from "../types";
import { MOCK_WEATHER_MULTIPLIERS } from "../data/mockData";

const USE_MOCK_DATA = true;

const localMockData: WeatherMultiplier[] = JSON.parse(JSON.stringify(MOCK_WEATHER_MULTIPLIERS));

export async function getWeatherFares(): Promise<WeatherMultiplier[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(localMockData);
      }, 300);
    });
  }

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
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        // Update local state
        data.items.forEach((updateItem) => {
          const existing = localMockData.find((w) => w.weather_code === updateItem.weather_code);
          if (existing) {
            existing.multiplier = updateItem.multiplier;
            existing.description = updateItem.description;
            existing.is_active = updateItem.is_active;
          } else {
            localMockData.push({ ...updateItem, id: Math.random() });
          }
        });

        resolve({
          success: true,
          message: "Weather dynamic fare multipliers updated successfully.",
          data: localMockData,
        });
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: any;
  }>(WEATHER_FARES_ENDPOINTS.BULK_UPDATE, data);

  return response.data;
}
