import API from "@/config/common";
import AUTH_ENDPOINTS from "@/features/auth/services/authEndpoints";
import UPLOAD_ENDPOINTS from "./uploadEndpoints";
import USERS_ENDPOINTS from "@/features/admin/users/services/usersEndpoints";

// Type for API endpoints
type EndpointValue = string | ((...args: any[]) => string);  

export interface ApiEndpoints {
  [key: string]: EndpointValue;
}

export interface ApiConfig {
  BASE_URL: string;
  ENDPOINTS: Readonly<ApiEndpoints>;
}

const endpoints: ApiEndpoints = {
  ...AUTH_ENDPOINTS,
  ...USERS_ENDPOINTS,
  ...UPLOAD_ENDPOINTS,
};

const frozenEndpoints = Object.freeze(endpoints);

const API_CONFIG: ApiConfig = {
  BASE_URL: API.BASE_URL as string,
  ENDPOINTS: frozenEndpoints,
};

export default API_CONFIG;
export { API_CONFIG };
