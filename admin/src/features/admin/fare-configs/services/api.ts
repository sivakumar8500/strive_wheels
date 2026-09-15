import apiService from "@/services/apiService";
import FARE_CONFIG_ENDPOINTS from "./endpoints";
import { FareConfigurationsResponse, BulkUpdateFareConfigRequest } from "../types";

export async function getFareConfigs(): Promise<FareConfigurationsResponse> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: any;
  }>(FARE_CONFIG_ENDPOINTS.GET_ALL);

  // The backend might return an array directly under data
  if (Array.isArray(response.data)) {
    return {
      global_base_fare: null,
      global_per_km_rate: null,
      global_surge_multiplier: 1,
      configs: response.data,
    };
  }

  return response.data;
}

export async function bulkUpdateFareConfigs(
  data: BulkUpdateFareConfigRequest
): Promise<any> {
  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: any;
  }>(FARE_CONFIG_ENDPOINTS.BULK_UPDATE, data);

  return response.data;
}
