import apiService from "@/services/apiService";
import FARE_CONFIG_ENDPOINTS from "./endpoints";
import { FareConfigurationsResponse, BulkUpdateFareConfigRequest } from "../types";
import { MOCK_FARE_CONFIGS } from "../data/mockData";

const USE_MOCK_DATA = true;

let localMockData: FareConfigurationsResponse = JSON.parse(JSON.stringify(MOCK_FARE_CONFIGS));

export async function getFareConfigs(): Promise<FareConfigurationsResponse> {
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
    data: FareConfigurationsResponse;
  }>(FARE_CONFIG_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function bulkUpdateFareConfigs(
  data: BulkUpdateFareConfigRequest
): Promise<any> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        localMockData.global_base_fare = data.global_base_fare;
        localMockData.global_per_km_rate = data.global_per_km_rate;
        localMockData.global_surge_multiplier = data.global_surge_multiplier;
        
        data.configs.forEach((updateConfig) => {
          const existing = localMockData.configs.find(
            (c) => c.vehicle_type_id === updateConfig.vehicle_type_id
          );
          if (existing) {
            existing.base_fare = updateConfig.base_fare;
            existing.per_km_rate = updateConfig.per_km_rate;
          }
        });

        resolve({
          success: true,
          message: "Bulk fare configurations updated successfully.",
          data: localMockData,
        });
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: any;
  }>(FARE_CONFIG_ENDPOINTS.BULK_UPDATE, data);

  return response.data;
}
