import apiService from "@/services/apiService";
import type { VehicleType, CreateVehicleTypeDto, UpdateVehicleTypeDto } from "../types";
import VEHICLE_TYPES_ENDPOINTS from "./vehicleTypesEndpoints";

export async function getVehicleTypes(): Promise<VehicleType[]> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: VehicleType[];
  }>(VEHICLE_TYPES_ENDPOINTS.LIST);

  return response.data;
}

export async function createVehicleType(data: CreateVehicleTypeDto): Promise<VehicleType> {
  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: VehicleType;
  }>(VEHICLE_TYPES_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateVehicleType(id: number, data: UpdateVehicleTypeDto): Promise<VehicleType> {
  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: VehicleType;
  }>(VEHICLE_TYPES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteVehicleType(id: number): Promise<{ deleted: boolean }> {
  const response = await apiService.delete<{
    success: boolean;
    message: string;
    data: { vehicle_type_id: number; deleted: boolean };
  }>(VEHICLE_TYPES_ENDPOINTS.DELETE(id));

  return response.data;
}
