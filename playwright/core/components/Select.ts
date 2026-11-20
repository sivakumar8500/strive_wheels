import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class Select extends BaseComponent {
  readonly trigger: Locator;

  constructor(page: Page, triggerLocator: Locator) {
    super(page, triggerLocator);
    this.trigger = this.root;
  }

  static fromId(page: Page, id: string): Select {
    return new Select(page, page.locator(`button#${id}, [id='${id}']`).first());
  }

  static fromLabel(page: Page, label: string): Select {
    return new Select(
      page,
      page.locator(`div:has(label:has-text('${label}')) button`).first()
    );
  }

  async open(): Promise<void> {
    await this.trigger.click();
  }

  async selectOption(optionText: string): Promise<void> {
    await this.open();
    // Matches role="menuitem" (DropdownMenu) or role="option" (Select)
    const option = this.page
      .locator("[role='menuitem'], [role='option']")
      .filter({ hasText: optionText })
      .first();

    await expect(option).toBeVisible();
    await option.click();
  }

  async getSelectedValue(): Promise<string> {
    return (await this.trigger.textContent()) || "";
  }

  async expectSelectedValue(expectedText: string): Promise<void> {
    await expect(this.trigger).toContainText(expectedText);
  }
}
