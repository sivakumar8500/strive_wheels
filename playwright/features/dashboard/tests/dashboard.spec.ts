import { test, expect } from "@/fixtures/feature.fixture";

test.describe("Dashboard Feature", () => {
  test("should render executive dashboard overview @smoke", async ({ dashboardPage }) => {
    await dashboardPage.open();
    await expect(dashboardPage.pageTitle).toHaveText(/Dashboard Overview/i);
    await dashboardPage.expectStatCardVisible("Total Users");
    await dashboardPage.expectStatCardVisible("Active Trips");
    await dashboardPage.expectChartsVisible();
  });
});
