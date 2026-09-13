const COMPANY_RIDERS_ENDPOINTS = {
  GET_ALL: "/api/v1/companies/me/riders",
  ASSIGN: "/api/v1/companies/me/riders",
  UPDATE: (id: number | string) => `/api/v1/companies/me/riders/${id}`,
  DELETE: (id: number | string) => `/api/v1/companies/me/riders/${id}`,
};

export default COMPANY_RIDERS_ENDPOINTS;
