const SETTINGS_ENDPOINTS = {
  PROFILE: (orgId: string, memberId?: string) =>
    `/v1/annotators/orgs/${orgId}/members/${memberId}`,
  PROFILEUPDATE: (orgId: string) =>
    `/v1/annotators/orgs/${orgId}/annotator/profile`,
};

export default SETTINGS_ENDPOINTS;
