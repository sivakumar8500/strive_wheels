import apiService from "@/services/apiService";
import COMPANY_RIDERS_ENDPOINTS from "./endpoints";
import { CompanyRider, AssignRiderRequest, UpdateRiderRequest } from "../types";
import { MOCK_COMPANY_RIDERS } from "../data/mockData";

const USE_MOCK_DATA = true;

let mockRiders = [...MOCK_COMPANY_RIDERS];

export async function getCompanyRiders(): Promise<CompanyRider[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([...mockRiders]);
      }, 500);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: CompanyRider[];
  }>(COMPANY_RIDERS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function assignCompanyRider(data: AssignRiderRequest): Promise<CompanyRider> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newRider: CompanyRider = {
          ...data,
          id: mockRiders.length > 0 ? Math.max(...mockRiders.map((r) => r.id)) + 1 : 1,
        };
        mockRiders.push(newRider);
        resolve(newRider);
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: CompanyRider;
  }>(COMPANY_RIDERS_ENDPOINTS.ASSIGN, data);

  return response.data;
}

export async function updateCompanyRider(id: number, data: UpdateRiderRequest): Promise<CompanyRider> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = mockRiders.findIndex((r) => r.id === id);
        if (index === -1) {
          reject(new Error("Rider not found"));
          return;
        }
        mockRiders[index] = { ...mockRiders[index], ...data };
        resolve(mockRiders[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: CompanyRider;
  }>(COMPANY_RIDERS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteCompanyRider(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        mockRiders = mockRiders.filter((r) => r.id !== id);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(COMPANY_RIDERS_ENDPOINTS.DELETE(id));
}
