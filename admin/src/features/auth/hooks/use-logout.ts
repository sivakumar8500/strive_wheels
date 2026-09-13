"use client";

import { useAuthStore } from "../store/auth.store";
import { logout as logoutApi } from "../services/auth.api";
import { performGlobalLogout } from "@/lib/logout";

export function useLogout() {
  const { accessToken, refreshToken } = useAuthStore();

  const logout = async () => {
    try {
      if (accessToken && refreshToken) {
        await logoutApi(accessToken, refreshToken);
      }
    } catch (error) {
      console.error("Logout API failed:", error);
    } finally {
      performGlobalLogout();
    }
  };

  return { logout };
}
