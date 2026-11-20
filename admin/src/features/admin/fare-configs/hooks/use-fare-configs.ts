import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getFareConfigs, bulkUpdateFareConfigs } from "../services/api";
import { BulkUpdateFareConfigRequest } from "../types";
import { toast } from "sonner";

export const FARE_CONFIGS_QUERY_KEY = ["fareConfigs"];

export function useFareConfigs() {
  return useQuery({
    queryKey: FARE_CONFIGS_QUERY_KEY,
    queryFn: getFareConfigs,
  });
}

export function useBulkUpdateFareConfigs() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: BulkUpdateFareConfigRequest) => bulkUpdateFareConfigs(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: FARE_CONFIGS_QUERY_KEY });
      toast.success("Fare configurations updated successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to update configurations");
    }
  });
}
