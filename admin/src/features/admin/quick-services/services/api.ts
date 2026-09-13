import apiService from "@/services/apiService";
import QUICK_SERVICES_ENDPOINTS from "./endpoints";
import {
  QuickService,
  CreateQuickServiceRequest,
  UpdateQuickServiceRequest,
  ReorderQuickServicesRequest,
} from "../types";
import { MOCK_QUICK_SERVICES } from "../data/mockData";

const USE_MOCK_DATA = true;

let localMockData: QuickService[] = JSON.parse(JSON.stringify(MOCK_QUICK_SERVICES));

export async function getQuickServices(): Promise<QuickService[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([...localMockData].sort((a, b) => a.sort_order - b.sort_order));
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: QuickService[];
  }>(QUICK_SERVICES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createQuickService(data: CreateQuickServiceRequest): Promise<QuickService> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newId = Math.max(0, ...localMockData.map((s) => s.id)) + 1;
        const newSortOrder = Math.max(0, ...localMockData.map((s) => s.sort_order)) + 1;
        const newItem: QuickService = {
          ...data,
          id: newId,
          sort_order: newSortOrder,
        };
        localMockData.push(newItem);
        resolve(newItem);
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: QuickService;
  }>(QUICK_SERVICES_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateQuickService({
  id,
  data,
}: {
  id: number;
  data: UpdateQuickServiceRequest;
}): Promise<QuickService> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((s) => s.id === id);
        if (index === -1) return reject(new Error("Service not found"));
        
        localMockData[index] = { ...localMockData[index], ...data };
        resolve(localMockData[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: QuickService;
  }>(QUICK_SERVICES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteQuickService(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((s) => s.id === id);
        if (index === -1) return reject(new Error("Service not found"));
        
        localMockData.splice(index, 1);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(QUICK_SERVICES_ENDPOINTS.DELETE(id));
}

export async function reorderQuickServices(data: ReorderQuickServicesRequest): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        data.items.forEach((updateItem) => {
          const service = localMockData.find((s) => s.id === updateItem.id);
          if (service) {
            service.sort_order = updateItem.sort_order;
          }
        });
        resolve();
      }, 500);
    });
  }

  await apiService.put(QUICK_SERVICES_ENDPOINTS.REORDER, data);
}
