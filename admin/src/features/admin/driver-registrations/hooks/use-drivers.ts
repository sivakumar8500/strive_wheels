import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  getDriverRegistrations,
  getDriverRegistrationDetails,
  verifyDriverDocument,
  approveDriverRegistration,
} from "../services/api";

export const DRIVER_REGISTRATIONS_QUERY_KEY = ["driverRegistrations"];
export const DRIVER_REGISTRATION_DETAILS_QUERY_KEY = ["driverRegistrationDetails"];

export function useDriverApplications(status?: string, skip = 0, limit = 50) {
  return useQuery({
    queryKey: [...DRIVER_REGISTRATIONS_QUERY_KEY, status, skip, limit],
    queryFn: () => getDriverRegistrations(status, skip, limit),
  });
}

export function useDriverDetails(id: number, options?: { enabled?: boolean }) {
  return useQuery({
    queryKey: [...DRIVER_REGISTRATION_DETAILS_QUERY_KEY, id],
    queryFn: () => getDriverRegistrationDetails(id),
    enabled: options?.enabled ?? true,
  });
}

export function useVerifyDocument() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({
      registrationId,
      documentId,
      status,
      rejectionReason,
    }: {
      registrationId: number;
      documentId: number;
      status: "APPROVED" | "REJECTED";
      rejectionReason?: string;
    }) => verifyDriverDocument(registrationId, documentId, status, rejectionReason),
    onSuccess: (_, variables) => {
      // Invalidate the specific driver details to refetch updated document status
      queryClient.invalidateQueries({
        queryKey: [...DRIVER_REGISTRATION_DETAILS_QUERY_KEY, variables.registrationId],
      });
      // Optionally invalidate the list
      queryClient.invalidateQueries({
        queryKey: DRIVER_REGISTRATIONS_QUERY_KEY,
      });
    },
  });
}

export function useApproveApplication() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (registrationId: number) => approveDriverRegistration(registrationId),
    onSuccess: (_, registrationId) => {
      queryClient.invalidateQueries({
        queryKey: [...DRIVER_REGISTRATION_DETAILS_QUERY_KEY, registrationId],
      });
      queryClient.invalidateQueries({
        queryKey: DRIVER_REGISTRATIONS_QUERY_KEY,
      });
    },
  });
}
