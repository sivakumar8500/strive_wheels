"use client";

import React from "react";
import { useFormContext } from "react-hook-form";

import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface NumberInputProps extends Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  "size"
> {
  name: string;
  label?: string;
   
  rules?: any;

  error?: string;
  size?: "sm" | "md" | "lg";
}

export default function NumberInput({
  name,
  label,
  placeholder,
  rules,
  error,
  className,
  required,
  size = "md",
  ...props
}: NumberInputProps) {
  const {
    register,
    formState: { errors },
  } = useFormContext();
  const fieldError = error || (errors[name]?.message as string);

  const sizeClasses = {
    sm: "h-8 px-2 py-1 text-sm",
    md: "h-10 px-3 py-2 text-base",
    lg: "h-12 px-4 py-3 text-lg",
  };

  return (
    <div className="flex w-full flex-col gap-1.5">
      {label && (
        <Label htmlFor={name}>
          {label}
          {required && <span className="text-destructive ml-1">*</span>}
        </Label>
      )}
      <Input
        id={name}
        type="number"
        placeholder={placeholder}
        {...register(name, { ...rules, valueAsNumber: true })}
        className={cn(
          sizeClasses[size],
          className,
          "shadow-none",
          fieldError &&
            "border-destructive focus-visible:ring-destructive shadow-none",
        )}
        {...props}
      />
      {fieldError && (
        <span className="text-destructive animate-in fade-in slide-in-from-top-1 text-xs font-medium">
          {fieldError}
        </span>
      )}
    </div>
  );
}
