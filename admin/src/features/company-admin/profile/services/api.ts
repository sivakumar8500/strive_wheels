import apiService from "@/services/apiService";
import COMPANY_PROFILE_ENDPOINTS from "./endpoints";
import { CompanyProfile } from "../types";
export async function getCompanyProfile(): Promise<CompanyProfile> {

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: CompanyProfile;
  }>(COMPANY_PROFILE_ENDPOINTS.GET_PROFILE);

  return response.data;
}
