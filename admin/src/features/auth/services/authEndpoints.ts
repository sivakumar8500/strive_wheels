import API from "@/config/common";

const BASE_API = API.AUTH;

const AUTH_ENDPOINTS = {
  LOGIN: `${BASE_API}/admin/login`,
  LOGOUT: `${BASE_API}/logout`,
  ME: `${BASE_API}/me`, // Currently not used by admin
  REFRESH_TOKEN: `${BASE_API}/refresh`,
  UPDATE_PROFILE: `${BASE_API}/profile`,
};

export default AUTH_ENDPOINTS;
