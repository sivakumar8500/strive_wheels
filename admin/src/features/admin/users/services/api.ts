import apiService from "@/services/apiService";
import ADMIN_USERS_ENDPOINTS from "./endpoints";
import {
  AdminUser,
  CreateAdminUserRequest,
  UpdateAdminUserRequest,
} from "../types";
import { MOCK_ADMIN_USERS } from "../data/mockData";

const USE_MOCK_DATA = true;

const localMockData: AdminUser[] = JSON.parse(JSON.stringify(MOCK_ADMIN_USERS));

export async function getAdminUsers(): Promise<AdminUser[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([...localMockData]);
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: AdminUser[];
  }>(ADMIN_USERS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createAdminUser(data: CreateAdminUserRequest): Promise<AdminUser> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newId = Math.max(0, ...localMockData.map((u) => u.id)) + 1;
        const newItem: AdminUser = {
          ...data,
          id: newId,
          is_active: true,
          created_at: new Date().toISOString(),
        };
        localMockData.push(newItem);
        resolve(newItem);
      }, 500);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: AdminUser;
  }>(ADMIN_USERS_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateAdminUser({
  id,
  data,
}: {
  id: number;
  data: UpdateAdminUserRequest;
}): Promise<AdminUser> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((u) => u.id === id);
        if (index === -1) return reject(new Error("User not found"));
        
        localMockData[index] = { ...localMockData[index], ...data };
        resolve(localMockData[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: AdminUser;
  }>(ADMIN_USERS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteAdminUser(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((u) => u.id === id);
        if (index === -1) return reject(new Error("User not found"));
        
        localMockData.splice(index, 1);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(ADMIN_USERS_ENDPOINTS.DELETE(id));
}
