"use client";

import React, { useEffect, useState } from "react";
import { useAuthStore } from "@/features/auth/store/auth.store";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";

interface RoleGuardProps {
  children: React.ReactNode;
  allowedRoles: string[];
}

export function RoleGuard({ children, allowedRoles }: RoleGuardProps) {
  const { user, isAuthenticated, isLoading } = useAuthStore();
  const router = useRouter();
  const [isChecking, setIsChecking] = useState(true);

  useEffect(() => {
    if (!isLoading) {
      if (!isAuthenticated || !user) {
        // Not logged in
        router.push("/");
      } else if (!allowedRoles.includes(user.user_type)) {
        // Logged in, but incorrect role
        console.warn(`User type ${user.user_type} not in allowed roles:`, allowedRoles);
        // We can redirect to a default dashboard or a 403 page
        if (user.user_type === "admin") {
          router.push("/admin");
        } else if (user.user_type === "company_admin") {
          router.push("/company");
        } else {
          router.push("/");
        }
      } else {
        // Allowed
        setIsChecking(false);
      }
    }
  }, [isAuthenticated, user, isLoading, router, allowedRoles]);

  // While checking roles or loading auth state, show a loader
  if (isLoading || isChecking) {
    return (
      <div className="flex h-[50vh] w-full items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  // If we get here, user is authenticated and has the correct role
  return <>{children}</>;
}
