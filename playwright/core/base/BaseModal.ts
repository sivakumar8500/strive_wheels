import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export abstract class BaseModal extends BaseComponent {
  readonly title: Locator;
  readonly description: Locator;
  readonly closeButton: Locator;
  readonly submitButton: Locator;
  readonly cancelButton: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    // Radix Dialog renders in role="dialog" (exclude Next.js dev error overlays)
    const dialogRoot = rootLocator || page.locator("[role='dialog']:not([data-nextjs-dialog])");
    super(page, dialogRoot);

    this.title = this.root.locator("h2, h3, [data-slot='dialog-title']").first();
    this.description = this.root.locator("p.text-muted-foreground, p.text-slate-500").first();
    this.closeButton = this.root.locator("button:has(svg.lucide-x), button:has-text('Close')").first();
    this.submitButton = this.root.locator("button[type='submit'], button:has-text('Create'), button:has-text('Save'), button:has-text('Provision'), button:has-text('Submit')").first();
    this.cancelButton = this.root.locator("button:has-text('Cancel')").first();
  }

  async expectOpen(): Promise<void> {
    await expect(this.root).toBeVisible();
  }

  async expectClosed(): Promise<void> {
    await expect(this.root).toBeHidden();
  }

  async getTitleText(): Promise<string> {
    return (await this.title.textContent()) || "";
  }

  async submit(): Promise<void> {
    await this.submitButton.click();
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click();
  }

  async close(): Promise<void> {
    if (await this.closeButton.isVisible()) {
      await this.closeButton.click();
    } else {
      await this.cancel();
    }
  }
}
