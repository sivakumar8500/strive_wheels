import { test, expect } from "@playwright/test";
import { LoginPage } from "@/features/auth/pages/LoginPage";
import { CREDENTIALS } from "@/data/constants/credentials";
import { ROUTES, API_ROUTES } from "@/data/constants/routes";

test.describe("Authentication Feature", () => {
  test.beforeEach(async ({ context, page }) => {
    await context.clearCookies();
    await page.addInitScript(() => {
      window.localStorage.clear();
      window.sessionStorage.clear();
    });
  });

  test("should render the login form correctly @smoke", async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await loginPage.expectOnLoginPage();
    await expect(loginPage.emailInput).toBeVisible();
    await expect(loginPage.passwordInput).toBeVisible();
    await expect(loginPage.submitButton).toBeVisible();
  });

  test("should authenticate admin user and redirect to admin portal @smoke", async ({ page }) => {
    await page.route(new RegExp(API_ROUTES.AUTH_ADMIN_LOGIN), async (route) => {
      await route.fulfill({
        status: 200,
        contentType: "application/json",
        body: JSON.stringify({
          success: true,
          data: {
            access_token: "mock_admin_token",
            refresh_token: "mock_refresh_token",
            token_type: "Bearer",
            user_id: 1,
            roles: ["ADMIN"],
            phone: "+919876543210",
          },
        }),
      });
    });

    const loginPage = new LoginPage(page);
    await loginPage.goto();

    await loginPage.login(CREDENTIALS.ADMIN.email, CREDENTIALS.ADMIN.password);
    await expect(page).toHaveURL(new RegExp(ROUTES.ADMIN_DASHBOARD));
  });

  test("should authenticate company admin user and redirect to company portal @smoke", async ({ page }) => {
    await page.route(new RegExp(API_ROUTES.AUTH_ADMIN_LOGIN), async (route) => {
      await route.fulfill({
        status: 200,
        contentType: "application/json",
        body: JSON.stringify({
          success: true,
          data: {
            access_token: "mock_company_token",
            refresh_token: "mock_refresh_token",
            token_type: "Bearer",
            user_id: 2,
            roles: ["COMPANY_ADMIN"],
            phone: "+919876543211",
          },
        }),
      });
    });

    const loginPage = new LoginPage(page);
    await loginPage.goto();

    await loginPage.login(CREDENTIALS.COMPANY_ADMIN.email, CREDENTIALS.COMPANY_ADMIN.password);
    await expect(page).toHaveURL(new RegExp(ROUTES.COMPANY_DASHBOARD));
  });

  test("should show error on invalid credentials @regression", async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();

    await page.route(new RegExp(API_ROUTES.AUTH_ADMIN_LOGIN), async (route) => {
      await route.fulfill({
        status: 401,
        contentType: "application/json",
        body: JSON.stringify({
          detail: "Invalid credentials or unauthorized access",
        }),
      });
    });

    await loginPage.login("wrong@example.com", "WrongPassword123!");
    await loginPage.expectErrorMessage(/Invalid credentials/);
  });

  test("should keep submit button disabled when fields are empty @regression", async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await expect(loginPage.submitButton).toBeDisabled();
  });
});
