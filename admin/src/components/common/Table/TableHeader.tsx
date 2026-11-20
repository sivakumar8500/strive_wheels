"use client";

import { ReactNode } from "react";

interface TableHeaderProps {
  columns: Array<{
    key: string;
    label: ReactNode;
    width?: string;
    className?: string;
  }>;
}

export function TableHeader({ columns }: TableHeaderProps) {
  return (
    <thead className="sticky top-0 z-20 border-b border-slate-100 bg-[#F8FAFC]">
      <tr>
        {columns.map((column) => (
          <th
            key={column.key}
            style={{ minWidth: column.width, width: column.width }}
            className={`px-6 py-5 text-left text-[10px] font-bold tracking-[0.15em] whitespace-nowrap text-slate-400 uppercase ${column.className || ""}`}
          >
            {column.label}
          </th>
        ))}
      </tr>
    </thead>
  );
}
