import { create } from "zustand";
import { persist, devtools } from "zustand/middleware";
import type {
  AuthUser,
  OrgPermission,
  UserPermissionsResponse,
} from "../types";

export interface AuthState {
  accessToken: string | null;
  refreshToken: string | null;
  user: AuthUser | null;
  organizations: OrgPermission[];
  isLoading: boolean;
  isAuthenticated: boolean;
  setAuth: (
    tokens: { accessToken: string; refreshToken?: string },
    data: UserPermissionsResponse,
  ) => void;
  setTokens: (accessToken: string, refreshToken?: string) => void;
  logout: () => void;
  setLoading: (loading: boolean) => void;
}

export const useAuthStore = create<AuthState>()(
  devtools(
    persist(
      (set) => ({
        accessToken: null,
        refreshToken: null,
        user: null,
        organizations: [],
        isLoading: false,
        isAuthenticated: false,
        setAuth: (tokens, data) =>
          set({
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken || null,
            user: data.user,
            organizations: data.organizations || [],
            isLoading: false,
            isAuthenticated: true,
          }),
        setTokens: (accessToken, refreshToken) =>
          set({
            accessToken,
            refreshToken: refreshToken || null,
            isAuthenticated: true,
          }),
        logout: () =>
          set({
            accessToken: null,
            refreshToken: null,
            user: null,
            organizations: [],
            isLoading: false,
            isAuthenticated: false,
          }),
        setLoading: (loading) =>
          set({ isLoading: loading, isAuthenticated: false }),
      }),
      { name: "auth-storage" },
    ),
    { name: "AuthStore" },
  ),
);

export const getCurrentOrgId = (): string => {
  const store = useAuthStore.getState();
  return store.organizations?.[0]?.org_id || "";
};

export const getCurrentUserId = (): string => {
  const store = useAuthStore.getState();
  return store.user?.id || "";
};
