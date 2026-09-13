import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  getVehicleTypes,
  createVehicleType,
  updateVehicleType,
  deleteVehicleType,
} from "../services/vehicleTypesApi";
import type { CreateVehicleTypeDto, UpdateVehicleTypeDto } from "../types";
import { toast } from "sonner";

export const VEHICLE_TYPES_QUERY_KEY = ["vehicleTypes"];

export function useVehicleTypes() {
  return useQuery({
    queryKey: VEHICLE_TYPES_QUERY_KEY,
    queryFn: getVehicleTypes,
  });
}

export function useCreateVehicleType() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateVehicleTypeDto) => createVehicleType(data),
    onSuccess: () => {
      toast.success("Vehicle type created successfully");
      queryClient.invalidateQueries({ queryKey: VEHICLE_TYPES_QUERY_KEY });
    },
    onError: (error: Error) => {
      toast.error(error.message || "Failed to create vehicle type");
    },
  });
}

export function useUpdateVehicleType() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: UpdateVehicleTypeDto }) =>
      updateVehicleType(id, data),
    onSuccess: () => {
      toast.success("Vehicle type updated successfully");
      queryClient.invalidateQueries({ queryKey: VEHICLE_TYPES_QUERY_KEY });
    },
    onError: (error: Error) => {
      toast.error(error.message || "Failed to update vehicle type");
    },
  });
}

export function useDeleteVehicleType() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => deleteVehicleType(id),
    onSuccess: () => {
      toast.success("Vehicle type deactivated successfully");
      queryClient.invalidateQueries({ queryKey: VEHICLE_TYPES_QUERY_KEY });
    },
    onError: (error: Error) => {
      toast.error(error.message || "Failed to deactivate vehicle type");
    },
  });
}
