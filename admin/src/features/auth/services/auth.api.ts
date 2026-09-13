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
      expires_in: number;
      user: {
        id: number;
        phone: string;
        email: string;
        full_name: string;
        profile_image_url: string;
        roles: string[];
        is_active: boolean;
        is_verified: boolean;
        created_at: string;
      };
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
  // Simulate network delay
  await new Promise((resolve) => setTimeout(resolve, 300));

  return {
    user: {
      id: "mock-user-1",
      email: "admin@example.com",
      status: "active",
      user_type: "admin",
      first_name: "Mock",
      last_name: "Admin",
      full_name: "Mock Admin",
      mfa_enabled: false,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    access_token: token,
    token_type: "Bearer",
    organizations: [],
  };
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

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function updateProfile(data: any) {
  return apiService.put(AUTH_ENDPOINTS.UPDATE_PROFILE, data);
}
