"use client";

import React from "react";
import { useAuthStore } from "@/features/auth";
import { cn } from "@/lib/utils";
import { useUIStore } from "@/components/ui/store/ui-store";

import { Menu, ChevronDown } from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Breadcrumb } from "./Breadcrumb";
import { useRouter } from "next/navigation";

export function Navbar() {
  const { toggleSidebarCollapse, setActiveModal } = useUIStore();
  const user = useAuthStore((s) => s.user);
  const router = useRouter();

  const userInitials = (user?.full_name || user?.email || "U")
    .split(" ")
    .map((n: string) => n[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);

  const handleLogout = () => {
    setActiveModal("logout");
  };

  return (
    <header
      className={cn(
        "sticky top-0 z-30 flex h-16 w-full items-center justify-between border-b bg-white/80 px-4 backdrop-blur-md sm:px-8",
        "border-border/50",
      )}
    >
      <div className="flex items-center gap-3">
        {/* Mobile Sidebar Toggle */}
        <button
          onClick={toggleSidebarCollapse}
          className="text-muted-foreground hover:bg-secondary hover:text-foreground border-border/50 flex items-center justify-center rounded-xl border p-2 transition-all duration-200 lg:hidden"
        >
          <Menu className="h-5 w-5" />
        </button>

        <Breadcrumb />
      </div>

      <div className="flex items-center gap-3">
        <div className="bg-border/60 mx-2 hidden h-8 w-px sm:block" />

        {/* User Dropdown */}
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <button className="border-[#E8ECF2] flex items-center gap-2 rounded-lg border bg-[#F5F6FA] p-1.5 px-2.5 text-[#09090B] text-xs font-bold transition-all duration-200 hover:bg-[#E8ECF2] focus:outline-none">
              <Avatar className="h-8 w-8 rounded-md">
                <AvatarImage src="" />
                <AvatarFallback className="bg-brand-gradient text-white text-xs font-bold">
                  {userInitials}
                </AvatarFallback>
              </Avatar>
              <div className="hidden flex-col items-start text-left sm:flex">
                <span className="text-[#09090B] truncate text-xs font-bold max-w-[100px]">
                  {user?.full_name || user?.email?.split("@")[0]}
                </span>
                <span className="text-[#94A3B8] truncate text-xs font-normal max-w-[100px]">
                  Admin
                </span>
              </div>
              <ChevronDown className="text-muted-foreground h-3.5 w-3.5" />
            </button>
          </DropdownMenuTrigger>
          <DropdownMenuContent
            align="end"
            className="w-56 rounded-xl shadow-none"
          >
            <DropdownMenuLabel className="font-normal">
              <div className="flex flex-col space-y-1">
                <p className="text-sm font-bold leading-none">
                  {user?.full_name}
                </p>
                <p className="text-muted-foreground text-xs leading-none">
                  {user?.email}
                </p>
              </div>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              onClick={() => router.push("/settings/notifications")}
            >
              Notification Settings
            </DropdownMenuItem>
            <DropdownMenuItem
              onClick={() => router.push("/settings/account-details")}
            >
              Account Details
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              onClick={handleLogout}
              className="text-destructive focus:bg-destructive/10 focus:text-destructive font-medium"
            >
              Sign out
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
