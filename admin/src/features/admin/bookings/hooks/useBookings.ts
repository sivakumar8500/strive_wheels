import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getBookings, cancelBooking } from "../services/bookingsApi";
import { BookingsQuery } from "../types";
import { toast } from "sonner";

export function useBookings(params: BookingsQuery = {}) {
  return useQuery({
    queryKey: ["admin-bookings", params.skip, params.limit],
    queryFn: () => getBookings(params),
  });
}

export function useCancelBooking() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, reason }: { id: string | number; reason: string }) =>
      cancelBooking(id, reason),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["admin-bookings"] });
      toast.success("Booking cancelled successfully");
    },
    onError: (error: Error) => {
      toast.error(error.message || "Failed to cancel booking");
    },
  });
}

/** @deprecated use useCancelBooking */
export function useDeleteBooking() {
  return useCancelBooking();
}
