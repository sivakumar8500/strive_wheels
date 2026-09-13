"use client";

import React from "react";
import { Controller, useFormContext } from "react-hook-form";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface ToggleSwitchProps {
  name: string;
  label?: string;
  description?: string;
  disabled?: boolean;
  className?: string;
  labelClassName?: string;
  descriptionClassName?: string;
}

export default function ToggleSwitch({
  name,
  label,
  description,
  disabled = false,
  className,
  labelClassName,
  descriptionClassName,
}: ToggleSwitchProps) {
  const { control } = useFormContext();

  return (
    <Controller
      name={name}
      control={control}
      render={({ field }) => (
        <div
          className={cn("flex items-center justify-between gap-4", className)}
        >
          {(label || description) && (
            <div className="flex flex-col gap-0.5 pr-4">
              {label && (
                <Label
                  htmlFor={name}
                  className={cn(
                    "cursor-pointer font-semibold text-slate-800 text-[16px]",
                    labelClassName,
                  )}
                >
                  {label}
                </Label>
              )}
              {description && (
                <span
                  className={cn(
                    "text-slate-500 text-[13.5px] leading-snug",
                    descriptionClassName,
                  )}
                >
                  {description}
                </span>
              )}
            </div>
          )}
          <Switch
            id={name}
            checked={field.value}
            onCheckedChange={field.onChange}
            disabled={disabled}
          />
        </div>
      )}
    />
  );
}
