export interface LoginCredentials {
  email: string;
  password: string;
}

export interface AuthTokens {
  access_token: string;
  refresh_token?: string;
  token_type?: string;
}

export interface RefreshTokenRequest {
  refresh_token: string;
}

export interface AuthUser {
  id: string;
  email: string;
  status: string;
  user_type: string;
  phone_number?: string | null;
  first_name?: string | null;
  last_name?: string | null;
  full_name?: string | null;
  profile_image_url?: string | null;
  gender?: string | null;
  date_of_birth?: string | null;
  designation?: string | null;
  other_profile_details?: Record<string, unknown> | null;
  mfa_enabled: boolean;
  created_at: string;
  updated_at: string;
}

export interface OrgPermission {
  org_id: string;
  member_id?: string;
  org_name: string;
}

export interface UserPermissionsResponse {
  user: AuthUser;
  access_token: string;
  token_type?: string;
  organizations?: OrgPermission[];
}

export interface RefreshTokenResponse {
  access_token: string;
  refresh_token?: string;
  token_type?: string;
}

export interface PreferenceItem {
  id: string;
  title: string;
  description: string;
  checked: boolean;
}
