const EMPLOYEES_ENDPOINTS = {
  GET_ALL: "/api/v1/companies/me/employees",
  CREATE: "/api/v1/companies/me/employees",
  UPDATE: (id: number | string) => `/api/v1/companies/me/employees/${id}`,
  DELETE: (id: number | string) => `/api/v1/companies/me/employees/${id}`,
};

export default EMPLOYEES_ENDPOINTS;
