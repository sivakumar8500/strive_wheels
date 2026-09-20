import { Page, Locator } from "@playwright/test";
import { BaseModal } from "@/core/base/BaseModal";
import { Form } from "@/core/components/Form";
import { Select } from "@/core/components/Select";
import { CouponData } from "@/data/builders/CouponBuilder";

export class CouponDialogComponent extends BaseModal {
  readonly form: Form;
  readonly codeInput: Locator;
  readonly discountValueInput: Locator;
  readonly typeSelect: Select;

  constructor(page: Page) {
    super(page);
    this.form = new Form(page, this.root.locator("form").first());
    this.codeInput = this.root.locator("input#code, input[name='code']").first();
    this.discountValueInput = this.root.locator("input#discount_value, input[name='discount_value']").first();
    this.typeSelect = Select.fromId(page, "discount_type");
  }

  async fillCouponData(data: Partial<CouponData>): Promise<void> {
    if (data.code) await this.codeInput.fill(data.code);
    if (data.discount_type) {
      const typeLabel = data.discount_type === "PERCENTAGE" ? "Percentage" : "Flat Amount";
      await this.typeSelect.selectOption(typeLabel);
    }
    if (data.discount_value !== undefined) {
      await this.discountValueInput.fill(String(data.discount_value));
    }
    if (data.max_discount_amount !== undefined) {
      await this.form.fillInput("max_discount", String(data.max_discount_amount));
    }
    if (data.usage_limit !== undefined) {
      await this.form.fillInput("usage_limit", String(data.usage_limit));
    }
    if (data.is_active !== undefined) {
      await this.form.toggleSwitch("is_active", data.is_active);
    }
  }

  async saveCoupon(data: Partial<CouponData>): Promise<void> {
    await this.fillCouponData(data);
    await this.submit();
  }
}
