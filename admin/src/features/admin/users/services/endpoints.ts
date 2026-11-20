const ADMIN_USERS_ENDPOINTS = {
  GET_ALL: "/api/v1/admin/users",
  CREATE: "/api/v1/admin/users",
  UPDATE: (id: number) => `/api/v1/admin/users/${id}`,
  DELETE: (id: number) => `/api/v1/admin/users/${id}`,
};

export default ADMIN_USERS_ENDPOINTS;
