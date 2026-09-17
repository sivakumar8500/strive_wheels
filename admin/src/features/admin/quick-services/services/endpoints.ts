const QUICK_SERVICES_ENDPOINTS = {
  GET_ALL: "/admin/quick-services",
  CREATE: "/admin/quick-services",
  UPDATE: (id: number) => `/admin/quick-services/${id}`,
  DELETE: (id: number) => `/admin/quick-services/${id}`,
};

export default QUICK_SERVICES_ENDPOINTS;

