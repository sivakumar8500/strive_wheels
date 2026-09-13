import apiService from "@/services/apiService";
import type { VehicleType, CreateVehicleTypeDto, UpdateVehicleTypeDto } from "../types";
import VEHICLE_TYPES_ENDPOINTS from "./vehicleTypesEndpoints";
import { mockVehicleTypes } from "../data/mockData";

const USE_MOCK_DATA = true;

const currentMockData = [...mockVehicleTypes];

export async function getVehicleTypes(): Promise<VehicleType[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => setTimeout(() => resolve([...currentMockData]), 500));
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: VehicleType[];
  }>(VEHICLE_TYPES_ENDPOINTS.LIST);

  return response.data;
}

export async function createVehicleType(data: CreateVehicleTypeDto): Promise<VehicleType> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newVehicleType: VehicleType = {
          ...data,
          id: currentMockData.length + 1,
          created_at: new Date().toISOString(),
        };
        currentMockData.push(newVehicleType);
        resolve(newVehicleType);
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: VehicleType;
  }>(VEHICLE_TYPES_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateVehicleType(id: number, data: UpdateVehicleTypeDto): Promise<VehicleType> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = currentMockData.findIndex((v) => v.id === id);
        if (index === -1) return reject(new Error("Vehicle type not found"));
        currentMockData[index] = { ...currentMockData[index], ...data };
        resolve(currentMockData[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: VehicleType;
  }>(VEHICLE_TYPES_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteVehicleType(id: number): Promise<{ deleted: boolean }> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const index = currentMockData.findIndex((v) => v.id === id);
        if (index !== -1) {
          currentMockData[index].is_active = false; // Soft delete / deactivate
        }
        resolve({ deleted: true });
      }, 500);
    });
  }

  const response = await apiService.delete<{
    success: boolean;
    message: string;
    data: { vehicle_type_id: number; deleted: boolean };
  }>(VEHICLE_TYPES_ENDPOINTS.DELETE(id));

  return response.data;
}
