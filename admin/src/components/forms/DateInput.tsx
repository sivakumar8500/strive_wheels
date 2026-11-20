"use client";

import * as React from "react";
import { format } from "date-fns";
import { Calendar as CalendarIcon } from "lucide-react";
import { useFormContext, Controller, RegisterOptions } from "react-hook-form";

import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { Label } from "@/components/ui/label";

export interface DateInputProps {
  name: string;
  label?: string;
  rules?: RegisterOptions;
  placeholder?: string;
  error?: string;
  className?: string;
  required?: boolean;
  size?: "sm" | "md" | "lg";
  labelClassName?: string;
}

export default function DateInput({
  name,
  label,
  rules,
  placeholder = "Pick a date",
  error,
  className,
  required,
  size = "md",
  labelClassName,
}: DateInputProps) {
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
        <Label htmlFor={name} className={labelClassName}>
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

          // Our store holds a YYYY-MM-DD string.
          // Parse it safely so the calendar highlights the correct date.
          let dateValue: Date | undefined = undefined;
          if (field.value) {
            const parsed = new Date(field.value);
            if (!isNaN(parsed.getTime())) {
              dateValue = parsed;
            }
          }

          return (
            <div className="relative flex flex-col">
              <Popover>
                <PopoverTrigger asChild>
                  <Button
                    id={name}
                    variant="outline"
                    className={cn(
                      "w-full justify-between text-left font-normal text-xs border-input bg-transparent shadow-none hover:bg-transparent",
                      sizeClasses[size],
                      !field.value && "text-muted-foreground",
                      className,
                      "shadow-none",
                      currentError &&
                        "border-destructive focus:ring-destructive shadow-none",
                    )}
                  >
                    {dateValue ? (
                      format(dateValue, "PPP")
                    ) : (
                      <span>{placeholder}</span>
                    )}
                    <CalendarIcon className="ml-2 h-4 w-4 opacity-70 cursor-pointer" />
                  </Button>
                </PopoverTrigger>
                <PopoverContent className="w-auto p-0" align="start">
                  <Calendar
                    mode="single"
                    selected={dateValue}
                    disabled={(date) => {
                      const today = new Date();
                      today.setHours(0, 0, 0, 0);
                      return date < today;
                    }}
                    onSelect={(date) => {
                      if (date) {
                        field.onChange(format(date, "yyyy-MM-dd"));
                      } else {
                        field.onChange("");
                      }
                    }}
                  />
                </PopoverContent>
              </Popover>
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
