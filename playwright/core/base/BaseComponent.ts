import { Page, Locator } from "@playwright/test";

export abstract class BaseComponent {
  protected readonly page: Page;
  protected readonly root: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    this.page = page;
    this.root = rootLocator || page.locator("body");
  }

  get locator(): Locator {
    return this.root;
  }

  async isVisible(): Promise<boolean> {
    return this.root.isVisible();
  }

  async waitForVisible(): Promise<void> {
    await this.root.waitFor({ state: "visible" });
  }

  async waitForHidden(): Promise<void> {
    await this.root.waitFor({ state: "hidden" });
  }
}
