import apiService from "@/services/apiService";
import POPULAR_LOCATIONS_ENDPOINTS from "./endpoints";
import {
  PopularLocation,
  CreatePopularLocationRequest,
  UpdatePopularLocationRequest,
} from "../types";

export async function getPopularLocations(): Promise<PopularLocation[]> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: PopularLocation[];
  }>(POPULAR_LOCATIONS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createPopularLocation(data: CreatePopularLocationRequest): Promise<PopularLocation> {
  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: PopularLocation;
  }>(POPULAR_LOCATIONS_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updatePopularLocation({
  id,
  data,
}: {
  id: number;
  data: UpdatePopularLocationRequest;
}): Promise<PopularLocation> {
  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: PopularLocation;
  }>(POPULAR_LOCATIONS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deletePopularLocation(id: number): Promise<void> {
  await apiService.delete(POPULAR_LOCATIONS_ENDPOINTS.DELETE(id));
}

