# Gemini Agent Guidelines

You are assisting with the frontend Next.js application. Please adhere to the following rules based on the established architecture:

## 1. Feature-Sliced Design

- **NEVER** place business logic directly in `src/app`. The App Router should solely be responsible for layouts, pages, and route definitions.
- Always encapsulate features within `src/features/`. If a new domain is introduced (e.g., `invoices`), create `src/features/invoices` and include its components, hooks, services, and types inside.
- **Feature Implementation Sequence**: Build from the data layer upwards. Always create files in this order: `types.ts` -> `data/mockData.ts` -> `services/` -> `hooks/` -> `components/` -> `app/page.tsx`.

## 2. Role-Based Access Control (RBAC)

- The application uses Edge Middleware for RBAC.
- Ensure that the `user_role` cookie is properly respected in `middleware.ts`.
- Client-side `<RoleGuard>` wrappers are NOT needed and should not be added to new components or pages.

## 3. State Management

- For API interactions and data caching, **always** use `@tanstack/react-query`. Do not use `useEffect` to fetch data manually.
- For global client UI state or persistent local storage (like auth tokens), use `zustand`.

## 4. UI & Styling

- This project uses Tailwind CSS v4 and `shadcn/ui`.
- Do not write custom CSS in `globals.css` unless necessary for global variables. Use utility classes.
- Use `lucide-react` for icons.

For more detailed architectural choices, read the knowledge base files in the `docs/` folder:

- [Architecture](docs/architecture.md)
- [Authentication & State Management](docs/auth_and_state.md)
- [Logs](docs/logs.md)
- [Admin Role](docs/roles/admin_role.md)
- [Company Admin Role](docs/roles/company_admin_role.md)