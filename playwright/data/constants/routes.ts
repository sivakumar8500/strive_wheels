/**
 * Application Routes mapping directly to Next.js App Router tree:
 * ┌ ○ /
 * ├ ○ /_not-found
 * ├ ○ /admin
 * ├ ○ /admin/bookings
 * ├ ○ /admin/companies
 * ├ ○ /admin/coupons
 * ├ ○ /admin/driver-registrations
 * ├ ƒ /admin/driver-registrations/[id]
 * ├ ○ /admin/fare-configs
 * ├ ○ /admin/popular-locations
 * ├ ○ /admin/quick-services
 * ├ ○ /admin/traffic-fares
 * ├ ○ /admin/users
 * ├ ○ /admin/vehicle-types
 * ├ ○ /admin/weather-fares
 * ├ ○ /company
 * ├ ○ /company/companies
 * ├ ○ /company/employees
 * ├ ○ /company/riders
 * ├ ○ /help
 * ├ ○ /icon.png
 * ├ ○ /login
 * ├ ○ /settings
 * ├ ○ /settings/account-details
 * └ ○ /settings/notifications
 */

export const ROUTES = {
  // Public & Root
  ROOT: "/",
  LOGIN: "/login",
  NOT_FOUND: "/_not-found",
  HELP: "/help",
  ICON: "/icon.png",

  // Super / Operational Admin
  ADMIN: "/admin",
  ADMIN_DASHBOARD: "/admin",
  ADMIN_BOOKINGS: "/admin/bookings",
  ADMIN_COMPANIES: "/admin/companies",
  ADMIN_COUPONS: "/admin/coupons",
  ADMIN_COUPON_DETAILS: (id: string | number) => `/admin/coupons/${id}`,
  ADMIN_DRIVER_REGISTRATIONS: "/admin/driver-registrations",
  ADMIN_DRIVER_REGISTRATION_DETAILS: (id: string | number) => `/admin/driver-registrations/${id}`,
  ADMIN_FARE_CONFIGS: "/admin/fare-configs",
  ADMIN_POPULAR_LOCATIONS: "/admin/popular-locations",
  ADMIN_QUICK_SERVICES: "/admin/quick-services",
  ADMIN_TRAFFIC_FARES: "/admin/traffic-fares",
  ADMIN_USERS: "/admin/users",
  ADMIN_VEHICLE_TYPES: "/admin/vehicle-types",
  ADMIN_VEHICLE_TYPE_DETAILS: (id: string | number) => `/admin/vehicle-types/${id}`,
  ADMIN_WEATHER_FARES: "/admin/weather-fares",

  // Company Admin
  COMPANY: "/company",
  COMPANY_DASHBOARD: "/company",
  COMPANY_COMPANIES: "/company/companies",
  COMPANY_EMPLOYEES: "/company/employees",
  COMPANY_RIDERS: "/company/riders",

  // Settings
  SETTINGS: "/settings",
  SETTINGS_ACCOUNT: "/settings/account-details",
  SETTINGS_ACCOUNT_DETAILS: "/settings/account-details",
  SETTINGS_NOTIFICATIONS: "/settings/notifications",
} as const;

export const API_ROUTES = {
  AUTH_ADMIN_LOGIN: "/auth/admin/login",
  AUTH_ME: "/auth/me",
  ADMIN_USERS: "/admin/users",
  ADMIN_BOOKINGS: "/admin/bookings",
  ADMIN_COUPONS: "/admin/coupons",
  ADMIN_VEHICLE_TYPES: "/admin/vehicle-types",
  COMPANY_ME_EMPLOYEES: "**/api/v1/companies/me/employees*",
} as const;

export const ROUTE_PATTERNS = {
  ADMIN_COUPON_ID: new RegExp(`${ROUTES.ADMIN_COUPONS}/(\\d+)`),
  ADMIN_VEHICLE_TYPE_ID: new RegExp(`${ROUTES.ADMIN_VEHICLE_TYPES}/(\\d+)`),
} as const;

