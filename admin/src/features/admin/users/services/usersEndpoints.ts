const USERS_ENDPOINTS = {
  GET_USERS: "/v1/users",
  GET_USER_BY_ID: (id: string) => `/v1/users/${id}`,
  CREATE_USER: "/v1/users",
  UPDATE_USER: (id: string) => `/v1/users/${id}`,
  DELETE_USER: (id: string) => `/v1/users/${id}`,
};

export default USERS_ENDPOINTS;
