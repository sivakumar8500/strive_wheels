import { Form } from "@/core/components/Form";

export class FormAssertions {
  static async expectFieldError(form: Form, fieldName: string, message?: string | RegExp): Promise<void> {
    await form.expectFieldError(fieldName, message);
  }

  static async expectValidationError(form: Form, message: string | RegExp): Promise<void> {
    await form.expectValidationError(message);
  }
}
