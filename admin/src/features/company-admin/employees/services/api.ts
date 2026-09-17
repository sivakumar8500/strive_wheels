import apiService from "@/services/apiService";
import EMPLOYEES_ENDPOINTS from "./endpoints";
import { CorporateEmployee, CreateEmployeeRequest, UpdateEmployeeRequest } from "../types";
export async function getEmployees(): Promise<CorporateEmployee[]> {

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: CorporateEmployee[];
  }>(EMPLOYEES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createEmployee(data: CreateEmployeeRequest): Promise<CorporateEmployee> {

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: CorporateEmployee;
  }>(EMPLOYEES_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateEmployee(id: number, data: UpdateEmployeeRequest): Promise<CorporateEmployee> {

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: CorporateEmployee;
  }>(EMPLOYEES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteEmployee(id: number): Promise<void> {

  await apiService.delete(EMPLOYEES_ENDPOINTS.DELETE(id));
}
