"use client";

import { useDashboardStats } from "../hooks/use-dashboard";
import { StatCard } from "@/components/shared/StatCard";
import { Users, Car, Map, Clock, CheckCircle, FileText, IndianRupee } from "lucide-react";
import { RevenueChart } from "./RevenueChart";
import { BookingsChart } from "./BookingsChart";
import { Loader2 } from "lucide-react";

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

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight text-slate-900">
          Dashboard Overview
        </h1>
        <p className="text-muted-foreground">
          Welcome to the Strive Admin Panel. Here is what's happening today.
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Total Users"
          value={stats.total_users.toLocaleString()}
          icon={Users}
          color="blue"
        />
        <StatCard
          label="Total Customers"
          value={stats.total_customers.toLocaleString()}
          icon={Users}
          color="green"
        />
        <StatCard
          label="Total Riders"
          value={stats.total_riders.toLocaleString()}
          icon={Car}
          color="orange"
        />
        <StatCard
          label="Pending KYC"
          value={stats.pending_driver_registrations.toLocaleString()}
          icon={FileText}
          color="purple"
        />
        <StatCard
          label="Active Drivers Online"
          value={stats.active_drivers_online.toLocaleString()}
          icon={Map}
          color="teal"
        />
        <StatCard
          label="Active Trips"
          value={stats.active_trips_in_progress.toLocaleString()}
          icon={Clock}
          color="indigo"
        />
        <StatCard
          label="Completed Trips Today"
          value={stats.completed_trips_today.toLocaleString()}
          icon={CheckCircle}
          color="green"
        />
        <StatCard
          label="Today's Revenue"
          value={`₹${stats.today_revenue.toLocaleString()}`}
          icon={IndianRupee}
          color="orange"
        />
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
