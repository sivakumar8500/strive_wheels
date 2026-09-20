export interface EnvironmentConfig {
  name: string;
  baseUrl: string;
  apiUrl: string;
  defaultTimeout: number;
  expectTimeout: number;
  navigationTimeout: number;
}

const environments: Record<string, EnvironmentConfig> = {
  local: {
    name: "local",
    baseUrl: process.env.BASE_URL || "http://localhost:3000",
    apiUrl: process.env.API_URL || "http://15.252.129.37:8200/api/v1",
    defaultTimeout: 30000,
    expectTimeout: 10000,
    navigationTimeout: 30000,
  },
  staging: {
    name: "staging",
    baseUrl: process.env.STAGING_BASE_URL || "https://staging-admin.strivewheels.com",
    apiUrl: process.env.STAGING_API_URL || "http://15.252.129.37:8200/api/v1",
    defaultTimeout: 45000,
    expectTimeout: 15000,
    navigationTimeout: 45000,
  },
  ci: {
    name: "ci",
    baseUrl: process.env.CI_BASE_URL || "http://localhost:3000",
    apiUrl: process.env.CI_API_URL || "http://15.252.129.37:8200/api/v1",
    defaultTimeout: 60000,
    expectTimeout: 15000,
    navigationTimeout: 60000,
  },
};

export const getEnvironment = (): EnvironmentConfig => {
  const envName = (process.env.TEST_ENV || "local").toLowerCase();
  return environments[envName] || environments.local;
};
