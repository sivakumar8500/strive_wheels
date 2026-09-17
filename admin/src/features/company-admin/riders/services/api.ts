import apiService from "@/services/apiService";
import COMPANY_RIDERS_ENDPOINTS from "./endpoints";
import { CompanyRider, AssignRiderRequest, UpdateRiderRequest } from "../types";
export async function getCompanyRiders(): Promise<CompanyRider[]> {

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: CompanyRider[];
  }>(COMPANY_RIDERS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function assignCompanyRider(data: AssignRiderRequest): Promise<CompanyRider> {

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: CompanyRider;
  }>(COMPANY_RIDERS_ENDPOINTS.ASSIGN, data);

  return response.data;
}

export async function updateCompanyRider(id: number, data: UpdateRiderRequest): Promise<CompanyRider> {

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: CompanyRider;
  }>(COMPANY_RIDERS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteCompanyRider(id: number): Promise<void> {

  await apiService.delete(COMPANY_RIDERS_ENDPOINTS.DELETE(id));
}
