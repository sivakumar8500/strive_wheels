const VEHICLE_TYPES_ENDPOINTS = {
  LIST: "/admin/vehicle-types",
  CREATE: "/admin/vehicle-types",
  UPDATE: (id: number) => `/admin/vehicle-types/${id}`,
  DELETE: (id: number) => `/admin/vehicle-types/${id}`,
};

export default VEHICLE_TYPES_ENDPOINTS;
