const POPULAR_LOCATIONS_ENDPOINTS = {
  GET_ALL: "/admin/popular-locations",
  CREATE: "/admin/popular-locations",
  UPDATE: (id: number) => `/admin/popular-locations/${id}`,
  DELETE: (id: number) => `/admin/popular-locations/${id}`,
};

export default POPULAR_LOCATIONS_ENDPOINTS;
