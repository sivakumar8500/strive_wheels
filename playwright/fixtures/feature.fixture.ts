import { authTest } from "@/fixtures/auth.fixture";
import { LoginPage } from "@/features/auth/pages/LoginPage";
import { UsersPage } from "@/features/users/pages/UsersPage";
import { BookingsPage } from "@/features/bookings/pages/BookingsPage";
import { DashboardPage } from "@/features/dashboard/pages/DashboardPage";
import { CouponsPage } from "@/features/coupons/pages/CouponsPage";

export type FeatureFixtures = {
  loginPage: LoginPage;
  usersPage: UsersPage;
  bookingsPage: BookingsPage;
  dashboardPage: DashboardPage;
  couponsPage: CouponsPage;
};

// Test with pre-authenticated admin page context
export const test = authTest.extend<FeatureFixtures>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },

  usersPage: async ({ adminPage }, use) => {
    await use(new UsersPage(adminPage));
  },

  bookingsPage: async ({ adminPage }, use) => {
    await use(new BookingsPage(adminPage));
  },

  dashboardPage: async ({ adminPage }, use) => {
    await use(new DashboardPage(adminPage));
  },

  couponsPage: async ({ adminPage }, use) => {
    await use(new CouponsPage(adminPage));
  },
});

export { expect } from "@playwright/test";
