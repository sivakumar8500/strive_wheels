"use client";

import { useState, ReactNode } from "react";
import { EmptyState } from "@/components/ui/empty-state";

import {
  TableHeader,
  TableBody,
  TableRow,
  TableCell,
  Pagination,
} from "@/components/common/Table";

export type ColumnDef<T> = {
  [K in keyof T]: {
    key: K;
    label: ReactNode;
    render?: (value: T[K], row: T) => ReactNode;
    width?: string;
    className?: string;
  };
}[keyof T];

export interface ActionDef<T> {
  label?: string;
  icon?: ReactNode;
  onClick: (row: T) => void;
  className?: string;
}

interface DataTableProps<T extends { id?: string | number }> {
  columns: ColumnDef<T>[];
  data: T[];
  actions?: ActionDef<T>[];
  itemsPerPage?: number;
  onRowClick?: (row: T) => void;
  emptyMessage?: string;
  emptyActionLabel?: string;
  onEmptyAction?: () => void;
  maxHeight?: string | number;
  showCard?: boolean;
  className?: string;
  hidePagination?: boolean;
  serverSidePagination?: boolean;
  isLoading?: boolean;
  totalItems?: number;
  currentPage?: number;
  onPageChange?: (page: number) => void;
  onItemsPerPageChange?: (itemsPerPage: number) => void;
}

export function DataTable<T extends { id?: string | number }>({
  columns,
  data,
  actions,
  itemsPerPage: initialItemsPerPage = 10,
  onRowClick,
  emptyMessage = "No data available",

  maxHeight,
  showCard = true,
  className = "",
  hidePagination = false,
  serverSidePagination = false,
  isLoading = false,
  totalItems,
  currentPage: externalCurrentPage,
  onPageChange,
  onItemsPerPageChange,
}: DataTableProps<T>) {
  const [internalCurrentPage, setInternalCurrentPage] = useState(1);
  const [internalItemsPerPage, setInternalItemsPerPage] =
    useState(initialItemsPerPage);

  const currentPage = externalCurrentPage ?? internalCurrentPage;
  const itemsPerPage = onItemsPerPageChange
    ? initialItemsPerPage
    : internalItemsPerPage;

  const actualTotalItems = serverSidePagination ? totalItems || 0 : data.length;
  const totalPages = Math.ceil(actualTotalItems / itemsPerPage);

  const startIndex = (currentPage - 1) * itemsPerPage;

  // Show paginated data or all data based on prop
  const paginatedData = serverSidePagination
    ? data
    : data.slice(startIndex, startIndex + itemsPerPage);

  const handlePageChange = (newPage: number) => {
    setInternalCurrentPage(newPage);
    onPageChange?.(newPage);
  };

  const handleItemsPerPageChange = (newCount: number) => {
    setInternalItemsPerPage(newCount);
    setInternalCurrentPage(1); // Reset to first page
    onItemsPerPageChange?.(newCount);
    onPageChange?.(1);
  };

  const tableColumns = [
    ...columns.map((col) => ({
      key: String(col.key),
      label: col.label,
      width: col.width || "auto",
    })),
    ...(actions
      ? [{ key: "actions" as const, label: "Actions", width: "120px" }]
      : []),
  ];

  const TableContent =
    paginatedData.length > 0 ? (
      <div
        className={`custom-scrollbar w-full max-w-full overflow-auto flex-1 min-h-0 ${showCard ? "rounded-t-2xl" : ""} ${showCard ? "" : "border border-slate-50"}`}
        style={maxHeight ? { maxHeight } : undefined}
      >
        <table className={`w-full min-w-full border-collapse ${className}`}>
          <TableHeader columns={tableColumns} />
          <TableBody>
            {paginatedData.map((row, idx) => (
              <TableRow
                key={row.id || idx}
                className="group transition-colors hover:bg-slate-50/50"
              >
                {columns.map((column) => (
                  <TableCell
                    key={String(column.key)}
                    style={{ minWidth: column.width, width: column.width }}
                    className={`whitespace-nowrap transition-colors ${column.className || ""}`}
                  >
                    <div
                      onClick={() => onRowClick?.(row)}
                      className={onRowClick ? "cursor-pointer" : ""}
                    >
                      {column.render
                        ? column.render(row[column.key], row)
                        : String(row[column.key] ?? "")}
                    </div>
                  </TableCell>
                ))}
                {actions && (
                  <TableCell className="transition-colors">
                    <div className="flex items-center gap-2">
                      {actions.map((action, idx) => (
                        <button
                          key={idx}
                          onClick={() => action.onClick(row)}
                          className={`cursor-pointer ${
                            action.className ||
                            "rounded-lg p-2 text-slate-400 transition-colors hover:bg-slate-100 hover:text-slate-900"
                          }`}
                          title={action.label}
                        >
                          {action.icon}{" "}
                          {action.label && (
                            <span className="">{action.label}</span>
                          )}
                        </button>
                      ))}
                    </div>
                  </TableCell>
                )}
              </TableRow>
            ))}
          </TableBody>
        </table>
      </div>
    ) : isLoading ? (
      <div className="flex w-full flex-1 flex-col items-center justify-center p-12 text-slate-400 text-sm">
        Loading data...
      </div>
    ) : (
      <div className="flex w-full flex-1 flex-col items-center justify-center p-12">
        <EmptyState
          title={emptyMessage}
          className="border-0 shadow-none bg-transparent"
        />
      </div>
    );

  return (
    <div
      className={`w-full max-w-full flex flex-col flex-1 min-h-0 ${className}`}
    >
      {showCard ? (
        <div className="w-full flex flex-col flex-1 min-h-0 overflow-hidden rounded-2xl border border-slate-100 bg-white shadow-sm">
          {TableContent}
          {!hidePagination && actualTotalItems > 0 && (
            <div className="border-t border-slate-50 mt-auto shrink-0">
              <Pagination
                currentPage={currentPage}
                totalPages={totalPages}
                totalItems={actualTotalItems}
                itemsPerPage={itemsPerPage}
                onPageChange={handlePageChange}
                onItemsPerPageChange={handleItemsPerPageChange}
              />
            </div>
          )}
        </div>
      ) : (
        <div className="flex flex-col flex-1 min-h-0 space-y-2">
          {TableContent}
          {!hidePagination && actualTotalItems > 0 && (
            <Pagination
              currentPage={currentPage}
              totalPages={totalPages}
              totalItems={actualTotalItems}
              itemsPerPage={itemsPerPage}
              onPageChange={handlePageChange}
              onItemsPerPageChange={handleItemsPerPageChange}
            />
          )}
        </div>
      )}
    </div>
  );
}
