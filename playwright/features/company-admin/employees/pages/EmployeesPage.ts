import { Page, Locator } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { Table } from "@/core/components/Table";
import { Pagination } from "@/core/components/Pagination";
import { DeleteDialog } from "@/core/components/Dialog";
import { BaseModal } from "@/core/base/BaseModal";
import { Form } from "@/core/components/Form";
import { ROUTES } from "@/data/constants/routes";

export interface EmployeeData {
  name: string;
  phone: string;
  employee_code?: string;
  spending_limit?: number;
  status?: string;
}

export class EmployeeModal extends BaseModal {
  readonly form: Form;

  constructor(page: Page) {
    super(page);
    this.form = new Form(page, this.root.locator("form").first());
  }

  async fillEmployeeData(data: Partial<EmployeeData>): Promise<void> {
    if (data.name) await this.form.fillInput("name", data.name);
    if (data.phone) await this.form.fillInput("phone", data.phone);
    if (data.employee_code) await this.form.fillInput("employee_code", data.employee_code);
    if (data.spending_limit !== undefined) {
      await this.form.fillInput("spending_limit", String(data.spending_limit));
    }
  }

  async saveEmployee(data: Partial<EmployeeData>): Promise<void> {
    await this.fillEmployeeData(data);
    await this.submit();
  }
}

export class EmployeesPage extends BasePage {
  readonly table: Table;
  readonly pagination: Pagination;
  readonly modal: EmployeeModal;
  readonly deleteDialog: DeleteDialog;
  readonly addEmployeeButton: Locator;

  constructor(page: Page) {
    super(page, ROUTES.COMPANY_EMPLOYEES);
    this.table = new Table(page);
    this.pagination = new Pagination(page);
    this.modal = new EmployeeModal(page);
    this.deleteDialog = new DeleteDialog(page);
    this.addEmployeeButton = page.locator("button:has-text('Whitelist Employee'), button:has-text('Add Employee')").first();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.waitForPageLoaded();
  }

  async clickAddEmployee(): Promise<void> {
    await this.addEmployeeButton.waitFor({ state: "visible" });
    await this.addEmployeeButton.click();
    try {
      await this.page.locator("[role='dialog']:not([data-nextjs-dialog])").waitFor({ state: "visible", timeout: 2000 });
    } catch {
      await this.addEmployeeButton.click();
      await this.modal.expectOpen();
    }
  }

  async createEmployee(data: EmployeeData): Promise<void> {
    await this.clickAddEmployee();
    await this.modal.saveEmployee(data);
    await this.modal.expectClosed();
  }

  async deleteEmployee(emailOrName: string): Promise<void> {
    await this.table.clickDeleteAction(emailOrName);
    await this.deleteDialog.expectOpen();
    await this.deleteDialog.confirmDelete();
  }

  async expectEmployeeVisible(emailOrName: string): Promise<void> {
    await this.table.expectRowVisible(emailOrName);
  }
}
