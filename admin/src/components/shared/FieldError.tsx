import React from "react";

interface FieldErrorProps {
  message?: string;
}

export const FieldError = ({ message }: FieldErrorProps) => {
  if (!message) return null;

  return (
    <p className="mt-1 text-xs font-medium text-red-500 animate-in fade-in slide-in-from-top-1 duration-200">
      {message}
    </p>
  );
};
