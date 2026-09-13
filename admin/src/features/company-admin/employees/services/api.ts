import apiService from "@/services/apiService";
import EMPLOYEES_ENDPOINTS from "./endpoints";
import { CorporateEmployee, CreateEmployeeRequest, UpdateEmployeeRequest } from "../types";
import { MOCK_CORPORATE_EMPLOYEES } from "../data/mockData";

const USE_MOCK_DATA = true;

// Mock state for in-memory operations
let mockEmployees = [...MOCK_CORPORATE_EMPLOYEES];

export async function getEmployees(): Promise<CorporateEmployee[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([...mockEmployees]);
      }, 500);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: CorporateEmployee[];
  }>(EMPLOYEES_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createEmployee(data: CreateEmployeeRequest): Promise<CorporateEmployee> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newEmployee: CorporateEmployee = {
          ...data,
          id: mockEmployees.length > 0 ? Math.max(...mockEmployees.map((e) => e.id)) + 1 : 1,
          amount_spent: 0,
        };
        mockEmployees.push(newEmployee);
        resolve(newEmployee);
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: CorporateEmployee;
  }>(EMPLOYEES_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateEmployee(id: number, data: UpdateEmployeeRequest): Promise<CorporateEmployee> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = mockEmployees.findIndex((e) => e.id === id);
        if (index === -1) {
          reject(new Error("Employee not found"));
          return;
        }
        mockEmployees[index] = { ...mockEmployees[index], ...data };
        resolve(mockEmployees[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: CorporateEmployee;
  }>(EMPLOYEES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteEmployee(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        mockEmployees = mockEmployees.filter((e) => e.id !== id);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(EMPLOYEES_ENDPOINTS.DELETE(id));
}
