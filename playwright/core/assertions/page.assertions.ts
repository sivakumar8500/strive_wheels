import { Page, expect } from "@playwright/test";

export class PageAssertions {
  static async expectUrl(page: Page, urlOrPattern: string | RegExp): Promise<void> {
    await expect(page).toHaveURL(urlOrPattern);
  }

  static async expectHeaderTitle(page: Page, expectedTitle: string | RegExp): Promise<void> {
    await expect(page.locator("h1").first()).toHaveText(expectedTitle);
  }

  static async expectElementVisible(page: Page, selectorOrText: string): Promise<void> {
    await expect(page.locator(selectorOrText).first()).toBeVisible();
  }
}
