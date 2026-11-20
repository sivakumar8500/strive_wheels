const COMPANIES_ENDPOINTS = {
  GET_ALL: "/api/v1/companies",
  CREATE: "/api/v1/companies",
  UPDATE: (id: number) => `/api/v1/companies/${id}`,
  DELETE: (id: number) => `/api/v1/companies/${id}`,
};

export default COMPANIES_ENDPOINTS;
