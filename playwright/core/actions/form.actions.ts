import { Form } from "@/core/components/Form";
import { Select } from "@/core/components/Select";
import { Page } from "@playwright/test";

export class FormActions {
  static async fillTextFields(form: Form, fields: Record<string, string>): Promise<void> {
    for (const [key, value] of Object.entries(fields)) {
      await form.fillInput(key, value);
    }
  }

  static async selectDropdown(page: Page, fieldIdOrName: string, optionLabel: string): Promise<void> {
    const select = Select.fromId(page, fieldIdOrName);
    await select.selectOption(optionLabel);
  }
}
