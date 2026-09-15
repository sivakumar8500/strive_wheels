import apiService from "@/services/apiService";
import type {
  UserPermissionsResponse,
  LoginCredentials,
  AuthTokens,
  RefreshTokenResponse,
  RefreshTokenRequest,
} from "../types";
import AUTH_ENDPOINTS from "./authEndpoints";

export async function login(credentials: LoginCredentials) {
  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: AuthTokens & {
      user_id: number;
      phone: string;
      roles: string[];
      rider_profile?: unknown | null;
      customer_profile?: unknown | null;
      driver_registration?: unknown | null;
    };
  }>(AUTH_ENDPOINTS.LOGIN, {
    email_or_phone: credentials.email,
    password: credentials.password,
  });

  if (response?.success === false || !response?.data) {
    throw new Error(response?.message || "Login failed");
  }

  return response.data;
}

export async function getMe(token: string): Promise<UserPermissionsResponse> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: UserPermissionsResponse;
  }>(AUTH_ENDPOINTS.ME, token);

  if (response?.success === false || !response?.data) {
    throw new Error(response?.message || "Failed to fetch user profile");
  }

  return response.data;
}

export async function logout(accessToken: string, refreshToken: string) {
  return apiService.post(
    AUTH_ENDPOINTS.LOGOUT,
    { refresh_token: refreshToken },
    accessToken,
    {
      headers: { "X-Skip-Refresh": "true" },
    },
  );
}

export async function refreshToken(data: RefreshTokenRequest) {
  return apiService.post<RefreshTokenResponse>(
    AUTH_ENDPOINTS.REFRESH_TOKEN,
    data,
    null,
    {
      headers: { "X-Skip-Refresh": "true" },
    },
  );
}

 
export async function updateProfile(data: any) {
  return apiService.put(AUTH_ENDPOINTS.UPDATE_PROFILE, data);
}
