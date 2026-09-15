import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

/**
 * Middleware logic
 */
export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const token = request.cookies.get("auth_token")?.value;
  const userRole = request.cookies.get("user_role")?.value?.toUpperCase();

  // 1. Skip middleware for static assets and internal Next.js files
  if (
    pathname.startsWith("/_next") ||
    pathname.includes("/favicon.ico") ||
    pathname.includes("/logo.png") ||
    /\.(.*)$/.test(pathname) // Skip any file with an extension
  ) {
    return NextResponse.next();
  }

  const PUBLIC_PATHS = ["/login", "/register", "/forgot-password"];
  const isPublic = PUBLIC_PATHS.some((p) => pathname.startsWith(p));

  // 2. Redirect Unauthenticated Users accessing Protected routes
  if (!isPublic && !token) {
    return NextResponse.redirect(new URL("/login", request.url));
  }

  // 3. RBAC Enforcement for Protected Routes
  if (token && userRole) {
    if (pathname.startsWith("/admin") && userRole !== "ADMIN" && userRole !== "SUPER_ADMIN") {
      return NextResponse.redirect(new URL("/company", request.url));
    }
    
    if (pathname.startsWith("/company") && userRole !== "COMPANY_ADMIN") {
      return NextResponse.redirect(new URL("/admin", request.url));
    }
  }

  // 4. Redirect Authenticated Users away from Login/Register
  if (
    isPublic &&
    token &&
    userRole &&
    (pathname === "/login" || pathname === "/register" || pathname === "/")
  ) {
    const defaultRoute = userRole === "COMPANY_ADMIN" ? "/company" : "/admin";
    return NextResponse.redirect(new URL(defaultRoute, request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!api|_next/static|_next/image|favicon.ico).*)"],
};
