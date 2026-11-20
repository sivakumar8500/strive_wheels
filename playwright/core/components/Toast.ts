import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class Toast extends BaseComponent {
  constructor(page: Page) {
    super(page, page.locator("[data-sonner-toaster], [data-sonner-toast], [role='status']").first());
  }

  getToast(messagePattern?: string | RegExp): Locator {
    const toast = this.page.locator("[data-sonner-toast]");
    if (messagePattern) {
      return toast.filter({ hasText: messagePattern }).first();
    }
    return toast.first();
  }

  async expectSuccess(messagePattern?: string | RegExp): Promise<void> {
    const toast = messagePattern
      ? this.page.locator("[data-sonner-toast][data-type='success']").filter({ hasText: messagePattern }).first()
      : this.page.locator("[data-sonner-toast][data-type='success']").first();

    await expect(toast).toBeVisible();
  }

  async expectError(messagePattern?: string | RegExp): Promise<void> {
    const toast = messagePattern
      ? this.page.locator("[data-sonner-toast][data-type='error']").filter({ hasText: messagePattern }).first()
      : this.page.locator("[data-sonner-toast][data-type='error']").first();

    await expect(toast).toBeVisible();
  }

  async expectToast(messagePattern: string | RegExp): Promise<void> {
    const toast = this.getToast(messagePattern);
    await expect(toast).toBeVisible();
  }
}
