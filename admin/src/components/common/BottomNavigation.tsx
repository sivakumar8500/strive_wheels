"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";

interface BottomNavProps {
  backHref?: string;
  backLabel?: string;
  leftAction?: { label: string; onClick?: () => void; disabled?: boolean };
  rightActions?: Array<{
    label: string;
    onClick?: () => void;
    disabled?: boolean;
    variant?: "default" | "outline" | "destructive";
  }>;
}

export function BottomNavigation({
  backHref,
  backLabel = "Back",
  leftAction,
  rightActions = [],
}: BottomNavProps) {
  return (
    <div className="border-border mt-8 flex items-center justify-between border-t pt-6">
      {backHref ? (
        <Link href={backHref}>
          <Button variant="outline" className="gap-2">
            ← {backLabel}
          </Button>
        </Link>
      ) : leftAction ? (
        <Button
          variant="outline"
          onClick={leftAction.onClick}
          disabled={leftAction.disabled}
          className={leftAction.disabled ? "cursor-not-allowed" : ""}
        >
          {leftAction.label}
        </Button>
      ) : (
        <div />
      )}

      <div className="flex items-center gap-2">
        {rightActions.map((action, index) => (
          <Button
            key={index}
            variant={action.variant || "outline"}
            onClick={action.onClick}
            disabled={action.disabled}
            className={action.disabled ? "cursor-not-allowed" : ""}
          >
            {action.label}
          </Button>
        ))}
      </div>
    </div>
  );
}
