import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getWeatherFares, bulkUpdateWeatherFares } from "../services/api";
import { BulkUpdateWeatherRequest } from "../types";
import { toast } from "sonner";

export const WEATHER_FARES_QUERY_KEY = ["weatherFares"];

export function useWeatherFares() {
  return useQuery({
    queryKey: WEATHER_FARES_QUERY_KEY,
    queryFn: getWeatherFares,
  });
}

export function useBulkUpdateWeatherFares() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: BulkUpdateWeatherRequest) => bulkUpdateWeatherFares(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: WEATHER_FARES_QUERY_KEY });
      toast.success("Weather configurations updated successfully.");
    },
    onError: (error: any) => {
      toast.error(error?.response?.data?.message || "Failed to update configurations");
    }
  });
}
