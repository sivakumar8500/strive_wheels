import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class DatePicker extends BaseComponent {
  readonly trigger: Locator;

  constructor(page: Page, triggerLocator: Locator) {
    super(page, triggerLocator);
    this.trigger = this.root;
  }

  static fromId(page: Page, id: string): DatePicker {
    return new DatePicker(page, page.locator(`button#${id}`).first());
  }

  async open(): Promise<void> {
    await this.trigger.click();
  }

  async selectDay(dayNumber: number): Promise<void> {
    await this.open();
    // In react-day-picker, day buttons are inside [role="grid"]
    const dayButton = this.page
      .locator("button[name='day'], td button")
      .filter({ hasText: new RegExp(`^${dayNumber}$`) })
      .first();

    await expect(dayButton).toBeVisible();
    await dayButton.click();
  }

  async getValue(): Promise<string> {
    return (await this.trigger.textContent()) || "";
  }
}
