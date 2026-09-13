"use client";

import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogDescription,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import TextArea from "@/components/forms/TextArea";

const schema = z.object({
  cancellation_reason: z.string().min(5, "Reason must be at least 5 characters long"),
});

type FormData = z.infer<typeof schema>;

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  bookingCode: string;
  onSubmit: (reason: string) => void;
  isSubmitting?: boolean;
}

export function CancelBookingDialog({
  open,
  onOpenChange,
  bookingCode,
  onSubmit,
  isSubmitting = false,
}: Props) {
  const methods = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      cancellation_reason: "",
    },
  });

  const { reset, handleSubmit } = methods;

  const handleFormSubmit = (data: FormData) => {
    onSubmit(data.cancellation_reason);
    reset();
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Force Cancel Booking</DialogTitle>
          <DialogDescription>
            You are about to force cancel booking <strong>{bookingCode}</strong>. Please provide a reason for this cancellation. This action cannot be undone.
          </DialogDescription>
        </DialogHeader>

        <FormProvider {...methods}>
          <form onSubmit={handleSubmit(handleFormSubmit)} className="space-y-4">
            <TextArea 
              name="cancellation_reason" 
              label="Cancellation Reason" 
              placeholder="e.g. Customer requested via phone, driver vehicle broke down..."
            />

            <DialogFooter className="pt-4">
              <Button
                type="button"
                variant="outline"
                onClick={() => onOpenChange(false)}
                disabled={isSubmitting}
              >
                Go Back
              </Button>
              <Button type="submit" variant="destructive" disabled={isSubmitting}>
                {isSubmitting ? "Cancelling..." : "Confirm Cancellation"}
              </Button>
            </DialogFooter>
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
