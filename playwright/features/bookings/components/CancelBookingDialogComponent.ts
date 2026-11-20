import { Page, Locator } from "@playwright/test";
import { BaseModal } from "@/core/base/BaseModal";
import { Form } from "@/core/components/Form";

export class CancelBookingDialogComponent extends BaseModal {
  readonly form: Form;
  readonly reasonInput: Locator;
  readonly confirmButton: Locator;

  constructor(page: Page) {
    super(page);
    this.form = new Form(page, this.root.locator("form").first());
    this.reasonInput = this.root.locator("textarea#cancellation_reason, textarea[name='cancellation_reason']").first();
    this.confirmButton = this.root.locator("button:has-text('Confirm Cancellation')").first();
  }

  async cancelWithReason(reason: string): Promise<void> {
    await this.reasonInput.fill(reason);
    await this.confirmButton.click();
  }
}
