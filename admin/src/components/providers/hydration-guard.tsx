"use client";

import { useHasHydrated } from "@/hooks/use-hydrated";
import { ReactNode } from "react";

/**
 * Prevents SSR hydration mismatches by ensuring the UI only renders
 * once the client has successfully hydrated.
 */
export function HydrationGuard({
  children,
  fallback = null,
}: {
  children: ReactNode;
  fallback?: ReactNode;
}) {
  const hasHydrated = useHasHydrated();

  if (!hasHydrated) {
    return <>{fallback}</>;
  }

  return <>{children}</>;
}
