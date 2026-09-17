import { AdminUser, UsersResponse } from "../types";

export const MOCK_ADMIN_USERS: AdminUser[] = [
  {
    id: 1,
    first_name: "Super",
    last_name: "Admin",
    email: "super@admin.com",
    role: "SUPER_ADMIN",
    is_active: true,
    created_at: "2023-01-01T00:00:00Z",
    last_login: "2023-10-25T14:30:00Z",
  },
  {
    id: 2,
    first_name: "Operations",
    last_name: "Manager",
    email: "ops@strivewheels.com",
    role: "ADMIN",
    is_active: true,
    created_at: "2023-05-15T09:00:00Z",
    last_login: "2023-10-26T08:15:00Z",
  },
  {
    id: 3,
    first_name: "Tech Corp",
    last_name: "Admin",
    email: "admin@techcorp.com",
    role: "COMPANY_ADMIN",
    is_active: true,
    created_at: "2023-08-10T10:20:00Z",
  },
  {
    id: 4,
    first_name: "Former",
    last_name: "Staff",
    email: "former@strivewheels.com",
    role: "ADMIN",
    is_active: false,
    created_at: "2023-02-20T11:45:00Z",
    last_login: "2023-06-30T17:00:00Z",
  },
];

export const getMockUsers = async (): Promise<UsersResponse> => ({
  data: MOCK_ADMIN_USERS,
  total: MOCK_ADMIN_USERS.length,
  page: 1,
  limit: 10,
});

export const getMockUserById = (id: string | number) =>
  MOCK_ADMIN_USERS.find((u) => u.id === Number(id));

export const createMockUser = (data: any) => {
  const user = {
    ...data,
    id: Date.now(),
    created_at: new Date().toISOString(),
  } as AdminUser;
  MOCK_ADMIN_USERS.push(user);
  return user;
};

export const updateMockUser = (id: string | number, data: any) => {
  const index = MOCK_ADMIN_USERS.findIndex((u) => u.id === Number(id));
  if (index > -1) {
    MOCK_ADMIN_USERS[index] = { ...MOCK_ADMIN_USERS[index], ...data };
    return MOCK_ADMIN_USERS[index];
  }
  return null;
};

export const deleteMockUser = (id: string | number) => {
  const index = MOCK_ADMIN_USERS.findIndex((u) => u.id === Number(id));
  if (index > -1) {
    MOCK_ADMIN_USERS.splice(index, 1);
    return true;
  }
  return false;
};
