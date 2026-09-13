const BASE_API = "/v1"; // or just /v1 since API.LOB is /v1

const UPLOAD_ENDPOINTS = {
  PRESIGNED_URL: (orgId: string) =>
    `${BASE_API}/uploads/${orgId}/presigned-url`,
  PERMANENT_URL: (orgId: string, safeS3Key: string) =>
    `${BASE_API}/uploads/${orgId}/${safeS3Key}/permanent-url`,
  DELETE_FILE: (orgId: string, safeS3Key: string) =>
    `${BASE_API}/uploads/${orgId}/${safeS3Key}`,
};

export default UPLOAD_ENDPOINTS;
