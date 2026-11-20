export const BASE_URL = process.env.NEXT_PUBLIC_API_URL || "";

const API_CONFIG = {
  BASE_URL,
  AUTH: "/auth",
  DASHBOARD: "/dashboard",
} as const;

export default API_CONFIG;
