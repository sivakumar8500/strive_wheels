export interface AdminUser {
  id: number;
  first_name: string;
  last_name: string;
  email: string;
  role: "SUPER_ADMIN" | "ADMIN" | "COMPANY_ADMIN";
  is_active: boolean;
  created_at: string;
  last_login?: string;
}

export type CreateAdminUserRequest = Omit<AdminUser, "id" | "created_at" | "last_login">;
export type UpdateAdminUserRequest = Partial<CreateAdminUserRequest>;

export type User = AdminUser;
export interface GetUsersParams {
  page?: number;
  limit?: number;
  search?: string;
  status?: string;
  role?: string;
}
export interface UsersResponse {
  data: User[];
  total: number;
  page: number;
  limit: number;
}
