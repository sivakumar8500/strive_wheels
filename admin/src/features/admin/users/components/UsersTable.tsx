"use client";

import { useMemo } from "react";
import { DataTable, ColumnDef } from "@/components/common/Table";
import { Badge } from "@/components/ui/badge";
import { EditIcon, DeleteIcon } from "@/icons";
import { User } from "../types";

interface UsersTableProps {
  users: User[];
  isLoading?: boolean;
  onRowClick?: (user: User) => void;
  onEdit?: (user: User) => void;
  onDelete?: (user: User) => void;
  onPageChange?: (page: number) => void;
  onItemsPerPageChange?: (itemsPerPage: number) => void;
  currentPage?: number;
  totalItems?: number;
  itemsPerPage?: number;
}

export function UsersTable({
  users,
  isLoading,
  onRowClick,
  onEdit,
  onDelete,
  onPageChange,
  onItemsPerPageChange,
  currentPage = 1,
  totalItems = 0,
  itemsPerPage = 10,
}: UsersTableProps) {

  const columns: ColumnDef<User>[] = useMemo(
    () => [
      {
        key: "first_name" as const,
        label: "First Name",
        width: "150px",
      },
      {
        key: "last_name" as const,
        label: "Last Name",
        width: "150px",
      },
      {
        key: "email" as const,
        label: "Email",
        width: "250px",
      },
      {
        key: "role" as const,
        label: "Role",
        width: "120px",
        render: (role: string) => <span className="capitalize">{role}</span>,
      },
      {
        key: "is_active" as const,
        label: "Status",
        width: "120px",
        render: (isActive: boolean) => (
          <Badge className={isActive ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800"}>
            {isActive ? "Active" : "Inactive"}
          </Badge>
        ),
      },
      {
        key: "created_at" as const,
        label: "Created At",
        width: "150px",
        render: (date: string) => new Date(date).toLocaleDateString(),
      },
      {
        key: "last_login" as const,
        label: "Last Login",
        width: "150px",
        render: (date?: string) =>
          date ? new Date(date).toLocaleDateString() : "Never",
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
    <DataTable<User>
      maxHeight="calc(90vh - 230px)"
      columns={columns}
      data={users}
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
      emptyMessage="No users found"
      maxHeight="calc(95vh - 250px)"
    />
  );
}
