import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class Form extends BaseComponent {
  constructor(page: Page, rootLocator?: Locator) {
    super(page, rootLocator || page.locator("form").first());
  }

  getInput(nameOrLabel: string): Locator {
    // Try by ID or Name first, then fallback to label/placeholder strictly within this form
    return this.root.locator(
      `input#${nameOrLabel}, input[name='${nameOrLabel}'], textarea#${nameOrLabel}, textarea[name='${nameOrLabel}']`
    ).or(
      this.root.getByLabel(nameOrLabel, { exact: false })
    ).or(
      this.root.getByPlaceholder(nameOrLabel, { exact: false })
    ).first();
  }

  async fillInput(nameOrLabel: string, value: string): Promise<void> {
    const input = this.getInput(nameOrLabel);
    await input.waitFor({ state: "visible" });
    await input.fill(value);
  }

  async clearInput(nameOrLabel: string): Promise<void> {
    const input = this.getInput(nameOrLabel);
    await input.fill("");
  }

  async getInputValue(nameOrLabel: string): Promise<string> {
    const input = this.getInput(nameOrLabel);
    return await input.inputValue();
  }

  async toggleSwitch(nameOrLabel: string, targetState?: boolean): Promise<void> {
    const switchControl = this.root.locator(
      `button[role='switch']#${nameOrLabel}, button[role='switch'][name='${nameOrLabel}']`
    ).or(
      this.root.locator(`div:has-text('${nameOrLabel}') button[role='switch']`)
    ).first();

    await switchControl.waitFor({ state: "visible" });
    const isChecked = (await switchControl.getAttribute("data-state")) === "checked";

    if (targetState === undefined || targetState !== isChecked) {
      await switchControl.click();
    }
  }

  async setCheckbox(nameOrLabel: string, checked: boolean = true): Promise<void> {
    const checkbox = this.root.locator(
      `button[role='checkbox']#${nameOrLabel}, button[role='checkbox'][name='${nameOrLabel}']`
    ).or(
      this.root.getByLabel(nameOrLabel)
    ).first();

    const currentState = (await checkbox.getAttribute("data-state")) === "checked";
    if (currentState !== checked) {
      await checkbox.click();
    }
  }

  async expectFieldError(nameOrLabel: string, expectedMessage?: string | RegExp): Promise<void> {
    // In our inputs, field errors are rendered in <p className="text-destructive ...">
    const fieldContainer = this.root.locator(`div:has(#${nameOrLabel})`).first();
    const errorMsg = fieldContainer.locator(".text-destructive").first();
    await expect(errorMsg).toBeVisible();

    if (expectedMessage) {
      await expect(errorMsg).toHaveText(expectedMessage);
    }
  }

  async expectValidationError(message: string | RegExp): Promise<void> {
    await expect(this.root.locator(".text-destructive").filter({ hasText: message }).first()).toBeVisible();
  }

  async submit(): Promise<void> {
    const submitBtn = this.root.locator("button[type='submit']").first();
    await submitBtn.click();
  }
}
