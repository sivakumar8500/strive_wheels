import { Page, Locator } from "@playwright/test";

export class WaitUtils {
  /**
   * Waits for network activity to settle without using arbitrary timeouts
   */
  static async waitForNetworkIdle(page: Page, timeout: number = 10000): Promise<void> {
    await page.waitForLoadState("networkidle", { timeout }).catch(() => {});
  }

  /**
   * Waits until an element contains specific text
   */
  static async waitForText(locator: Locator, text: string, timeout: number = 10000): Promise<void> {
    await locator.filter({ hasText: text }).waitFor({ state: "visible", timeout });
  }

  /**
   * Waits for a condition to return true with exponential backoff / polling
   */
  static async waitUntil(
    fn: () => Promise<boolean>,
    timeout: number = 10000,
    interval: number = 250
  ): Promise<void> {
    const startTime = Date.now();
    while (Date.now() - startTime < timeout) {
      if (await fn()) return;
      await new Promise((resolve) => setTimeout(resolve, interval));
    }
    throw new Error(`Condition not met within ${timeout}ms`);
  }
}
