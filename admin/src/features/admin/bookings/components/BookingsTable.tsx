"use client";

import { useMemo } from "react";
import { DataTable, ColumnDef } from "@/components/common/Table";
import { Badge } from "@/components/ui/badge";
import { EditIcon, DeleteIcon } from "@/icons";
import { Booking } from "../types";
import { getStatusColor } from "../utils/helpers";

interface BookingsTableProps {
  bookings: Booking[];
  isLoading?: boolean;
  onRowClick?: (booking: Booking) => void;
  onEdit?: (booking: Booking) => void;
  onDelete?: (booking: Booking) => void;
  onPageChange?: (page: number) => void;
  onItemsPerPageChange?: (itemsPerPage: number) => void;
  currentPage?: number;
  totalItems?: number;
  itemsPerPage?: number;
}

export function BookingsTable({
  bookings,
  isLoading,
  onRowClick,
  onEdit,
  onDelete,
  onPageChange,
  onItemsPerPageChange,
  currentPage = 1,
  totalItems = 0,
  itemsPerPage = 10,
}: BookingsTableProps) {
  const columns: ColumnDef<Booking>[] = useMemo(
    () => [
      {
        key: "booking_code" as const,
        label: "Booking Code",
        width: "140px",
      },
      {
        key: "customer_id" as const,
        label: "Customer ID",
        width: "100px",
        render: (customer_id: number) => <span className="font-medium text-muted-foreground">#{customer_id}</span>,
      },
      {
        key: "service_mode" as const,
        label: "Service Mode",
        width: "140px",
      },
      {
        key: "status" as const,
        label: "Status",
        width: "130px",
        render: (status: string) => (
          <Badge className={`${getStatusColor(status)} capitalize`}>
            {status.replace(/_/g, " ")}
          </Badge>
        ),
      },
      {
        key: "final_fare" as const,
        label: "Fare",
        width: "100px",
        render: (price: number | undefined) => (
          <span className="font-medium">{price != null ? `$${price.toFixed(2)}` : "—"}</span>
        ),
      },
      {
        key: "scheduled_at" as const,
        label: "Scheduled At",
        width: "130px",
        render: (scheduled_at?: string | null) => scheduled_at ? new Date(scheduled_at).toLocaleDateString() : "—",
      },
    ],
    [],
  );

  const actions = useMemo(
    () => [
      ...(onEdit
        ? [
            {
              icon: <EditIcon className="h-4 w-4" />,
              onClick: onEdit,
              className: "text-blue-600 hover:text-blue-700",
            },
          ]
        : []),
      ...(onDelete
        ? [
            {
              icon: <DeleteIcon className="h-4 w-4" />,
              onClick: onDelete,
              className: "text-red-600 hover:text-red-700",
            },
          ]
        : []),
    ],
    [onEdit, onDelete],
  );

  return (
    <DataTable<Booking>
      columns={columns}
      data={bookings}
      actions={actions.length > 0 ? actions : undefined}
      isLoading={isLoading}
      showCard={true}
      itemsPerPage={itemsPerPage}
      serverSidePagination={true}
      totalItems={totalItems}
      currentPage={currentPage}
      onPageChange={onPageChange}
      onRowClick={onRowClick}
      onItemsPerPageChange={onItemsPerPageChange}
      emptyMessage="No bookings found"
      maxHeight="calc(95vh - 250px)"
    />
  );
}
