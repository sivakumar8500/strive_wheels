import apiService from "@/services/apiService";
import COMPANIES_ENDPOINTS from "./endpoints";
import {
  Company,
  CreateCompanyRequest,
  UpdateCompanyRequest,
} from "../types";
import { MOCK_COMPANIES } from "../data/mockData";

const USE_MOCK_DATA = true;

const localMockData: Company[] = JSON.parse(JSON.stringify(MOCK_COMPANIES));

export async function getCompanies(): Promise<Company[]> {
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
    data: Company[];
  }>(COMPANIES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createCompany(data: CreateCompanyRequest): Promise<Company> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newId = Math.max(0, ...localMockData.map((c) => c.id)) + 1;
        const newItem: Company = {
          ...data,
          id: newId,
          current_balance: 0,
        };
        localMockData.push(newItem);
        resolve(newItem);
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: Company;
  }>(COMPANIES_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateCompany({
  id,
  data,
}: {
  id: number;
  data: UpdateCompanyRequest;
}): Promise<Company> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((c) => c.id === id);
        if (index === -1) return reject(new Error("Company not found"));
        
        localMockData[index] = { ...localMockData[index], ...data };
        resolve(localMockData[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: Company;
  }>(COMPANIES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteCompany(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((c) => c.id === id);
        if (index === -1) return reject(new Error("Company not found"));
        
        localMockData.splice(index, 1);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(COMPANIES_ENDPOINTS.DELETE(id));
}
