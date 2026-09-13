"use client";

import React from "react";
import { useAuthStore } from "@/features/auth";
import { cn } from "@/lib/utils";
import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  Wallet,
  Users,
  Settings,
  HelpCircle,
  LogOut,
  ListTodo,
  Plus,
  CheckSquare2,
  Target,
  Zap,
  Cloud,
  CreditCard,
  FileText,
  BookOpen,
  TrendingUp,
  BarChart3,
  CheckCircle2,
  AlertCircle,
  AlertTriangle,
  Gavel,
  DollarSign,
  Trophy,
  Network,
  SquarePen,
  Hourglass,
  Database,
  Briefcase,
  Building2,
} from "lucide-react";
import { useUIStore } from "@/components/ui/store/ui-store";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import Image from "next/image";

import { useWindowSize } from "@/hooks/useWindowSize";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

// Icon mapping for dynamic icons
const iconMap: Record<string, React.ElementType> = {
  LayoutDashboard,
  Wallet,
  Users,
  Settings,
  ListTodo,
  Plus,
  CheckSquare2,
  Target,
  Zap,
  Cloud,
  CreditCard,
  FileText,
  BookOpen,
  TrendingUp,
  BarChart3,
  CheckCircle2,
  AlertCircle,
  AlertTriangle,
  Gavel,
  DollarSign,
  Trophy,
  HelpCircle,
  LogOut,
  Network,
  SquarePen,
  Hourglass,
  Database,
  Briefcase,
  Building2,
};

import { UserRole } from "@/features/roles";

/**
 * Helper function to determine if a navigation item is active.
 * Prevents double highlighting by using exact match for Dashboard items.
 */
const checkIsActive = (pathname: string, href: string, name: string) => {
  if (name === "Dashboard") {
    return pathname === href;
  }
  if (name === "Goals & Resource" && href.includes("/goals-resources/")) {
    return pathname.includes("/goals-resources");
  }
  return pathname.startsWith(href);
};

export function Sidebar() {
  const pathname = usePathname();
  const user = useAuthStore((s) => s.user);
  const { isSidebarCollapsed, toggleSidebarCollapse, setActiveModal } =
    useUIStore();
  const [mounted, setMounted] = React.useState(false);

  React.useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setMounted(true);
  }, []);

  const { width } = useWindowSize();

  const isMobile = mounted && width > 0 && width < 1024;

  const displayNavigation = [
    // Super Admin Routes
    { name: "Dashboard", href: "/admin", icon: "LayoutDashboard", allowedRoles: [UserRole.ADMIN] },
    { name: "Bookings", href: "/admin/bookings", icon: "BookOpen", allowedRoles: [UserRole.ADMIN] },
    { name: "Users", href: "/admin/users", icon: "Users", allowedRoles: [UserRole.ADMIN] },
    { name: "Fare Configs", href: "/admin/fare-configs", icon: "DollarSign", allowedRoles: [UserRole.ADMIN] },
    { name: "Vehicle Types", href: "/admin/vehicle-types", icon: "Database", allowedRoles: [UserRole.ADMIN] },
    { name: "Traffic Fares", href: "/admin/traffic-fares", icon: "Network", allowedRoles: [UserRole.ADMIN] },
    { name: "Weather Fares", href: "/admin/weather-fares", icon: "Cloud", allowedRoles: [UserRole.ADMIN] },
    { name: "Quick Services", href: "/admin/quick-services", icon: "Briefcase", allowedRoles: [UserRole.ADMIN] },
    { name: "Popular Locations", href: "/admin/popular-locations", icon: "Target", allowedRoles: [UserRole.ADMIN] },
    { name: "Driver Verifications", href: "/admin/driver-registrations", icon: "CheckSquare2", allowedRoles: [UserRole.ADMIN] },
    { name: "Coupons", href: "/admin/coupons", icon: "Trophy", allowedRoles: [UserRole.ADMIN] },
    
    // Company Admin Routes
    { name: "Dashboard", href: "/company", icon: "LayoutDashboard", allowedRoles: [UserRole.COMPANY_ADMIN] },
    { name: "Companies", href: "/company/companies", icon: "Building2", allowedRoles: [UserRole.COMPANY_ADMIN] },
    { name: "Employees", href: "/company/employees", icon: "Users", allowedRoles: [UserRole.COMPANY_ADMIN] },
    { name: "Riders", href: "/company/riders", icon: "Zap", allowedRoles: [UserRole.COMPANY_ADMIN] },
  ];

  const filteredNavigation = displayNavigation.filter((item) => {
    if (!user?.user_type) return false;
    return item.allowedRoles.includes(user.user_type as any);
  });

  const handleLogout = () => {
    setActiveModal("logout");
  };

  return (
    <TooltipProvider delayDuration={0}>
      {/* Mobile Overlay */}
      {isMobile && !isSidebarCollapsed && (
        <div
          className="fixed inset-0 z-30 bg-black/50 backdrop-blur-sm transition-opacity duration-300 lg:hidden"
          onClick={toggleSidebarCollapse}
        />
      )}

      <aside
        className={cn(
          "border-border/50 bg-card fixed top-0 left-0 z-40 flex h-screen flex-col border-r transition-all duration-300 ease-in-out",
          isMobile
            ? isSidebarCollapsed
              ? "w-60 -translate-x-full"
              : "w-60 translate-x-0"
            : isSidebarCollapsed
              ? "w-16"
              : "w-60",
        )}
      >
        {/* Logo Section */}
        <div
          className={cn(
            "relative flex h-16 items-center border-b border-border/50 transition-all duration-300",
            isSidebarCollapsed ? "justify-center px-0" : "px-5",
          )}
        >
          <div
            className={cn(
              "flex items-center gap-3 rounded-xl transition-all duration-300 w-full",
              isSidebarCollapsed ? "p-1.5 justify-center" : "px-2 py-1",
            )}
          >
            <Image
              src="/logo.png"
              alt="Logo"
              width={isSidebarCollapsed ? 28 : 32}
              height={isSidebarCollapsed ? 28 : 32}
              className="object-contain shrink-0 rounded-md"
              priority
            />
            {!isSidebarCollapsed && (
              <span className="text-lg font-bold text-foreground truncate">
                App
              </span>
            )}
          </div>

          {/* Collapse/Expand Toggle Arrow */}
          {!isMobile && (
            <button
              onClick={toggleSidebarCollapse}
              className="absolute -right-3 top-1/2 flex h-6 w-6 -translate-y-1/2 items-center justify-center rounded-full border border-border bg-background shadow-sm hover:bg-accent hover:text-accent-foreground z-50 transition-transform"
            >
              {isSidebarCollapsed ? (
                <svg
                  width="14"
                  height="14"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="m9 18 6-6-6-6" />
                </svg>
              ) : (
                <svg
                  width="14"
                  height="14"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="m15 18-6-6 6-6" />
                </svg>
              )}
            </button>
          )}
        </div>
        {/* Main Navigation */}
        <nav className="flex-1 space-y-1 px-3 py-2">
          {filteredNavigation.map((item) => {
            const isActive = checkIsActive(pathname, item.href, item.name);
            const IconComponent = iconMap[item.icon];

            const content = (
              <Link
                href={item.href}
                onClick={() => {
                  if (isMobile && !isSidebarCollapsed) {
                    toggleSidebarCollapse();
                  }
                }}
                className={cn(
                  "group flex items-center gap-2 rounded-md px-0.5 py-2 transition-all duration-200",
                  isActive
                    ? "bg-[#EBF7FC] text-[#0199CA]"
                    : "text-muted-foreground hover:bg-[#EBF7FC] hover:text-[#0D76D3]",
                )}
              >
                {isActive && !isSidebarCollapsed && (
                  <div className="bg-[#0199CA] h-5 w-1 rounded-r-sm ml-[-1px]" />
                )}

                {IconComponent && (
                  <IconComponent
                    className={cn(
                      "w-8 h-8 shrink-0 rounded-sm p-2 transition-colors hover:text-[#0D76D3]",
                      isActive
                        ? "text-[#0D76D3] bg-[#D0EFFA]"
                        : "hover:text-[#0D76D3]",
                    )}
                  />
                )}
                {!isSidebarCollapsed && (
                  <span
                    className={`${isActive ? "text-[#0D76D3]" : "hover:text-[#0D76D3]"} flex-1 pt-0.5 text-sm leading-none font-medium hover:text-[#0D76D3]`}
                  >
                    {item.name}
                  </span>
                )}
              </Link>
            );

            if (isSidebarCollapsed) {
              return (
                <Tooltip key={item.name}>
                  <TooltipTrigger asChild>{content}</TooltipTrigger>
                  <TooltipContent side="right" sideOffset={10}>
                    {item.name}
                  </TooltipContent>
                </Tooltip>
              );
            }

            return <div key={item.name}>{content}</div>;
          })}
        </nav>

        {/* Bottom Section */}
        <div className="border-border mt-auto space-y-1 border-t p-3">
          {(() => {
            const isHelpActive = pathname.startsWith("/help");
            const helpLink = (
              <Link
                href="/help"
                onClick={() => {
                  if (isMobile && !isSidebarCollapsed) {
                    toggleSidebarCollapse();
                  }
                }}
                className={cn(
                  "group flex items-center gap-3 rounded-md p-2 transition-all duration-200 mb-3",
                  isHelpActive
                    ? "bg-[#EBF7FC] text-[#0199CA]"
                    : "text-muted-foreground hover:bg-[#EBF7FC] hover:text-[#0D76D3]",
                  isSidebarCollapsed && "justify-center",
                )}
              >
                {isHelpActive && !isSidebarCollapsed && (
                  <div className="bg-[#0D76D3] h-4 w-1 rounded-full" />
                )}
                <HelpCircle
                  className={cn(
                    "h-5 w-5 shrink-0 transition-colors",
                    isHelpActive
                      ? "text-primary"
                      : "group-hover:text-foreground",
                  )}
                />
                {!isSidebarCollapsed && (
                  <span className="flex-1 pt-0.5 text-sm font-medium">
                    Help & Support
                  </span>
                )}
              </Link>
            );

            if (isSidebarCollapsed) {
              return (
                <Tooltip>
                  <TooltipTrigger asChild>{helpLink}</TooltipTrigger>
                  <TooltipContent side="right" sideOffset={10}>
                    Help & Support
                  </TooltipContent>
                </Tooltip>
              );
            }

            return helpLink;
          })()}

          <div className="border-t border-border">
            <div
              className={cn(
                "flex items-center gap-3 bg-white p-2 transition-all duration-300",
                isSidebarCollapsed ? "justify-center" : "px-3 py-2",
              )}
            >
              <Avatar className="ring-primary/10 h-9 w-9 ring-2 rounded-md">
                <AvatarImage src="" />
                <AvatarFallback className="bg-brand-gradient text-white text-xs font-bold uppercase rounded-md">
                  {(user?.full_name || user?.email || "U")[0]}
                </AvatarFallback>
              </Avatar>

              {!isSidebarCollapsed && (
                <div className="flex flex-1 flex-col overflow-hidden">
                  <span className="text-foreground truncate text-sm font-bold capitalize">
                    {user?.full_name || user?.email?.split("@")[0] || "User"}
                  </span>
                  <span className="text-muted-foreground truncate text-xs font-medium">
                    Admin
                  </span>
                </div>
              )}

              {!isSidebarCollapsed && (
                <button
                  onClick={handleLogout}
                  className="text-muted-foreground hover:bg-destructive/10 hover:text-destructive cursor-pointer rounded-lg p-1 transition-colors"
                >
                  <LogOut className="h-4 w-4" />
                </button>
              )}
            </div>
          </div>
        </div>
      </aside>
    </TooltipProvider>
  );
}
