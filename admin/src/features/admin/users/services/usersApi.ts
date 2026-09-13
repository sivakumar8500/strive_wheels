import apiService from "@/services/apiService";
import USERS_ENDPOINTS from "./usersEndpoints";
import { User, UsersResponse, GetUsersParams } from "../types";
import {
  getMockUsers,
  getMockUserById,
  createMockUser,
  updateMockUser,
  deleteMockUser,
} from "../data/mockData";

// Toggle this to switch between mock and real API
const USE_MOCK_DATA = true;

export const usersApi = {
  getUsers: async (params?: GetUsersParams): Promise<UsersResponse> => {
    if (USE_MOCK_DATA) {
      // Simulate API delay
      await new Promise((resolve) => setTimeout(resolve, 500));
      return getMockUsers(params);
    }

    const queryParams = new URLSearchParams();
    if (params?.page) queryParams.append("page", params.page.toString());
    if (params?.limit) queryParams.append("limit", params.limit.toString());
    if (params?.search) queryParams.append("search", params.search);
    if (params?.status) queryParams.append("status", params.status);
    if (params?.role) queryParams.append("role", params.role);

    const url =
      queryParams.size > 0
        ? `${USERS_ENDPOINTS.GET_USERS}?${queryParams}`
        : USERS_ENDPOINTS.GET_USERS;

    return apiService.get<UsersResponse>(url);
  },

  getUserById: async (id: string): Promise<User> => {
    if (USE_MOCK_DATA) {
      await new Promise((resolve) => setTimeout(resolve, 300));
      const user = getMockUserById(id);
      if (!user) throw new Error("User not found");
      return user;
    }
    return apiService.get<User>(USERS_ENDPOINTS.GET_USER_BY_ID(id));
  },

  createUser: async (data: Omit<User, "id" | "createdAt">): Promise<User> => {
    if (USE_MOCK_DATA) {
      await new Promise((resolve) => setTimeout(resolve, 400));
      return createMockUser(data);
    }
    return apiService.post<User>(USERS_ENDPOINTS.CREATE_USER, data);
  },

  updateUser: async (id: string, data: Partial<User>): Promise<User> => {
    if (USE_MOCK_DATA) {
      await new Promise((resolve) => setTimeout(resolve, 400));
      const updated = updateMockUser(id, data);
      if (!updated) throw new Error("User not found");
      return updated;
    }
    return apiService.patch<User>(USERS_ENDPOINTS.UPDATE_USER(id), data);
  },

  deleteUser: async (id: string): Promise<void> => {
    if (USE_MOCK_DATA) {
      await new Promise((resolve) => setTimeout(resolve, 400));
      const deleted = deleteMockUser(id);
      if (!deleted) throw new Error("User not found");
      return;
    }
    return apiService.delete<void>(USERS_ENDPOINTS.DELETE_USER(id));
  },
};
