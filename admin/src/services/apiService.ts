import API_CONFIG from "@/config/common";
import { useAuthStore } from "@/features/auth/store/auth.store";
import { performGlobalLogout } from "@/lib/logout";
import AUTH_ENDPOINTS from "@/features/auth/services/authEndpoints";

const BASE_URL = API_CONFIG.BASE_URL;
const DEFAULT_TIMEOUT = 15000;

// State for token refresh logic
let isRefreshing = false;
let refreshSubscribers: ((token: string) => void)[] = [];

function onRefreshed(token: string) {
  refreshSubscribers.forEach((cb) => cb(token));
  refreshSubscribers = [];
}

function addRefreshSubscriber(cb: (token: string) => void) {
  refreshSubscribers.push(cb);
}

// 1. Helper to parse backend error responses
async function parseError(res: Response): Promise<Error> {
  try {
    const contentType = res.headers.get("content-type");
    if (contentType && contentType.includes("application/json")) {
      const errorData = await res.json();
      const detail = errorData.detail;
      if (Array.isArray(detail)) {
        return new Error(detail.map((e: { msg: string }) => e.msg).join(", "));
      }

      const errorMessage =
        detail || errorData.message || errorData.error || `Error ${res.status}`;
      return new Error(
        typeof errorMessage === "string"
          ? errorMessage
          : JSON.stringify(errorMessage),
      );
    }
    return new Error(`Server returned ${res.status}: ${res.statusText}`);
  } catch {
    return new Error(`Network error (${res.status})`);
  }
}

// 2. Helper to fetch the current active auth token
function getAuthToken(providedToken: string | null): string | null {
  if (providedToken) return providedToken;
  if (typeof window !== "undefined") {
    try {
      return useAuthStore.getState().accessToken;
    } catch {
      console.warn("Could not auto-detect auth token");
    }
  }
  return null;
}

// 3. Helper to trigger session logout
function triggerLogout(message = "Session expired. Please login again.") {
  if (typeof window !== "undefined") {
    performGlobalLogout();
  } else {
    useAuthStore.getState().logout();
  }
  throw new Error(message);
}

// 4. Helper to perform the actual refresh token network request
async function refreshSessionToken(currentRefreshToken: string): Promise<void> {
  if (isRefreshing) return;
  isRefreshing = true;

  try {
    const refreshRes = await fetch(
      `${BASE_URL}${AUTH_ENDPOINTS.REFRESH_TOKEN}`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Skip-Refresh": "true",
        },
        body: JSON.stringify({ refresh_token: currentRefreshToken }),
      },
    );

    if (!refreshRes.ok) throw new Error("Failed to refresh token");

    const data = await refreshRes.json();
    const { access_token: newAccess, refresh_token: newRefresh } = data;

    const store = useAuthStore.getState();
    store.setTokens(newAccess, newRefresh);

    if (newRefresh) {
      // Backend token refresh time is 7 days (604800 seconds)
      document.cookie = `refresh_token=${newRefresh}; path=/; max-age=604800; SameSite=Strict`;
    }

    onRefreshed(newAccess);
  } catch {
    triggerLogout();
  } finally {
    isRefreshing = false;
  }
}

// 5. Helper to handle 401 Unauthorized errors
async function handleUnauthorized<T>(
  path: string,
  options: RequestInit,
  authToken: string | null,
  timeout: number,
): Promise<T> {
  console.error("API returned 401 Unauthorized for path:", path);

  const skipRefresh =
    (options.headers as Record<string, string>)?.["X-Skip-Refresh"] === "true";

  // If user is logged in and we shouldn't skip refresh, attempt to refresh
  if (authToken && typeof window !== "undefined" && !skipRefresh) {
    const currentRefreshToken = useAuthStore.getState().refreshToken;

    if (!currentRefreshToken) {
      return triggerLogout() as never;
    }

    // Fire off the refresh request if not already running
    refreshSessionToken(currentRefreshToken);

    // Queue this request to be retried once the token is refreshed
    return new Promise<T>((resolve, reject) => {
      addRefreshSubscriber((newToken) => {
        const newOptions = {
          ...options,
          headers: {
            ...options.headers,
            Authorization: `Bearer ${newToken}`,
          },
        };
        apiFetch<T>(path, newOptions, newToken, timeout)
          .then(resolve)
          .catch(reject);
      });
    });
  }

  // If user has a token but refresh is disabled or window is undefined -> Hard logout
  if (authToken) {
    return triggerLogout() as never;
  }

  // If user has no token and it's not a login attempt -> Soft redirect to login
  if (typeof window !== "undefined" && !path.includes("/auth/login")) {
    performGlobalLogout();
  }

  // Fall through to parse the error naturally
  throw new Error("Unauthorized");
}

// 6. Main apiFetch wrapper
export async function apiFetch<T>(
  path: string,
  options: RequestInit = {},
  token: string | null = null,
  timeout = DEFAULT_TIMEOUT,
): Promise<T> {
  const authToken = getAuthToken(token);
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);

  try {
    const url = path.startsWith("http") ? path : `${BASE_URL}${path}`;
    const headers = {
      "Content-Type": "application/json",
      ...(authToken ? { Authorization: `Bearer ${authToken}` } : {}),
      ...options.headers,
    };

    const res = await fetch(url, {
      ...options,
      signal: controller.signal,
      headers,
    });

    clearTimeout(timeoutId);

    // Handle 401 errors using our helper
    if (res.status === 401) {
      try {
        return await handleUnauthorized<T>(path, options, authToken, timeout);
      } catch (err: unknown) {
        if (err instanceof Error && err.message === "Unauthorized") {
          throw await parseError(res);
        }
        throw err;
      }
    }

    // Handle other errors
    if (!res.ok) {
      throw await parseError(res);
    }

    // Process successful response
    const contentType = res.headers.get("content-type");
    if (contentType?.includes("application/json")) {
      const text = await res.text();
      return text ? JSON.parse(text) : ({} as T);
    }

    return {} as T;
  } catch (error: unknown) {
    clearTimeout(timeoutId);
    if (error instanceof Error && error.name === "AbortError") {
      return Promise.reject(new Error("Request timeout"));
    }
    return Promise.reject(error);
  }
}

const apiService = {
  get: <T>(p: string, t: string | null = null, o?: RequestInit) =>
    apiFetch<T>(p, { ...o, method: "GET" }, t),

  post: <T>(p: string, d?: unknown, t: string | null = null, o?: RequestInit) =>
    apiFetch<T>(
      p,
      { ...o, method: "POST", body: d ? JSON.stringify(d) : undefined },
      t,
    ),

  put: <T>(p: string, d?: unknown, t: string | null = null, o?: RequestInit) =>
    apiFetch<T>(
      p,
      { ...o, method: "PUT", body: d ? JSON.stringify(d) : undefined },
      t,
    ),

  patch: <T>(
    p: string,
    d?: unknown,
    t: string | null = null,
    o?: RequestInit,
  ) =>
    apiFetch<T>(
      p,
      { ...o, method: "PATCH", body: d ? JSON.stringify(d) : undefined },
      t,
    ),

  delete: <T>(p: string, t: string | null = null, o?: RequestInit) =>
    apiFetch<T>(p, { ...o, method: "DELETE" }, t),
};

export default apiService;
