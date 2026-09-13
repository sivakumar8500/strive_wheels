import { useMutation } from "@tanstack/react-query";
import { refreshToken, getMe } from "../services/auth.api";
import { useAuthStore } from "../store/auth.store";
import { performGlobalLogout } from "@/lib/logout";

export function useRefreshToken() {
  const { setAuth, refreshToken: storeRefreshToken } = useAuthStore();

  return useMutation({
    mutationFn: async () => {
      if (!storeRefreshToken) throw new Error("No refresh token");

      try {
        // 1. Get new token
        const response = await refreshToken({
          refresh_token: storeRefreshToken,
        });

        // 2. Fetch fresh user data with new token
        const freshUser = await getMe(response.access_token);

        // 3. Update store
        setAuth(
          {
            accessToken: response.access_token,
            refreshToken: response.refresh_token,
          },
          freshUser,
        );

        return response.access_token;
      } catch (err) {
        // If refresh fails, session is likely invalid
        performGlobalLogout();
        throw err;
      }
    },
  });
}
