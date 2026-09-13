import apiService from "@/services/apiService";
import SETTINGS_ENDPOINTS from "./settingsEndpoints";
import {
  getCurrentOrgId,
  useAuthStore,
} from "@/features/auth/store/auth.store";
import { AnnotatorProfilePayload, AnnotatorProfileResponse } from "../types";

export const getAnnotatorProfile = async () => {
  const orgId = getCurrentOrgId();
  const organizations = useAuthStore.getState().organizations;
  const memberId = organizations?.[0]?.member_id;
  return apiService.get<AnnotatorProfileResponse>(
    SETTINGS_ENDPOINTS.PROFILE(orgId, memberId),
  );
};

export const updateAnnotatorProfile = async (data: AnnotatorProfilePayload) => {
  const orgId = getCurrentOrgId();
  // const organizations = useAuthStore.getState().organizations;
  // const memberId = organizations?.[0]?.member_id;
  return apiService.patch<AnnotatorProfileResponse>(
    SETTINGS_ENDPOINTS.PROFILEUPDATE(orgId),
    data,
  );
};

const settingsApi = {
  getAnnotatorProfile,
  updateAnnotatorProfile,
};

export default settingsApi;
