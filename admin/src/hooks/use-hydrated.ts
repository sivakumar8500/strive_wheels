"use client";

import { useEffect, useState } from "react";

/**
 * Hook to check if the component has hydrated on the client.
 * Essential for apps using Zustand persist to prevent SSR mismatches.
 */
export function useHasHydrated() {
  const [hasHydrated, setHasHydrated] = useState(false);

  useEffect(() => {
    const timeout = setTimeout(() => {
      setHasHydrated(true);
    }, 0);
    return () => clearTimeout(timeout);
  }, []);

  return hasHydrated;
}
