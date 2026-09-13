import React from "react";
import { Button } from "@/components/ui/button";
import { DialogFooter } from "@/components/ui/dialog";
import { cn } from "@/lib/utils";

export interface FormDialogFooterProps {
  isEdit?: boolean;
  isPending?: boolean;
  onClose?: () => void;
  onCancel?: () => void;
  onSubmit?: (e?: React.BaseSyntheticEvent) => void | Promise<void>;
  createText?: React.ReactNode;
  createLoadingText?: React.ReactNode;
  editText?: React.ReactNode;
  editLoadingText?: React.ReactNode;
  cancelText?: React.ReactNode;
  className?: string;
  submitButtonClassName?: string;
}

export default function FormDialogFooter({
  isEdit = false,
  isPending = false,
  onClose,
  onCancel,
  onSubmit,
  createText = "Create",
  createLoadingText = "Saving...",
  editText = "Save Changes",
  editLoadingText = "Saving...",
  cancelText = "Cancel",
  className,
  submitButtonClassName,
}: FormDialogFooterProps) {
  const handleCancel = onCancel || onClose;

  return (
    <DialogFooter
      className={cn("flex flex-row gap-4 pt-2 sm:justify-between", className)}
    >
      <Button
        variant="outline"
        className="h-12 flex-1 rounded-xl border-slate-100 font-bold text-slate-500 hover:bg-slate-50"
        type="button"
        onClick={handleCancel}
      >
        {cancelText}
      </Button>
      <Button
        type="submit"
        disabled={isPending}
        className={cn(
          "h-12 flex-1 rounded-xl bg-[#0095FF] font-bold text-white transition-all hover:bg-[#0084E6]",
          submitButtonClassName,
        )}
        onClick={onSubmit}
      >
        {isEdit
          ? isPending
            ? editLoadingText
            : editText
          : isPending
            ? createLoadingText
            : createText}
      </Button>
    </DialogFooter>
  );
}
