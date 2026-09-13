import apiService from "@/services/apiService";
import TRAFFIC_FARES_ENDPOINTS from "./endpoints";
import { TrafficMultiplier, BulkUpdateTrafficRequest } from "../types";
import { MOCK_TRAFFIC_MULTIPLIERS } from "../data/mockData";

const USE_MOCK_DATA = true;

let localMockData: TrafficMultiplier[] = JSON.parse(JSON.stringify(MOCK_TRAFFIC_MULTIPLIERS));

export async function getTrafficFares(): Promise<TrafficMultiplier[]> {
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
    data: TrafficMultiplier[];
  }>(TRAFFIC_FARES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function bulkUpdateTrafficFares(
  data: BulkUpdateTrafficRequest
): Promise<any> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        data.items.forEach((updateItem) => {
          const existing = localMockData.find((t) => t.traffic_code === updateItem.traffic_code);
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
          message: "Traffic dynamic fare multipliers updated successfully.",
          data: localMockData,
        });
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: any;
  }>(TRAFFIC_FARES_ENDPOINTS.BULK_UPDATE, data);

  return response.data;
}
