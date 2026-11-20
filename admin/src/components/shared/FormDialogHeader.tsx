import React from "react";
import { DialogHeader, DialogTitle, DialogClose, DialogDescription } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";

export interface FormDialogHeaderProps {
  title: React.ReactNode;
  description?: React.ReactNode;
  onClose?: () => void;
  className?: string;
}

export default function FormDialogHeader({
  title,
  description,
  onClose,
  className = "flex flex-row items-center justify-between",
}: FormDialogHeaderProps) {
  return (
    <DialogHeader className={className}>
      <div className="flex flex-col space-y-1.5">
        <DialogTitle className="text-xl font-bold text-slate-900">
          {title}
        </DialogTitle>
        {description && (
          <DialogDescription>
            {description}
          </DialogDescription>
        )}
      </div>
      <DialogClose asChild>
        <Button
          variant="ghost"
          size="icon"
          className="h-8 w-8 rounded-lg bg-slate-50 text-slate-500 hover:bg-slate-100 hover:text-slate-900 self-start"
          onClick={onClose}
        >
          <X className="h-4 w-4" />
        </Button>
      </DialogClose>
    </DialogHeader>
  );
}
