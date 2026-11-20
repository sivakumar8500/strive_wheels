import { Page, Locator, expect } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { ROUTES } from "@/data/constants/routes";

export class DashboardPage extends BasePage {
  readonly statCards: Locator;
  readonly revenueChart: Locator;
  readonly bookingsChart: Locator;

  constructor(page: Page) {
    super(page, ROUTES.ADMIN_DASHBOARD);
    this.statCards = page.locator("div.grid > div.rounded-2xl, div:has(> p.text-slate-500)");
    this.revenueChart = page.locator("div:has-text('Revenue Overview'), div:has(svg.recharts-surface)").first();
    this.bookingsChart = page.locator("div:has-text('Booking Trends'), div:has(svg.recharts-surface)").last();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.waitForPageLoaded();
  }

  async expectStatCardVisible(label: string): Promise<void> {
    const card = this.page.locator(`div:has-text("${label}")`).first();
    await expect(card).toBeVisible();
  }

  async expectChartsVisible(): Promise<void> {
    await expect(this.revenueChart).toBeVisible();
  }
}
