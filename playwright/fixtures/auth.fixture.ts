import { test as baseTest, Page } from "@playwright/test";
import { CREDENTIALS } from "@/data/constants/credentials";
import { getEnvironment } from "@/config/environments";
import { API_ROUTES } from "@/data/constants/routes";

export type AuthFixtures = {
  adminPage: Page;
  companyAdminPage: Page;
};

export const authTest = baseTest.extend<AuthFixtures>({
  adminPage: async ({ page, context }, use) => {
    const env = getEnvironment();

    // Route /auth/me to return profile data for settings/account details
    await page.route(new RegExp(API_ROUTES.AUTH_ME), async (route) => {
      await route.fulfill({
        status: 200,
        contentType: "application/json",
        body: JSON.stringify({
          success: true,
          data: {
            user: {
              id: 1,
              email: CREDENTIALS.ADMIN.email,
              first_name: "Admin",
              last_name: "User",
              phone_number: "+919876543210",
              gender: "MALE",
              designation: "Fleet Manager",
            },
          },
        }),
      });
    });

    // 1. Inject auth cookies for Edge Middleware using explicit URL
    await context.addCookies([
      {
        name: "auth_token",
        value: "mock_jwt_access_token_for_playwright_test",
        url: env.baseUrl,
      },
      {
        name: "user_role",
        value: "ADMIN",
        url: env.baseUrl,
      },
    ]);

    // 2. Inject localStorage state for Zustand useAuthStore
    await page.addInitScript((userData) => {
      window.localStorage.setItem(
        "auth-storage",
        JSON.stringify({
          state: {
            accessToken: "mock_jwt_access_token_for_playwright_test",
            refreshToken: "mock_jwt_refresh_token",
            user: {
              id: "1",
              email: userData.email,
              status: "active",
              user_type: "admin",
              phone_number: "+919876543210",
              mfa_enabled: false,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
            organizations: [],
            isLoading: false,
            isAuthenticated: true,
          },
          version: 0,
        })
      );
    }, { email: CREDENTIALS.ADMIN.email });

    await use(page);
  },

  companyAdminPage: async ({ page, context }, use) => {
    const env = getEnvironment();

    await context.addCookies([
      {
        name: "auth_token",
        value: "mock_jwt_company_token_for_playwright_test",
        url: env.baseUrl,
      },
      {
        name: "user_role",
        value: "COMPANY_ADMIN",
        url: env.baseUrl,
      },
    ]);

    await page.addInitScript((userData) => {
      window.localStorage.setItem(
        "auth-storage",
        JSON.stringify({
          state: {
            accessToken: "mock_jwt_company_token_for_playwright_test",
            refreshToken: "mock_jwt_refresh_token",
            user: {
              id: "2",
              email: userData.email,
              status: "active",
              user_type: "company_admin",
              phone_number: "+919876543211",
              mfa_enabled: false,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            },
            organizations: [],
            isLoading: false,
            isAuthenticated: true,
          },
          version: 0,
        })
      );
    }, { email: CREDENTIALS.COMPANY_ADMIN.email });

    await use(page);
  },
});
