"use client";

import React from "react";
import { useFormContext, RegisterOptions } from "react-hook-form";

import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface TextAreaProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  name: string;
  label?: string;
  rules?: RegisterOptions;
  size?: "xs" | "sm" | "md" | "lg";

  error?: string;
}

export default function TextArea({
  name,
  label,
  placeholder,
  rules,
  error,
  className,
  required,
  size = "md",
  rows = 4,
  ...props
}: TextAreaProps) {
  const {
    register,
    formState: { errors },
  } = useFormContext();
  const fieldError = error || (errors[name]?.message as string);

  const sizeClasses = {
    xs: "px-2 py-1 text-xs",
    sm: "px-2 py-1.5 text-sm",
    md: "px-3 py-2 text-sm",
    lg: "px-4 py-3 text-lg",
  };

  return (
    <div className="flex w-full flex-col gap-1.5">
      {label && (
        <Label htmlFor={name} className="">
          {label}
          {required && <span className="text-destructive ml-1">*</span>}
        </Label>
      )}
      <Textarea
        id={name}
        rows={rows}
        placeholder={placeholder}
        {...register(name, rules)}
        className={cn(
          "resize-none",
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
