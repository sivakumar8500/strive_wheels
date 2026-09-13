# Authentication & State Management

## Authentication

Authentication is managed via JWT (JSON Web Tokens).

- **API Requests**: All authenticated API calls should be made through `src/services/apiService.ts`, which automatically handles attaching the access token and performing token refresh logic when a 401 response occurs.
- **Login Flow**: Defined in `src/features/auth/hooks/use-login.ts`. It sets a cookie for middleware, stores tokens in Zustand (`useAuthStore`), and redirects to `/admin`.
- **User State**: Current user data is fetched via `useMe` (`src/features/auth/hooks/use-me.ts`) and cached in React Query, alongside persisting the base user in Zustand.
- **Logout**: Handled via `performGlobalLogout()` in `src/lib/logout.ts`. It clears cookies, local storage, and Zustand stores.

## State Management

- **Server State**: Managed with `@tanstack/react-query`. Use this for all API interactions (fetching, caching, mutations).
- **Client/Global State**: Managed with `zustand`. This is reserved for:
  - Auth token persistence (`src/features/auth/store/auth.store.ts`)
  - UI state, such as sidebar toggling or active modals (`src/components/ui/store/ui-store.ts`)
