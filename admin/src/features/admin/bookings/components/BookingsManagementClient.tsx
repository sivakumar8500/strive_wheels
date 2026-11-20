"use client";

import { useState } from "react";
import { DataTable } from "@/components/common/Table";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Search } from "lucide-react";
import { useBookings, useCancelBooking } from "../hooks/use-bookings";
import { CancelBookingDialog } from "./CancelBookingDialog";
import PageHeader from "@/components/shared/PageHeader";
import type { Booking, BookingsQuery } from "../types";

export function BookingsManagementClient() {
  const [query, setQuery] = useState<BookingsQuery>({
    skip: 0,
    limit: 10,
    search: "",
    status: "",
    service_mode: "",
    booking_mode: "",
  });

  const { data: paginatedData, isLoading } = useBookings(query);
  const cancelMutation = useCancelBooking();

  const [isCancelDialogOpen, setIsCancelDialogOpen] = useState(false);
  const [selectedBookingForCancel, setSelectedBookingForCancel] = useState<Booking | null>(null);

  const handleSearch = (e: React.ChangeEvent<HTMLInputElement>) => {
    setQuery((prev) => ({ ...prev, search: e.target.value, skip: 0 }));
  };

  const handleFilterChange = (key: keyof BookingsQuery, value: string) => {
    setQuery((prev) => ({
      ...prev,
      [key]: value === "ALL" ? "" : value,
      skip: 0,
    }));
  };

  const handleForceCancel = (row: Booking) => {
    setSelectedBookingForCancel(row);
    setIsCancelDialogOpen(true);
  };

  const submitCancel = async (reason: string) => {
    if (selectedBookingForCancel) {
      await cancelMutation.mutateAsync({ id: selectedBookingForCancel.id, reason });
      setIsCancelDialogOpen(false);
      setSelectedBookingForCancel(null);
    }
  };

  const handlePageChange = (page: number) => {
    setQuery((prev) => ({ ...prev, skip: (page - 1) * (prev.limit || 10) }));
  };

  const handleItemsPerPageChange = (limit: number) => {
    setQuery((prev) => ({ ...prev, limit, skip: 0 }));
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "COMPLETED":
        return "default";
      case "PENDING":
      case "ACCEPTED":
        return "secondary";
      case "IN_TRIP":
      case "ARRIVED":
        return "default";
      case "CANCELLED":
      case "ADMIN_CANCELLED":
        return "destructive";
      default:
        return "outline";
    }
  };

  const columns = [
    { key: "booking_code" as const, label: "Booking Code" },
    {
      key: "customer_id" as const,
      label: "Customer ID",
      render: (_: any, row: any) => <span className="font-medium text-muted-foreground">#{row.customer_id}</span>,
    },
    {
      key: "service_mode" as const,
      label: "Service",
      render: (value: string, row: any) => (
        <div className="flex flex-col">
          <span>{value}</span>
          <span className="text-xs text-muted-foreground">{row.booking_mode}</span>
        </div>
      ),
    },
    {
      key: "pickup_address" as const,
      label: "Route",
      render: (value: string, row: any) => (
        <div className="flex flex-col text-sm max-w-[200px] truncate">
          <span className="truncate" title={value}>P: {value}</span>
          <span className="truncate text-muted-foreground" title={row.drop_address}>D: {row.drop_address || "N/A"}</span>
        </div>
      ),
    },
    {
      key: "final_fare" as const,
      label: "Fare",
      render: (value: number | undefined, row: any) => (
        <span>₹{value || row.estimated_fare || 0}</span>
      ),
    },
    {
      key: "status" as const,
      label: "Status",
      render: (value: string) => (
        <Badge variant={getStatusColor(value) as any}>{value}</Badge>
      ),
    },
  ];

  const actions = [
    {
      label: "Force Cancel",
      onClick: handleForceCancel,
      isDestructive: true,
      // Only allow cancellation if it's not already completed or cancelled
      // This is a rough check, in reality we might want a function to determine this
    },
  ];

  // We can filter actions per row
  const rowActions = (row: Booking) => {
    if (row.status === "COMPLETED" || row.status === "CANCELLED" || row.status === "ADMIN_CANCELLED") {
      return [];
    }
    return actions;
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title="Booking Management"
        description="View and manage all system bookings."
      />

      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="flex flex-1 items-center gap-2 max-w-sm">
          <div className="relative w-full">
            <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Search by code..."
              className="pl-8"
              value={query.search}
              onChange={handleSearch}
            />
          </div>
        </div>
        
        <div className="flex flex-wrap items-center gap-2">
          <Select
            value={query.status || "ALL"}
            onValueChange={(val) => handleFilterChange("status", val)}
          >
            <SelectTrigger className="w-[140px]">
              <SelectValue placeholder="Status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="ALL">All Statuses</SelectItem>
              <SelectItem value="PENDING">Pending</SelectItem>
              <SelectItem value="ACCEPTED">Accepted</SelectItem>
              <SelectItem value="IN_TRIP">In Trip</SelectItem>
              <SelectItem value="COMPLETED">Completed</SelectItem>
              <SelectItem value="CANCELLED">Cancelled</SelectItem>
            </SelectContent>
          </Select>

          <Select
            value={query.service_mode || "ALL"}
            onValueChange={(val) => handleFilterChange("service_mode", val)}
          >
            <SelectTrigger className="w-[140px]">
              <SelectValue placeholder="Service Mode" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="ALL">All Services</SelectItem>
              <SelectItem value="NORMAL">Normal</SelectItem>
              <SelectItem value="OUTSTATION">Outstation</SelectItem>
              <SelectItem value="RENTAL">Rental</SelectItem>
              <SelectItem value="COURIER">Courier</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      <DataTable
        columns={columns}
        data={paginatedData?.items || []}
        actions={rowActions}
        isLoading={isLoading}
        itemsPerPage={query.limit || 10}
        showCard={true}
        serverSidePagination={true}
        totalItems={paginatedData?.total || 0}
        currentPage={Math.floor((query.skip || 0) / (query.limit || 10)) + 1}
        onItemsPerPageChange={handleItemsPerPageChange}
        onPageChange={handlePageChange}
      />

      <CancelBookingDialog
        open={isCancelDialogOpen}
        onOpenChange={setIsCancelDialogOpen}
        bookingCode={selectedBookingForCancel?.booking_code || ""}
        onSubmit={submitCancel}
        isSubmitting={cancelMutation.isPending}
      />
    </div>
  );
}
