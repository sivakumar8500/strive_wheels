import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { createBooking, updateBooking } from "../services/bookingsApi";
type BookingType = any;

interface UseBookingFormOptions {
  onSuccess?: () => void;
}

export function useBookingForm(options: UseBookingFormOptions = {}) {
  const queryClient = useQueryClient();
  const [isOpen, setIsOpen] = useState(false);
  const [selectedBooking, setSelectedBooking] = useState<BookingType | null>(null);

  const openCreateDialog = () => {
    setSelectedBooking(null);
    setIsOpen(true);
  };

  const openEditDialog = (booking: BookingType) => {
    setSelectedBooking(booking);
    setIsOpen(true);
  };

  const closeDialog = () => {
    setIsOpen(false);
    setTimeout(() => setSelectedBooking(null), 200);
  };

  const createMutation = useMutation({
    mutationFn: createBooking,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["admin-bookings"] });
      toast.success("Booking created successfully");
      closeDialog();
      options.onSuccess?.();
    },
     
    onError: (error: any) => {
      toast.error(error.message || "Failed to create booking");
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: any }) =>
      updateBooking(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["admin-bookings"] });
      toast.success("Booking updated successfully");
      closeDialog();
      options.onSuccess?.();
    },
     
    onError: (error: any) => {
      toast.error(error.message || "Failed to update booking");
    },
  });

  const handleSubmit = async (data: any) => {
    if (selectedBooking) {
      await updateMutation.mutateAsync({ id: selectedBooking.id, data });
    } else {
      await createMutation.mutateAsync(data);
    }
  };

  return {
    isOpen,
    selectedBooking,
    openCreateDialog,
    openEditDialog,
    closeDialog,
    handleSubmit,
    isLoading: createMutation.isPending || updateMutation.isPending,
  };
}
