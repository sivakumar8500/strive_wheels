"use client";

import React from "react";
import { useFormContext, Controller, RegisterOptions } from "react-hook-form";
import { ChevronDown } from "lucide-react";

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

export interface SelectOption {
  label: string;
  value: string;
}

export interface SelectInputProps {
  name: string;
  label?: string;
  options: SelectOption[];
  rules?: RegisterOptions;
  placeholder?: string;
  error?: string;
  className?: string;
  required?: boolean;
  size?: "xs" | "sm" | "md" | "lg";
  labelClassName?: string;
  onChange?: (value: string, name?: string) => void;
}

export default function SelectInput({
  name,
  label,
  options,
  rules,
  placeholder,
  error,
  className,
  required,
  size = "md",
  labelClassName,
  onChange,
}: SelectInputProps) {
  const { control } = useFormContext();

  const sizeClasses = {
    xs: "h-8 px-2 text-xs",
    sm: "h-9 px-2 text-sm",
    md: "h-10 px-3 text-sm",
    lg: "h-12 px-4 text-lg",
  };

  return (
    <div className="flex w-full flex-col gap-1.5">
      {label && (
        <Label htmlFor={name} className={cn(` ${labelClassName}`)}>
          {label}
          {required && <span className="text-destructive ml-1">*</span>}
        </Label>
      )}
      <Controller
        name={name}
        control={control}
        rules={rules}
        render={({ field, fieldState }) => {
          const selectedOption = options.find(
            (opt) => opt.value === field.value,
          );
          const currentError = error || fieldState.error?.message;

          return (
            <div className="relative flex flex-col">
              <DropdownMenu>
                <DropdownMenuTrigger
                  id={name}
                  className={cn(
                    "flex w-full items-center justify-between rounded-md border border-input bg-transparent shadow-none outline-none transition-colors focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
                    sizeClasses[size],
                    className,
                    "shadow-none",
                    currentError &&
                      "border-destructive focus:ring-destructive shadow-none",
                  )}
                >
                  <span
                    className={cn(!selectedOption && "text-muted-foreground")}
                  >
                    {selectedOption
                      ? selectedOption.label
                      : placeholder || "Select..."}
                  </span>
                  <ChevronDown className="h-4 w-4 opacity-50" />
                </DropdownMenuTrigger>
                <DropdownMenuContent
                  className="w-[var(--radix-dropdown-menu-trigger-width)] min-w-[var(--radix-dropdown-menu-trigger-width)]"
                  align="start"
                >
                  {options.map((option) => (
                    <DropdownMenuItem
                      key={option.value}
                      onClick={() => {
                        field.onChange(option.value);
                        if (onChange) onChange(option.value, name);
                      }}
                      className={cn(
                        "py-2 cursor-pointer",
                        size === "xs"
                          ? "text-xs"
                          : size === "sm"
                            ? "text-sm"
                            : "text-base",
                        field.value === option.value &&
                          "bg-accent text-accent-foreground",
                      )}
                    >
                      {option.label}
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>
              {currentError && (
                <span className="text-destructive animate-in fade-in slide-in-from-top-1 text-xs font-medium mt-1.5">
                  {currentError}
                </span>
              )}
            </div>
          );
        }}
      />
    </div>
  );
}
