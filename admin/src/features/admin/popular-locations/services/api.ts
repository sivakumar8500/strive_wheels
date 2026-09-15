import apiService from "@/services/apiService";
import POPULAR_LOCATIONS_ENDPOINTS from "./endpoints";
import {
  PopularLocation,
  CreatePopularLocationRequest,
  UpdatePopularLocationRequest,
} from "../types";
import { MOCK_POPULAR_LOCATIONS } from "../data/mockData";

const USE_MOCK_DATA = true;

const localMockData: PopularLocation[] = JSON.parse(JSON.stringify(MOCK_POPULAR_LOCATIONS));

export async function getPopularLocations(): Promise<PopularLocation[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([...localMockData]);
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: PopularLocation[];
  }>(POPULAR_LOCATIONS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createPopularLocation(data: CreatePopularLocationRequest): Promise<PopularLocation> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newId = Math.max(0, ...localMockData.map((l) => l.id)) + 1;
        const newItem: PopularLocation = {
          ...data,
          id: newId,
        };
        localMockData.push(newItem);
        resolve(newItem);
      }, 500);
    });
  }

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
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((l) => l.id === id);
        if (index === -1) return reject(new Error("Location not found"));
        
        localMockData[index] = { ...localMockData[index], ...data };
        resolve(localMockData[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: PopularLocation;
  }>(POPULAR_LOCATIONS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deletePopularLocation(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((l) => l.id === id);
        if (index === -1) return reject(new Error("Location not found"));
        
        localMockData.splice(index, 1);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(POPULAR_LOCATIONS_ENDPOINTS.DELETE(id));
}
