import { Page, Locator } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { Table } from "@/core/components/Table";
import { Pagination } from "@/core/components/Pagination";
import { DeleteDialog } from "@/core/components/Dialog";
import { BaseModal } from "@/core/base/BaseModal";
import { Form } from "@/core/components/Form";
import { VehicleTypeData } from "@/data/builders/VehicleTypeBuilder";
import { ROUTES } from "@/data/constants/routes";

export class VehicleTypeModal extends BaseModal {
  readonly form: Form;

  constructor(page: Page) {
    super(page);
    this.form = new Form(page, this.root.locator("form").first());
  }

  async fillVehicleData(data: Partial<VehicleTypeData>): Promise<void> {
    if (data.code) await this.form.fillInput("code", data.code);
    if (data.name) await this.form.fillInput("name", data.name);
    if (data.description) await this.form.fillInput("description", data.description);
    if (data.max_passengers !== undefined) {
      await this.form.fillInput("max_passengers", String(data.max_passengers));
    }
    if (data.max_weight_kg !== undefined) {
      await this.form.fillInput("max_weight_kg", String(data.max_weight_kg));
    }
    if (data.is_active !== undefined) {
      await this.form.toggleSwitch("is_active", data.is_active);
    }
  }

  async saveVehicle(data: Partial<VehicleTypeData>): Promise<void> {
    await this.fillVehicleData(data);
    await this.submit();
  }
}

export class VehicleTypesPage extends BasePage {
  readonly table: Table;
  readonly pagination: Pagination;
  readonly modal: VehicleTypeModal;
  readonly deleteDialog: DeleteDialog;
  readonly addVehicleButton: Locator;

  constructor(page: Page) {
    super(page, ROUTES.ADMIN_VEHICLE_TYPES);
    this.table = new Table(page);
    this.pagination = new Pagination(page);
    this.modal = new VehicleTypeModal(page);
    this.deleteDialog = new DeleteDialog(page);
    this.addVehicleButton = page.locator("button:has-text('Add Vehicle Type')").first();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.waitForPageLoaded();
  }

  async clickAddVehicle(): Promise<void> {
    await this.addVehicleButton.waitFor({ state: "visible" });
    await this.addVehicleButton.click();
    try {
      await this.page.locator("[role='dialog']:not([data-nextjs-dialog])").waitFor({ state: "visible", timeout: 2000 });
    } catch {
      await this.addVehicleButton.click();
      await this.modal.expectOpen();
    }
  }

  async createVehicle(data: VehicleTypeData): Promise<void> {
    await this.clickAddVehicle();
    await this.modal.saveVehicle(data);
    await this.modal.expectClosed();
  }

  async deleteVehicle(codeOrName: string): Promise<void> {
    await this.table.clickDeleteAction(codeOrName);
    await this.deleteDialog.expectOpen();
    await this.deleteDialog.confirmDelete();
  }

  async expectVehicleVisible(codeOrName: string): Promise<void> {
    await this.table.expectRowVisible(codeOrName);
  }
}
