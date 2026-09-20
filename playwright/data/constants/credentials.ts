export const CREDENTIALS = {
  SUPER_ADMIN: {
    email: process.env.TEST_SUPER_ADMIN_EMAIL || "admin@strive.com",
    password: process.env.TEST_SUPER_ADMIN_PASSWORD || "SuperSecurePassword123!",
    role: "SUPER_ADMIN",
  },
  ADMIN: {
    email: process.env.TEST_ADMIN_EMAIL || "admin@strivewheels.com",
    password: process.env.TEST_ADMIN_PASSWORD || "SecureAdminPassword123!",
    role: "ADMIN",
  },
  COMPANY_ADMIN: {
    email: process.env.TEST_COMPANY_EMAIL || "company@strivewheels.com",
    password: process.env.TEST_COMPANY_PASSWORD || "CompanyAdmin@123",
    role: "COMPANY_ADMIN",
  },
};
