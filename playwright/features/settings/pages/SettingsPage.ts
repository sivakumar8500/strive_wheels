import { Page, Locator, expect } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { ROUTES } from "@/data/constants/routes";

export class SettingsPage extends BasePage {
  readonly accountDetailsTab: Locator;
  readonly notificationsTab: Locator;

  constructor(page: Page) {
    super(page, ROUTES.SETTINGS_ACCOUNT_DETAILS);
    this.accountDetailsTab = page.locator("button:has-text('Account Details')").first();
    this.notificationsTab = page.locator("button:has-text('Notifications')").first();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.expectOnAccountDetails();
  }

  async openNotifications(): Promise<void> {
    await this.page.goto(ROUTES.SETTINGS_NOTIFICATIONS, { waitUntil: "domcontentloaded" });
    await this.expectOnNotifications();
  }

  async goToNotifications(): Promise<void> {
    const tab = this.page.getByRole("button", { name: "Notifications" });
    await tab.waitFor({ state: "visible" });
    await tab.click();
    await expect(this.page).toHaveURL(new RegExp(ROUTES.SETTINGS_NOTIFICATIONS), { timeout: 15000 });
    await this.expectOnNotifications();
  }

  async goToAccountDetails(): Promise<void> {
    const tab = this.page.getByRole("button", { name: "Account Details" });
    await tab.waitFor({ state: "visible" });
    await tab.click();
    await expect(this.page).toHaveURL(new RegExp(ROUTES.SETTINGS_ACCOUNT_DETAILS), { timeout: 15000 });
    await this.expectOnAccountDetails();
  }

  async expectOnAccountDetails(): Promise<void> {
    await expect(this.page.locator("h2:has-text('Account Details')").first()).toBeVisible({ timeout: 15000 });
  }

  async expectOnNotifications(): Promise<void> {
    await expect(this.page.locator("h2:has-text('Notification')").first()).toBeVisible({ timeout: 15000 });
  }
}
