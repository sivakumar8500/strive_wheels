"use client";

import { usePathname, useRouter } from "next/navigation";

import { cn } from "@/lib/utils";

// ─── Helpers ──────────────────────────────────────────────────────────────────

/** Detect UUID, numeric, or long alphanumeric IDs */
function isId(segment: string): boolean {
  return (
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
      segment,
    ) ||
    /^\d+$/.test(segment) ||
    (segment.length > 16 && /^[a-z0-9]+$/i.test(segment))
  );
}

/** Convert a raw URL segment to a readable label */
function autoLabel(segment: string): string {
  if (isId(segment)) return `#${segment.slice(0, 8)}`;
  return segment.replace(/[-_]/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}

// ─── Types ────────────────────────────────────────────────────────────────────

export interface BreadcrumbProps {
  /**
   * Optional override map: { [urlSegment]: "Pretty Label" }
   * Pass from the page when you have a fetched name to display,
   * e.g. { "abc-123": "My Campaign Name" }
   */
  labels?: Record<string, string>;
  className?: string;
}

// ─── Component ────────────────────────────────────────────────────────────────

export function Breadcrumb({ labels = {}, className }: BreadcrumbProps) {
  const pathname = usePathname();
  const router = useRouter();

  const segments = pathname.split("/").filter(Boolean);

  const items = segments.map((seg, i) => ({
    segment: seg,
    label: labels[seg] ?? autoLabel(seg),
    href: "/" + segments.slice(0, i + 1).join("/"),
    isLast: i === segments.length - 1,
  }));

  return (
    <nav
      aria-label="Breadcrumb"
      className={cn("flex items-center gap-1.5", className)}
    >
      <span className="text-foreground/50 text-xs select-none">Pages</span>

      {items.map((item) => (
        <span key={item.href} className="flex items-center gap-1.5">
          <span className="text-muted-foreground/50 text-xs select-none">
            /
          </span>

          {item.isLast ? (
            <span
              className="text-foreground text-xs font-bold tracking-tight"
              aria-current="page"
            >
              {item.label}
            </span>
          ) : (
            <button
              onClick={() => router.push(item.href)}
              className="text-muted-foreground hover:text-foreground text-xs font-semibold tracking-tight transition-colors"
            >
              {item.label}
            </button>
          )}
        </span>
      ))}
    </nav>
  );
}
