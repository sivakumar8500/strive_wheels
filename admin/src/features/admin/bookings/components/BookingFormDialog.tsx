"use client";

import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import TextInput from "@/components/forms/TextInput";
import SelectInput from "@/components/forms/SelectInput";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import { Booking } from "../types";
import { bookingFormSchema, BookingFormData } from "../utils/formSchema";
import { useEffect } from "react";

interface BookingFormDialogProps {
  isOpen: boolean;
  isLoading?: boolean;
  booking: Booking | null;
  onClose: () => void;
  onSubmit: (data: BookingFormData) => Promise<void>;
}

export function BookingFormDialog({
  isOpen,
  isLoading = false,
  booking,
  onClose,
  onSubmit,
}: BookingFormDialogProps) {
  const isEdit = !!booking;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const methods = useForm<BookingFormData>({
    resolver: zodResolver(bookingFormSchema) as any,
    defaultValues: {
      customer_id: 0,
      service_mode: "NORMAL",
      status: "PENDING",
      final_fare: 0,
    },
  });

  const { handleSubmit, reset } = methods;

  useEffect(() => {
    if (booking && isOpen) {
      reset({
        customer_id: booking.customer_id,
        service_mode: booking.service_mode,
        status: booking.status,
        final_fare: booking.final_fare ?? 0,
      });
    } else if (!isOpen) {
      reset();
    }
  }, [booking, isOpen, reset]);

  const handleOpenChange = (open: boolean) => {
    if (!open) {
      reset();
      onClose();
    }
  };

  const onFormSubmit = async (data: BookingFormData) => {
    await onSubmit(data);
    reset();
  };

  return (
    <Dialog open={isOpen} onOpenChange={handleOpenChange}>
      <DialogContent showCloseButton={false} className="max-w-md">
        <FormDialogHeader
          title={isEdit ? "Edit Booking" : "Add New Booking"}
          onClose={onClose}
        />

        <FormProvider {...methods}>
          {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
          <form onSubmit={(methods.handleSubmit as any)(onFormSubmit)} className="space-y-4">
            <TextInput
              name="customer_id"
              label="Customer ID"
              type="number"
              placeholder="e.g. 1"
              required
            />

            <SelectInput
              name="service_mode"
              label="Service Mode"
              placeholder="Select mode"
              options={[
                { value: "NORMAL", label: "Normal" },
                { value: "OUTSTATION", label: "Outstation" },
                { value: "RENTAL", label: "Rental" },
                { value: "COURIER", label: "Courier" },
              ]}
              required
            />

            <SelectInput
              name="status"
              label="Status"
              placeholder="Select status"
              options={[
                { value: "PENDING", label: "Pending" },
                { value: "ACCEPTED", label: "Accepted" },
                { value: "IN_TRIP", label: "In Trip" },
                { value: "COMPLETED", label: "Completed" },
                { value: "CANCELLED", label: "Cancelled" },
                { value: "ADMIN_CANCELLED", label: "Admin Cancelled" },
              ]}
              required
            />

            <TextInput
              name="final_fare"
              label="Final Fare ($)"
              type="number"
              required
            />

            <FormDialogFooter
              isEdit={isEdit}
              isPending={isLoading}
              onClose={onClose}
              // eslint-disable-next-line @typescript-eslint/no-explicit-any
              onSubmit={(methods.handleSubmit as any)(onFormSubmit)}
              createText="Create Booking"
              createLoadingText="Creating..."
              editText="Save Changes"
              editLoadingText="Saving..."
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
