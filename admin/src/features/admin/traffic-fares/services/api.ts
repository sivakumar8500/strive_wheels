import apiService from "@/services/apiService";
import TRAFFIC_FARES_ENDPOINTS from "./endpoints";
import { TrafficMultiplier, BulkUpdateTrafficRequest } from "../types";

export async function getTrafficFares(): Promise<TrafficMultiplier[]> {
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
  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: any;
  }>(TRAFFIC_FARES_ENDPOINTS.BULK_UPDATE, data);

  return response.data;
}

