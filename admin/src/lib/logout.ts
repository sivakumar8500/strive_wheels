import { useAuthStore } from "@/features/auth/store/auth.store";

export function performGlobalLogout() {
  // 1. Clear Zustand Stores
  const { logout } = useAuthStore.getState();
  logout();

  // 2. Clear Auth Cookies
  document.cookie =
    "auth_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT; SameSite=Strict";
  document.cookie =
    "refresh_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT; SameSite=Strict";
  document.cookie =
    "user_role=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT; SameSite=Strict";

  // 3. Clear Local Storage items
  localStorage.removeItem("access_token");
  localStorage.removeItem("refresh_token");
  localStorage.removeItem("user_role");
  localStorage.removeItem("auth-storage");

  // 4. Soft-navigate to login (no full page reload)
  // RouterProvider listens for this event and calls router.push()
  window.dispatchEvent(new CustomEvent("app:navigate", { detail: "/login" }));
}
