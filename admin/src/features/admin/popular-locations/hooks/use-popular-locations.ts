import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  getPopularLocations,
  createPopularLocation,
  updatePopularLocation,
  deletePopularLocation,
} from "../services/api";
import { CreatePopularLocationRequest, UpdatePopularLocationRequest } from "../types";
import { toast } from "sonner";

export const POPULAR_LOCATIONS_QUERY_KEY = ["popularLocations"];

export function usePopularLocations() {
  return useQuery({
    queryKey: POPULAR_LOCATIONS_QUERY_KEY,
    queryFn: getPopularLocations,
  });
}

export function useCreatePopularLocation() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreatePopularLocationRequest) => createPopularLocation(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: POPULAR_LOCATIONS_QUERY_KEY });
      toast.success("Location created successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to create location.");
    },
  });
}

export function useUpdatePopularLocation() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (variables: { id: number; data: UpdatePopularLocationRequest }) =>
      updatePopularLocation(variables),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: POPULAR_LOCATIONS_QUERY_KEY });
      toast.success("Location updated successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to update location.");
    },
  });
}

export function useDeletePopularLocation() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => deletePopularLocation(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: POPULAR_LOCATIONS_QUERY_KEY });
      toast.success("Location deleted successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to delete location.");
    },
  });
}
