import { QueryClient } from "@tanstack/react-query";

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // Production defaults
      retry: (failureCount, error: unknown) => {
        // No retry on common client-side or auth errors
        if (
          error instanceof Error &&
          (error.message.includes("401") ||
            error.message.includes("403") ||
            error.message.includes("404"))
        )
          return false;

        return failureCount < 2;
      },
      refetchOnWindowFocus: process.env.NODE_ENV === "production",
      staleTime: 5 * 60 * 1000, // 5 minutes
      gcTime: 10 * 60 * 1000, // 10 minutes (garbage collection)
    },
    mutations: {
      retry: false, // Don't retry mutations by default
    },
  },
});
