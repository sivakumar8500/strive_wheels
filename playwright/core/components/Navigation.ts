import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class Navigation extends BaseComponent {
  readonly sidebar: Locator;
  readonly navbar: Locator;
  readonly logoutButton: Locator;

  constructor(page: Page) {
    super(page, page.locator("aside").first());
    this.sidebar = this.root;
    this.navbar = page.locator("header").first();
    this.logoutButton = this.sidebar.locator("button:has-text('Logout'), button:has(svg.lucide-log-out)").first();
  }

  getNavItem(itemName: string): Locator {
    return this.sidebar.locator(`a:has-text("${itemName}")`).first();
  }

  getNavItemByRoute(route: string): Locator {
    return this.sidebar.locator(`a[href='${route}']`).first();
  }

  async navigateTo(itemName: string): Promise<void> {
    const navItem = this.getNavItem(itemName);
    await expect(navItem).toBeVisible();
    await navItem.click();
  }

  async navigateToRoute(route: string): Promise<void> {
    const navItem = this.getNavItemByRoute(route);
    await expect(navItem).toBeVisible();
    await navItem.click();
    await this.page.waitForURL(new RegExp(route));
  }

  async expectActive(itemName: string): Promise<void> {
    const navItem = this.getNavItem(itemName);
    // Active item has primary background or active indicator
    await expect(navItem).toBeVisible();
  }

  async logout(): Promise<void> {
    await this.logoutButton.click();
    // In our app, clicking logout in sidebar opens LogoutDialog
    const confirmLogout = this.page.locator("button:has-text('Log Out'), button:has-text('Logout')").last();
    if (await confirmLogout.isVisible()) {
      await confirmLogout.click();
    }
  }
}
