import apiService from "@/services/apiService";
import type { Booking, BookingDetails, BookingsQuery, PaginatedBookings } from "../types";
import { mockBookings } from "../data/mockData";
import BOOKINGS_ENDPOINTS from "./bookingsEndpoints";

const USE_MOCK_DATA = false;

const currentMockData = [...mockBookings];

export async function getBookings(query?: BookingsQuery): Promise<PaginatedBookings> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        let filtered = [...currentMockData];

        if (query?.status) {
          filtered = filtered.filter((b) => b.status === query.status);
        }
        if (query?.service_mode) {
          filtered = filtered.filter((b) => b.service_mode === query.service_mode);
        }
        if (query?.booking_mode) {
          filtered = filtered.filter((b) => b.booking_mode === query.booking_mode);
        }
        if (query?.search) {
          const lowerSearch = query.search.toLowerCase();
          filtered = filtered.filter(
            (b) =>
              b.booking_code.toLowerCase().includes(lowerSearch) ||
              (b.customer?.user?.full_name?.toLowerCase().includes(lowerSearch) ?? false)
          );
        }

        const skip = query?.skip || 0;
        const limit = query?.limit || 10;
        const paginated = filtered.slice(skip, skip + limit);

        resolve({
          items: paginated,
          total: filtered.length,
          skip,
          limit,
        });
      }, 500);
    });
  }

  const queryParams = new URLSearchParams();
  if (query) {
    if (query.skip !== undefined) queryParams.append("skip", query.skip.toString());
    if (query.limit !== undefined) queryParams.append("limit", query.limit.toString());
    if (query.status) queryParams.append("status", query.status);
    if (query.service_mode) queryParams.append("service_mode", query.service_mode);
    if (query.booking_mode) queryParams.append("booking_mode", query.booking_mode);
    if (query.search) queryParams.append("search", query.search);
  }

  const queryString = queryParams.toString() ? `?${queryParams.toString()}` : "";
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: PaginatedBookings;
  }>(`${BOOKINGS_ENDPOINTS.LIST}${queryString}`, null);

  return response.data;
}

export async function getBookingDetails(id: number | string): Promise<BookingDetails> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const booking = currentMockData.find((b) => b.id.toString() === id.toString());
        if (!booking) return reject(new Error("Booking not found"));
        resolve(booking);
      }, 500);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: BookingDetails;
  }>(BOOKINGS_ENDPOINTS.DETAILS(id));

  return response.data;
}

export async function cancelBooking(
  id: number | string,
  cancellation_reason: string
): Promise<{ success: boolean; message: string }> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = currentMockData.findIndex((b) => b.id.toString() === id.toString());
        if (index === -1) return reject(new Error("Booking not found"));
        
        currentMockData[index] = {
          ...currentMockData[index],
          status: "ADMIN_CANCELLED",
          cancellation_reason,
        };
        
        resolve({
          success: true,
          message: "Booking cancelled successfully",
        });
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
  }>(BOOKINGS_ENDPOINTS.CANCEL(id), { cancellation_reason });

  return response;
}

export async function createBooking(data: Partial<Booking>): Promise<Booking> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => setTimeout(() => resolve(currentMockData[0]), 500));
  }
  return apiService.post<Booking>(BOOKINGS_ENDPOINTS.LIST, data);
}

export async function updateBooking(id: string, data: Partial<Booking>): Promise<Booking> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => setTimeout(() => resolve(currentMockData[0]), 500));
  }
  return apiService.patch<Booking>(BOOKINGS_ENDPOINTS.DETAILS(id), data);
}
