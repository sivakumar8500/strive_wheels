"use client";

import React from "react";
import { usePathname, useRouter } from "next/navigation";
import { User, Bell } from "lucide-react";
import { cn } from "@/lib/utils";
import { Card } from "@/components/ui/card";

interface SettingsNavItemProps {
  href: string;
  icon: React.ElementType;
  label: string;
  isActive: boolean;
}

const SettingsNavItem = ({
  href,
  icon: Icon,
  label,
  isActive,
}: SettingsNavItemProps) => {
  const router = useRouter();
  return (
    <button
      onClick={() => router.push(href)}
      className={cn(
        "font-regular flex w-full items-center gap-3 rounded-md px-4 py-3 text-sm transition-all",
        isActive
          ? "text-primary bg-[#EBF7FC] shadow-sm"
          : "text-muted-foreground hover:bg-muted",
      )}
    >
      <Icon className="h-5 w-5" />
      {label}
    </button>
  );
};

export default function SettingsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();

  const navItems = [
    {
      href: "/settings/account-details",
      icon: User,
      label: "Account Details",
    },
    {
      href: "/settings/notifications",
      icon: Bell,
      label: "Notifications",
    },
  ];

  return (
    <div className="flex flex-col gap-6 px-8 py-4">
      {/* Header */}
      <div className="flex flex-col gap-1">
        <h1 className="text-foreground text-2xl font-black tracking-tight">
          Settings
        </h1>
        <p className="text-muted-foreground font-medium">
          Manage your account settings and preferences
        </p>
      </div>

      <div className="flex flex-col gap-6 lg:flex-row">
        {/* Secondary Sidebar */}
        <div className="w-full shrink-0 lg:w-72">
          <Card className="border-border flex flex-col gap-1 rounded-2xl p-2 shadow-sm">
            {navItems.map((item) => (
              <SettingsNavItem
                key={item.href}
                href={item.href}
                icon={item.icon}
                label={item.label}
                isActive={pathname === item.href}
              />
            ))}
          </Card>
        </div>

        {/* Content Area */}
        <div className="min-w-0 flex-1">
          <Card className="border-border h-full rounded-2xl bg-white px-6 py-4 shadow-sm ">
            {children}
          </Card>
        </div>
      </div>
    </div>
  );
}
