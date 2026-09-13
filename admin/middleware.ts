import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

/**
 * Middleware logic
 */
export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const token = request.cookies.get("auth_token")?.value;

  // // 1. Skip middleware for static assets and internal Next.js files
  // if (
  //   pathname.startsWith("/_next") ||
  //   pathname.includes("/favicon.ico") ||
  //   pathname.includes("/logo.png") ||
  //   /\.(.*)$/.test(pathname) // Skip any file with an extension
  // ) {
  //   return NextResponse.next();
  // }

  // const PUBLIC_PATHS = ["/login", "/register", "/forgot-password"];
  // const isPublic = PUBLIC_PATHS.some((p) => pathname.startsWith(p));

  // // 2. Redirect Unauthenticated Users accessing Protected routes
  // if (!isPublic && !token) {
  //   return NextResponse.redirect(new URL("/login", request.url));
  // }

  // // 3. Redirect Authenticated Users away from Login/Register
  // if (
  //   isPublic &&
  //   token &&
  //   (pathname === "/login" || pathname === "/register")
  // ) {
  //   return NextResponse.redirect(new URL("/admin", request.url));
  // }

  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!api|_next/static|_next/image|favicon.ico).*)"],
};
