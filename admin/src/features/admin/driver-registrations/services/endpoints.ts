const DRIVER_REGISTRATION_ENDPOINTS = {
  LIST: "/admin/driver-registrations",
  DETAILS: (id: number) => `/admin/driver-registrations/${id}`,
  VERIFY_DOC: (id: number) => `/admin/driver-registrations/${id}/verify-document`,
  APPROVE: (id: number) => `/admin/driver-registrations/${id}/approve`,
};

export default DRIVER_REGISTRATION_ENDPOINTS;
