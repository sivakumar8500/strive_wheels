"use client";

import { useDashboardStats } from "../hooks/use-dashboard";
import { StatCard } from "@/components/shared/StatCard";
import { Users, Car, Map, Clock, CheckCircle, FileText, IndianRupee } from "lucide-react";
import { RevenueChart } from "./RevenueChart";
import { BookingsChart } from "./BookingsChart";
import { Loader2 } from "lucide-react";
import PageHeader from "@/components/shared/PageHeader";

export function AdminDashboardClient() {
  const { data, isLoading, isError } = useDashboardStats();

  if (isLoading) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (isError || !data) {
    return (
      <div className="flex h-[400px] items-center justify-center text-red-500">
        Failed to load dashboard statistics.
      </div>
    );
  }

  const { stats, revenueData, bookingData } = data;

  const statsData = [
    {
      label: "Total Users",
      value: stats.total_users.toLocaleString(),
      icon: Users,
      color: "blue",
    },
    {
      label: "Total Customers",
      value: stats.total_customers.toLocaleString(),
      icon: Users,
      color: "green",
    },
    {
      label: "Total Riders",
      value: stats.total_riders.toLocaleString(),
      icon: Car,
      color: "orange",
    },
    {
      label: "Pending KYC",
      value: stats.pending_driver_registrations.toLocaleString(),
      icon: FileText,
      color: "purple",
    },
    {
      label: "Active Drivers Online",
      value: stats.active_drivers_online.toLocaleString(),
      icon: Map,
      color: "teal",
    },
    {
      label: "Active Trips",
      value: stats.active_trips_in_progress.toLocaleString(),
      icon: Clock,
      color: "indigo",
    },
    {
      label: "Completed Trips Today",
      value: stats.completed_trips_today.toLocaleString(),
      icon: CheckCircle,
      color: "green",
    },
    {
      label: "Today's Revenue",
      value: `₹${stats.today_revenue.toLocaleString()}`,
      icon: IndianRupee,
      color: "orange",
    },
  ]

  return (
    <div className="space-y-6">
      <PageHeader
        title="Dashboard Overview"
        description="Welcome to the Strive Admin Panel. Here is what&apos;s happening today."
      />

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {statsData.map((stat, index) => (
          <StatCard
            key={index}
            label={stat.label}
            value={stat.value}
            icon={stat.icon}
            color={stat.color as any}
          />
        ))}
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <div className="col-span-4">
          <RevenueChart data={revenueData} />
        </div>
        <div className="col-span-3">
          <BookingsChart data={bookingData} />
        </div>
      </div>
    </div>
  );
}
