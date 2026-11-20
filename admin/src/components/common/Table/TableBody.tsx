"use client";

import { ReactNode } from "react";

interface TableBodyProps {
  children: ReactNode;
}

export function TableBody({ children }: TableBodyProps) {
  return <tbody className="divide-border divide-y">{children}</tbody>;
}

interface TableRowProps {
  children: ReactNode;
  className?: string;
  onClick?: () => void;
}

export function TableRow({ children, className = "", onClick }: TableRowProps) {
  return (
    <tr
      className={`group transition-colors hover:bg-slate-50/50 ${className}`}
      onClick={onClick}
    >
      {children}
    </tr>
  );
}

interface TableCellProps {
  children: ReactNode;
  className?: string;
  style?: React.CSSProperties;
  colSpan?: number;
}

export function TableCell({
  children,
  className = "",
  style,
  colSpan,
}: TableCellProps) {
  return (
    <td
      className={`px-6 py-4 text-sm ${className}`}
      style={style}
      colSpan={colSpan}
    >
      {children}
    </td>
  );
}
