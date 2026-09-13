"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth.store";

export function RouterProvider() {
  const router = useRouter();
  const accessToken = useAuthStore((state) => state.accessToken);

  // Sync access token to cookie for Next.js Middleware authentication
  useEffect(() => {
    if (accessToken) {
      const hasCookie = document.cookie
        .split("; ")
        .some((row) => row.startsWith("auth_token="));
      if (!hasCookie) {
        document.cookie = `auth_token=${accessToken}; path=/; max-age=86400; SameSite=Strict`;
      }
    }
  }, [accessToken]);

  useEffect(() => {
    const handler = (e: Event) => {
      const path = (e as CustomEvent<string>).detail;
      if (path) router.push(path);
    };

    window.addEventListener("app:navigate", handler);
    return () => window.removeEventListener("app:navigate", handler);
  }, [router]);

  return null;
}
