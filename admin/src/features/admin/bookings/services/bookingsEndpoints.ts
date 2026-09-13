const BOOKINGS_ENDPOINTS = {
  LIST: "/admin/bookings",
  DETAILS: (id: number | string) => `/admin/bookings/${id}`,
  CANCEL: (id: number | string) => `/admin/bookings/${id}/cancel`,
};

export default BOOKINGS_ENDPOINTS;
