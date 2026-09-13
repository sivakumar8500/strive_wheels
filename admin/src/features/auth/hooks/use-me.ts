import { useQuery } from "@tanstack/react-query";
import { useAuthStore } from "../store/auth.store";
import { getMe } from "../services/auth.api";

export function useMe() {
  const { accessToken, setAuth } = useAuthStore();

  return useQuery({
    queryKey: ["me", accessToken],
    queryFn: async () => {
      if (!accessToken) return null;

      const me = await getMe(accessToken);

      // Update state stores with fresh data
      setAuth({ accessToken: accessToken }, me);

      return me;
    },
    enabled: !!accessToken,
    staleTime: 1000 * 60 * 5, // 5 minutes
  });
}
