"use client";

import React from "react";
import { useFormContext, Controller, RegisterOptions } from "react-hook-form";
import { MultiSelect } from "@/components/ui/multi-select";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

export interface MultiSelectInputProps {
  name: string;
  label?: string;
  options: string[];
  rules?: RegisterOptions;
  placeholder?: string;
  error?: string;
  className?: string;
  required?: boolean;
  labelClassName?: string;
}

export default function MultiSelectInput({
  name,
  label,
  options,
  rules,
  placeholder,
  error,
  className,
  required,
  labelClassName,
}: MultiSelectInputProps) {
  const { control } = useFormContext();

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
          const currentError = error || fieldState.error?.message;
          const selected = Array.isArray(field.value) ? field.value : [];

          const handleToggle = (option: string) => {
            const newSelected = selected.includes(option)
              ? selected.filter((item) => item !== option)
              : [...selected, option];
            field.onChange(newSelected);
          };

          return (
            <div className="relative flex flex-col">
              <MultiSelect
                options={options}
                selected={selected}
                onToggle={handleToggle}
                placeholder={placeholder}
                className={cn(
                  currentError && "border-destructive focus:ring-destructive",
                  className,
                )}
              />
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
