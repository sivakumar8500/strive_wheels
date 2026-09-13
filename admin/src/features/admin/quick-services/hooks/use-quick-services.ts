import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  getQuickServices,
  createQuickService,
  updateQuickService,
  deleteQuickService,
  reorderQuickServices,
} from "../services/api";
import { CreateQuickServiceRequest, UpdateQuickServiceRequest, ReorderQuickServicesRequest } from "../types";
import { toast } from "sonner";

export const QUICK_SERVICES_QUERY_KEY = ["quickServices"];

export function useQuickServices() {
  return useQuery({
    queryKey: QUICK_SERVICES_QUERY_KEY,
    queryFn: getQuickServices,
  });
}

export function useCreateQuickService() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateQuickServiceRequest) => createQuickService(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUICK_SERVICES_QUERY_KEY });
      toast.success("Quick service created successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to create quick service.");
    },
  });
}

export function useUpdateQuickService() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (variables: { id: number; data: UpdateQuickServiceRequest }) =>
      updateQuickService(variables),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUICK_SERVICES_QUERY_KEY });
      toast.success("Quick service updated successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to update quick service.");
    },
  });
}

export function useDeleteQuickService() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => deleteQuickService(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUICK_SERVICES_QUERY_KEY });
      toast.success("Quick service deleted successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to delete quick service.");
    },
  });
}

export function useReorderQuickServices() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: ReorderQuickServicesRequest) => reorderQuickServices(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUICK_SERVICES_QUERY_KEY });
      toast.success("Quick services reordered successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to reorder quick services.");
    },
  });
}
