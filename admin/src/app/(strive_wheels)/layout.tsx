"use client";

import React, { useEffect } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Navbar } from "@/components/layout/Navbar";
import { LogoutDialog } from "@/components/shared/LogoutDialog";
import { cn } from "@/lib/utils";
import { useUIStore } from "@/components/ui/store/ui-store";
import { useWindowSize } from "@/hooks/useWindowSize";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { isSidebarCollapsed, setSidebarOpen } = useUIStore();
  const { width } = useWindowSize();
  const [mounted, setMounted] = React.useState(false);

  useEffect(() => {
    if (width === 0) return;

    const timeoutId = setTimeout(() => {
      setMounted(true);
      if (width < 1024) {
        setSidebarOpen(false);
      } else {
        setSidebarOpen(true);
      }
    }, 0);

    return () => clearTimeout(timeoutId);
  }, [width, setSidebarOpen]);

  const isMobile = mounted && width > 0 && width < 1024;

  return (
    <div className="bg-background relative flex h-screen w-full overflow-hidden">
      <Sidebar />
      <div
        className={cn(
          "flex min-w-0 flex-1 flex-col transition-all duration-300 ease-in-out",
          !mounted
            ? "pl-60"
            : isMobile
              ? "pl-0"
              : isSidebarCollapsed
                ? "pl-16"
                : "pl-60",
        )}
      >
        <Navbar />
        <main className="min-w-0 flex-1 flex flex-col overflow-y-auto overflow-x-hidden">
          <div className="mx-auto w-full max-w-full flex-1 flex flex-col min-h-0">
            {children}
          </div>
        </main>
      </div>
      <LogoutDialog />
    </div>
  );
}
