import { Page, Locator, expect } from "@playwright/test";
import { Toast } from "@/core/components/Toast";
import { Navigation } from "@/core/components/Navigation";

export abstract class BasePage {
  readonly page: Page;
  readonly path: string;
  readonly toast: Toast;
  readonly navigation: Navigation;

  // Header locators from PageHeader.tsx
  readonly pageHeader: Locator;
  readonly pageTitle: Locator;
  readonly pageDescription: Locator;
  readonly headerActionButton: Locator;
  readonly loadingSpinner: Locator;

  constructor(page: Page, path: string = "") {
    this.page = page;
    this.path = path;
    this.toast = new Toast(page);
    this.navigation = new Navigation(page);

    this.pageHeader = page.locator("div.space-y-6 > div.flex").first();
    this.pageTitle = page.locator("h1");
    this.pageDescription = page.locator("h1 ~ p, .text-muted-foreground");
    this.headerActionButton = page.locator("button:has(svg.lucide-plus), button:has-text('Add'), button:has-text('Provision'), button:has-text('Create')").first();
    this.loadingSpinner = page.locator(".animate-spin");
  }

  async goto(subPath: string = ""): Promise<void> {
    const targetPath = subPath ? `${this.path}${subPath}` : this.path;
    await this.page.goto(targetPath, { waitUntil: "domcontentloaded" });
    await this.waitForPageLoaded();
  }

  async waitForPageLoaded(): Promise<void> {
    await this.page.waitForLoadState("domcontentloaded");
    // Wait for any global loaders to disappear if present
    if (await this.loadingSpinner.first().isVisible().catch(() => false)) {
      await this.loadingSpinner.first().waitFor({ state: "hidden", timeout: 15000 }).catch(() => {});
    }
  }

  async expectOnPage(): Promise<void> {
    await expect(this.page).toHaveURL(new RegExp(this.path));
  }

  async getTitleText(): Promise<string> {
    return (await this.pageTitle.first().textContent()) || "";
  }

  async clickHeaderAction(): Promise<void> {
    await this.headerActionButton.click();
  }

  async reload(): Promise<void> {
    await this.page.reload();
    await this.waitForPageLoaded();
  }
}
