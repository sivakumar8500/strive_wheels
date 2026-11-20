import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getTrafficFares, bulkUpdateTrafficFares } from "../services/api";
import { BulkUpdateTrafficRequest } from "../types";
import { toast } from "sonner";

export const TRAFFIC_FARES_QUERY_KEY = ["trafficFares"];

export function useTrafficFares() {
  return useQuery({
    queryKey: TRAFFIC_FARES_QUERY_KEY,
    queryFn: getTrafficFares,
  });
}

export function useBulkUpdateTrafficFares() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: BulkUpdateTrafficRequest) => bulkUpdateTrafficFares(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: TRAFFIC_FARES_QUERY_KEY });
      toast.success("Traffic configurations updated successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to update configurations");
    }
  });
}
