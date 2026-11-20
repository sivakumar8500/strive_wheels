"use client";

import { Booking } from "../types";
import { useCancelBooking } from "../hooks/useBookings";
import DeleteDialog from "@/components/shared/DeleteDialog";

interface BookingDeleteDialogProps {
  isOpen: boolean;
  booking: Booking | null;
  onClose: () => void;
  onSuccess?: () => void;
}

export function BookingDeleteDialog({
  isOpen,
  booking,
  onClose,
  onSuccess,
}: BookingDeleteDialogProps) {
  const deleteBookingMutation = useCancelBooking();

  const handleConfirm = async () => {
    if (!booking) return;

    try {
      await deleteBookingMutation.mutateAsync({ id: booking.id, reason: "Admin cancelled" });
      onClose();
      onSuccess?.();
    } catch {}
  };

  return (
    <DeleteDialog
      isOpen={isOpen}
      onClose={onClose}
      onConfirm={handleConfirm}
      entityLabel="booking"
      entityName={booking ? String(booking.id) : undefined}
      title="Delete Booking"
      message={`Are you sure you want to delete ${booking?.id}? This action cannot be undone.`}
    />
  );
}
