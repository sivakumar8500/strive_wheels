import apiService from "@/services/apiService";
import COMPANY_PROFILE_ENDPOINTS from "./endpoints";
import { CompanyProfile } from "../types";
import { MOCK_COMPANY_PROFILE } from "../data/mockData";

const USE_MOCK_DATA = true;

export async function getCompanyProfile(): Promise<CompanyProfile> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(MOCK_COMPANY_PROFILE);
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: CompanyProfile;
  }>(COMPANY_PROFILE_ENDPOINTS.GET_PROFILE);

  return response.data;
}
