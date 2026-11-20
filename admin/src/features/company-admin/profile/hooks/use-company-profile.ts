import { useQuery } from "@tanstack/react-query";
import { getCompanyProfile } from "../services/api";

export const COMPANY_PROFILE_QUERY_KEY = ["companyProfile", "me"];

export function useCompanyProfile() {
  return useQuery({
    queryKey: COMPANY_PROFILE_QUERY_KEY,
    queryFn: getCompanyProfile,
  });
}
