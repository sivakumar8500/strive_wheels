"use client";

import { Button } from "@/components/ui/button";
import { ChevronLeft, ChevronRight } from "lucide-react";

interface PaginationProps {
  currentPage: number;
  totalPages: number;
  totalItems: number;
  itemsPerPage: number;
  onPageChange: (page: number) => void;
  onItemsPerPageChange?: (count: number) => void;
}

export function Pagination({
  currentPage,
  totalPages,
  totalItems,
  itemsPerPage,
  onPageChange,
  onItemsPerPageChange,
}: PaginationProps) {
  const startItem = (currentPage - 1) * itemsPerPage + 1;
  const endItem = Math.min(currentPage * itemsPerPage, totalItems);

  return (
    <div className="flex flex-col items-center justify-between gap-4 bg-[#F8FAFC] px-8 py-5 sm:flex-row">
      <div className="flex items-center gap-6">
        <p className="text-sm font-medium text-slate-400">
          Showing{" "}
          <span className="font-bold text-slate-900">
            {startItem}-{endItem}
          </span>{" "}
          of <span className="font-bold text-slate-900">{totalItems}</span>{" "}
          items
        </p>

        {onItemsPerPageChange && (
          <div className="flex items-center gap-3 border-l border-slate-100 pl-6">
            <span className="text-xs font-bold tracking-widest text-slate-400 uppercase">
              Rows per page:
            </span>
            <select
              value={itemsPerPage}
              onChange={(e) => onItemsPerPageChange(Number(e.target.value))}
              className="cursor-pointer rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-sm font-bold text-slate-600 transition-colors outline-none hover:border-slate-300"
            >
              {[5, 10, 20, 50].map((size) => (
                <option key={size} value={size}>
                  {size}
                </option>
              ))}
            </select>
          </div>
        )}
      </div>

      <div className="flex items-center gap-2">
        <Button
          variant="outline"
          size="icon"
          disabled={currentPage === 1}
          onClick={() => onPageChange(currentPage - 1)}
          className="h-9 w-9 rounded-xl border-slate-200 text-slate-400 shadow-none transition-all hover:border-slate-300 hover:text-slate-600"
        >
          <ChevronLeft className="h-4 w-4" />
        </Button>

        <div className="flex items-center gap-1.5">
          {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
            <Button
              key={page}
              variant="outline"
              size="sm"
              onClick={() => onPageChange(page)}
              className={`h-9 min-w-[36px] rounded-xl border-none px-2 font-black shadow-none transition-all ${
                page === currentPage
                  ? "bg-primary shadow-primary/20 scale-105 text-white shadow-md"
                  : "text-slate-400 hover:bg-slate-50 hover:text-slate-600"
              }`}
            >
              {page}
            </Button>
          ))}
        </div>

        <Button
          variant="outline"
          size="icon"
          disabled={currentPage === totalPages || totalPages === 0}
          onClick={() => onPageChange(currentPage + 1)}
          className="h-9 w-9 rounded-xl border-slate-200 text-slate-400 shadow-none transition-all hover:border-slate-300 hover:text-slate-600"
        >
          <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </div>
  );
}
