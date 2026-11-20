"use client";

import React, { useState } from "react";
import { useFormContext, RegisterOptions } from "react-hook-form";

import { Eye, EyeOff } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface PasswordInputProps extends Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  "size" | "type"
> {
  name: string;
  label?: string;
  rules?: RegisterOptions;
  error?: string;
  size?: "sm" | "md" | "lg";
  labelClassName?: string;
}

export default function PasswordInput({
  name,
  label,
  placeholder,
  rules,
  error,
  className,
  required,
  size = "md",
  labelClassName,
  disabled,
  ...props
}: PasswordInputProps) {
  const {
    register,
    formState: { errors },
  } = useFormContext();
  const [show, setShow] = useState(false);
  const fieldError = error || (errors[name]?.message as string);

  const sizeClasses = {
    sm: "h-8 px-2 py-1 text-sm",
    md: "h-10 px-3 py-2 text-base",
    lg: "h-12 px-4 py-3 text-lg",
  };

  return (
    <div className="flex w-full flex-col gap-1.5">
      {label && (
        <Label htmlFor={name} className={labelClassName}>
          {label}
          {required && <span className="text-destructive ml-1">*</span>}
        </Label>
      )}
      <div className="relative">
        <Input
          id={name}
          type={show ? "text" : "password"}
          placeholder={placeholder}
          disabled={disabled}
          {...register(name, rules)}
          // onCopy={(e) => e.preventDefault()}
          // onCut={(e) => e.preventDefault()}
          // onPaste={(e) => e.preventDefault()}
          className={cn(
            "pr-10",
            sizeClasses[size],
            className,
            "shadow-none",
            fieldError &&
              "border-destructive focus-visible:ring-destructive shadow-none",
          )}
          {...props}
        />
        <button
          type="button"
          onClick={() => setShow(!show)}
          disabled={disabled}
          tabIndex={-1}
          className="absolute top-1/2 right-2 -translate-y-1/2 text-muted-foreground hover:text-foreground focus:outline-none disabled:opacity-50"
          aria-label={show ? "Hide password" : "Show password"}
        >
          {show ? <Eye className="h-4 w-4" /> : <EyeOff className="h-4 w-4" />}
        </button>
      </div>
      {fieldError && (
        <span className="text-destructive animate-in fade-in slide-in-from-top-1 text-xs font-medium">
          {fieldError}
        </span>
      )}
    </div>
  );
}
