import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getBookings, getBookingDetails, cancelBooking } from "../services/bookingsApi";
import type { BookingsQuery } from "../types";
import { toast } from "sonner";

export const BOOKINGS_QUERY_KEY = ["bookings"];

export function useBookings(query?: BookingsQuery) {
  return useQuery({
    queryKey: [...BOOKINGS_QUERY_KEY, query],
    queryFn: () => getBookings(query),
  });
}

export function useBookingDetails(id: number | string) {
  return useQuery({
    queryKey: [...BOOKINGS_QUERY_KEY, id],
    queryFn: () => getBookingDetails(id),
    enabled: !!id,
  });
}

export function useCancelBooking() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, reason }: { id: number | string; reason: string }) =>
      cancelBooking(id, reason),
    onSuccess: () => {
      toast.success("Booking cancelled successfully");
      queryClient.invalidateQueries({ queryKey: BOOKINGS_QUERY_KEY });
    },
    onError: (error: Error) => {
      toast.error(error.message || "Failed to cancel booking");
    },
  });
}
