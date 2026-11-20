import { Page, Locator, expect } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { Form } from "@/core/components/Form";
import { ROUTES } from "@/data/constants/routes";

export class LoginPage extends BasePage {
  readonly form: Form;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;
  readonly rememberMeCheckbox: Locator;

  constructor(page: Page) {
    super(page, ROUTES.LOGIN);
    this.form = new Form(page);
    this.emailInput = page.locator("input#email, input[name='email']").first();
    this.passwordInput = page.locator("input#password, input[name='password']").first();
    this.submitButton = page.locator("button[type='submit']").first();
    this.errorMessage = page.locator(".bg-red-50, .text-red-600").first();
    this.rememberMeCheckbox = page.locator("button#remember, button[role='checkbox']").first();
  }

  async waitForHydration(): Promise<void> {
    await this.page.waitForLoadState("networkidle");
    await this.emailInput.waitFor({ state: "visible" });
    await this.submitButton.waitFor({ state: "visible" });
  }

  async login(email: string, password: string): Promise<void> {
    await this.waitForHydration();

    await this.emailInput.click();
    await this.emailInput.fill(email);
    await this.emailInput.press("Tab");

    await this.passwordInput.click();
    await this.passwordInput.fill(password);
    await this.passwordInput.press("Tab");

    if ((await this.emailInput.inputValue()) !== email) {
      await this.emailInput.click();
      await this.emailInput.fill(email);
      await this.emailInput.press("Tab");
    }
    if ((await this.passwordInput.inputValue()) !== password) {
      await this.passwordInput.click();
      await this.passwordInput.fill(password);
      await this.passwordInput.press("Tab");
    }

    await expect(this.submitButton).toBeEnabled({ timeout: 10000 });
    await this.submitButton.click();
  }

  async expectErrorMessage(messagePattern?: string | RegExp): Promise<void> {
    await expect(this.errorMessage).toBeVisible();
    if (messagePattern) {
      await expect(this.errorMessage).toHaveText(messagePattern);
    }
  }

  async expectOnLoginPage(): Promise<void> {
    await expect(this.page).toHaveURL(new RegExp(ROUTES.LOGIN));
    await expect(this.submitButton).toBeVisible();
  }
}
