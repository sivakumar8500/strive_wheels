import { useState, useEffect } from "react";

/**
 * useDebounce
 * Delays the update of a value after a specified delay.
 * Useful for limiting the number of API calls during rapid input.
 */
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}
