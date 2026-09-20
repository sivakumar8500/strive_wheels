import { Page, Locator, expect } from "@playwright/test";
import { BaseModal } from "@/core/base/BaseModal";

export class ConfirmDialog extends BaseModal {
  readonly confirmButton: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    super(page, rootLocator);
    this.confirmButton = this.root.locator("button:has-text('Confirm'), button:has-text('Yes'), button:has-text('OK')").first();
  }

  async confirm(): Promise<void> {
    await this.confirmButton.click();
  }
}

export class DeleteDialog extends BaseModal {
  readonly deleteButton: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    super(page, rootLocator);
    this.deleteButton = this.root.locator("button:has-text('Delete'), button.bg-red-500, button.bg-destructive").first();
  }

  async confirmDelete(): Promise<void> {
    await expect(this.deleteButton).toBeVisible();
    await this.deleteButton.click();
    await this.expectClosed();
  }
}
