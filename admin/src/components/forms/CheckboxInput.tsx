"use client";

import { useFormContext, Controller, RegisterOptions } from "react-hook-form";

import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface CheckboxInputProps {
  name: string;
  label: string;
  rules?: RegisterOptions;
  labelClassName?: string;
  className?: string;
  required?: boolean;
  disabled?: boolean;
}

export default function CheckboxInput({
  name,
  label,
  rules,
  className,
  required,
  labelClassName,
  disabled,
}: CheckboxInputProps) {
  const {
    control,
    formState: { errors },
  } = useFormContext();
  const fieldError = errors[name]?.message as string;

  return (
    <div className={cn("flex w-full flex-col gap-1", className)}>
      <div className="flex items-start gap-3">
        <Controller
          name={name}
          control={control}
          rules={rules}
          render={({ field }) => (
            <Checkbox
              id={name}
              checked={field.value}
              onCheckedChange={field.onChange}
              className={cn(
                "mt-0.5",
                fieldError && "border-destructive shadow-none",
              )}
              disabled={disabled}
            />
          )}
        />
        <Label
          htmlFor={name}
          className={cn("cursor-pointer leading-tight", labelClassName)}
        >
          {label}
          {required && <span className="text-destructive ml-1">*</span>}
        </Label>
      </div>
      {fieldError && (
        <span className="text-destructive animate-in fade-in slide-in-from-top-1 ml-7 text-xs font-medium">
          {fieldError}
        </span>
      )}
    </div>
  );
}
