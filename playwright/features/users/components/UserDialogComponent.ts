import { Page, Locator } from "@playwright/test";
import { BaseModal } from "@/core/base/BaseModal";
import { Form } from "@/core/components/Form";
import { Select } from "@/core/components/Select";
import { UserData } from "@/data/builders/UserBuilder";

export class UserDialogComponent extends BaseModal {
  readonly form: Form;
  readonly firstNameInput: Locator;
  readonly lastNameInput: Locator;
  readonly emailInput: Locator;
  readonly roleSelect: Select;

  constructor(page: Page) {
    super(page);
    this.form = new Form(page, this.root.locator("form").first());
    this.firstNameInput = this.root.locator("input#first_name, input[name='first_name']").first();
    this.lastNameInput = this.root.locator("input#last_name, input[name='last_name']").first();
    this.emailInput = this.root.locator("input#email, input[name='email']").first();
    this.roleSelect = Select.fromId(page, "role");
  }

  async fillUserData(user: Partial<UserData>): Promise<void> {
    if (user.first_name !== undefined) await this.firstNameInput.fill(user.first_name);
    if (user.last_name !== undefined) await this.lastNameInput.fill(user.last_name);
    if (user.email !== undefined) await this.emailInput.fill(user.email);
    if (user.role) {
      const roleLabel =
        user.role === "SUPER_ADMIN"
          ? "Super Admin"
          : user.role === "COMPANY_ADMIN"
          ? "Company Admin"
          : "Admin";
      await this.roleSelect.selectOption(roleLabel);
    }
    if (user.is_active !== undefined) {
      await this.form.toggleSwitch("is_active", user.is_active);
    }
  }

  async saveUser(user: Partial<UserData>): Promise<void> {
    await this.fillUserData(user);
    await this.submit();
  }
}
