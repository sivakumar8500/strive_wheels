"use client";

import React from "react";
import { useFormContext, RegisterOptions } from "react-hook-form";

import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface TextInputProps extends Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  "size"
> {
  name: string;
  label?: string;
  rules?: RegisterOptions;

  error?: string;
  size?: "xs" | "sm" | "md" | "lg";
  icon?: React.ReactNode;
  iconPosition?: "left" | "right";
  labelClassName?: string;

  readOnly?: boolean;
}

export default function TextInput({
  name,
  label,
  placeholder,
  rules,
  error,
  className,
  required,
  type = "text",
  size = "md",
  icon,
  iconPosition = "left",
  labelClassName,
  readOnly,
  ...props
}: TextInputProps) {
  const {
    register,
    formState: { errors },
  } = useFormContext();

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const getNestedError = (obj: any, path: string) => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return path
      .split(/[.[\]]/)
      .filter(Boolean)
      .reduce(
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (res: any, key) => (res !== null && res !== undefined ? res[key] : res),
        obj,
      );
  };

  const fieldError = error || (getNestedError(errors, name)?.message as string);

  const sizeClasses = {
    xs: "h-8 px-2 py-1 text-xs",
    sm: "h-9 px-2 py-1 text-sm",
    md: "h-10 px-3 py-2 text-sm",
    lg: "h-12 px-4 py-3 text-lg",
  };

  return (
    <div className="flex w-full flex-col gap-1.5">
      {label && (
        <Label htmlFor={name} className={cn(` ${labelClassName} `)}>
          {label}
          {required && <span className="text-destructive ml-1">*</span>}
        </Label>
      )}
      <div className="relative">
        {icon && iconPosition === "left" && (
          <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
            {icon}
          </div>
        )}
        <Input
          id={name}
          type={type}
          placeholder={placeholder}
          {...register(name, rules)}
          disabled={readOnly}
          min={0}
          className={cn(
            sizeClasses[size],
            icon && iconPosition === "left" && "pl-10",
            icon && iconPosition === "right" && "pr-10",
            className,
            "shadow-none",
            type === "number" &&
              "[appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none",
            fieldError &&
              "border-destructive focus-visible:ring-destructive shadow-none",
          )}
          {...props}
        />
        {icon && iconPosition === "right" && (
          <div className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400">
            {icon}
          </div>
        )}
      </div>
      {fieldError && (
        <span className="text-destructive animate-in fade-in slide-in-from-top-1 text-xs font-medium">
          {fieldError}
        </span>
      )}
    </div>
  );
}
