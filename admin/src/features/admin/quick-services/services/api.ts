import apiService from "@/services/apiService";
import QUICK_SERVICES_ENDPOINTS from "./endpoints";
import {
  QuickService,
  CreateQuickServiceRequest,
  UpdateQuickServiceRequest,
  ReorderQuickServicesRequest,
} from "../types";

export async function getQuickServices(): Promise<QuickService[]> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: QuickService[];
  }>(QUICK_SERVICES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createQuickService(data: CreateQuickServiceRequest): Promise<QuickService> {
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
  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: QuickService;
  }>(QUICK_SERVICES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteQuickService(id: number): Promise<void> {
  await apiService.delete(QUICK_SERVICES_ENDPOINTS.DELETE(id));
}

export async function reorderQuickServices(data: ReorderQuickServicesRequest): Promise<void> {
  await Promise.all(
    data.items.map((item) =>
      apiService.put(QUICK_SERVICES_ENDPOINTS.UPDATE(item.id), item)
    )
  );
}

