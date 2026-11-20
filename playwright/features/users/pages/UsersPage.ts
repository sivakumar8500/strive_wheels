import { Page, Locator } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { Table } from "@/core/components/Table";
import { Pagination } from "@/core/components/Pagination";
import { DeleteDialog } from "@/core/components/Dialog";
import { UserDialogComponent } from "@/features/users/components/UserDialogComponent";
import { UserData } from "@/data/builders/UserBuilder";
import { ROUTES } from "@/data/constants/routes";

export class UsersPage extends BasePage {
  readonly table: Table;
  readonly pagination: Pagination;
  readonly userDialog: UserDialogComponent;
  readonly deleteDialog: DeleteDialog;
  readonly provisionButton: Locator;

  constructor(page: Page) {
    super(page, ROUTES.ADMIN_USERS);
    this.table = new Table(page);
    this.pagination = new Pagination(page);
    this.userDialog = new UserDialogComponent(page);
    this.deleteDialog = new DeleteDialog(page);
    this.provisionButton = page.locator("button:has-text('Provision User')").first();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.waitForPageLoaded();
  }

  async clickProvisionUser(): Promise<void> {
    await this.provisionButton.click();
    await this.userDialog.expectOpen();
  }

  async createUser(user: UserData): Promise<void> {
    await this.clickProvisionUser();
    await this.userDialog.saveUser(user);
    await this.userDialog.expectClosed();
  }

  async editUser(email: string, updatedData: Partial<UserData>): Promise<void> {
    await this.table.clickEditAction(email);
    await this.userDialog.expectOpen();
    await this.userDialog.saveUser(updatedData);
    await this.userDialog.expectClosed();
  }

  async deleteUser(email: string): Promise<void> {
    await this.table.clickDeleteAction(email);
    await this.deleteDialog.expectOpen();
    await this.deleteDialog.confirmDelete();
  }

  async expectUserVisible(email: string): Promise<void> {
    await this.table.expectRowVisible(email);
  }

  async expectUserNotVisible(email: string): Promise<void> {
    await this.table.expectRowNotVisible(email);
  }
}
