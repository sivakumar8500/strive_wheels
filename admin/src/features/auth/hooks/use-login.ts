"use client";

import { useMutation } from "@tanstack/react-query";
import { useAuthStore } from "../store/auth.store";
import { login } from "../services/auth.api";
import type { LoginCredentials } from "../types";
import { toast } from "sonner";
import { useRouter } from "next/navigation";

export function useLogin() {
  const { setAuth, setLoading } = useAuthStore();
  const router = useRouter();

  return useMutation({
    mutationFn: (credentials: LoginCredentials) =>
      login(credentials),

    onSuccess: async (data, credentials) => {
      setLoading(true);
      try {
        // Set auth cookie for proxy middleware
        document.cookie = `auth_token=${data.access_token}; path=/; max-age=86400; SameSite=Strict`;
        if (data.refresh_token) {
          document.cookie = `refresh_token=${data.refresh_token}; path=/; max-age=604800; SameSite=Strict`;
        }

        // Construct `me` directly from the login token response
        const me = {
          user: {
            id: String(data.user_id),
            email: credentials.email,
            status: "active",
            user_type: data.roles?.[0]?.toLowerCase() || "admin",
            phone_number: data.phone,
            mfa_enabled: false,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          },
          access_token: data.access_token,
          token_type: data.token_type || "",
          organizations: [],
        };

        // Store auth
        setAuth(
          {
            accessToken: data.access_token,
            refreshToken: data.refresh_token,
          },
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          me as any,
        );

        // Navigate based on RBAC roles
        const role = data.roles?.[0]?.toUpperCase() || "ADMIN";
        document.cookie = `user_role=${role}; path=/; max-age=86400; SameSite=Strict`;
        
        if (role === "COMPANY_ADMIN") {
          router.push("/company");
        } else {
          router.push("/admin");
        }

        toast.success("Logged in successfully");
      } catch {
        setLoading(false);
      }
    },

    onError: (error: Error) => {
      setLoading(false);
      toast.error(error.message);
    },
  });
}
