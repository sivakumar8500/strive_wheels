const COUPONS_ENDPOINTS = {
  GET_ALL: "/admin/coupons",
  CREATE: "/admin/coupons",
  UPDATE: (id: number) => `/admin/coupons/${id}`,
  DELETE: (id: number) => `/admin/coupons/${id}`,
};

export default COUPONS_ENDPOINTS;
