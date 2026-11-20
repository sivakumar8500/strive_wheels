import { Page, Locator } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { Table } from "@/core/components/Table";
import { Pagination } from "@/core/components/Pagination";
import { DeleteDialog } from "@/core/components/Dialog";
import { CouponDialogComponent } from "@/features/coupons/components/CouponDialogComponent";
import { CouponData } from "@/data/builders/CouponBuilder";
import { ROUTES } from "@/data/constants/routes";

export class CouponsPage extends BasePage {
  readonly table: Table;
  readonly pagination: Pagination;
  readonly couponDialog: CouponDialogComponent;
  readonly deleteDialog: DeleteDialog;
  readonly createButton: Locator;

  constructor(page: Page) {
    super(page, ROUTES.ADMIN_COUPONS);
    this.table = new Table(page);
    this.pagination = new Pagination(page);
    this.couponDialog = new CouponDialogComponent(page);
    this.deleteDialog = new DeleteDialog(page);
    this.createButton = page.locator("button:has-text('Create Coupon')").first();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.waitForPageLoaded();
  }

  async clickCreateCoupon(): Promise<void> {
    await this.createButton.click();
    await this.couponDialog.expectOpen();
  }

  async createCoupon(data: CouponData): Promise<void> {
    await this.clickCreateCoupon();
    await this.couponDialog.saveCoupon(data);
    await this.couponDialog.expectClosed();
  }

  async deleteCoupon(code: string): Promise<void> {
    await this.table.clickDeleteAction(code);
    await this.deleteDialog.expectOpen();
    await this.deleteDialog.confirmDelete();
  }

  async expectCouponVisible(code: string): Promise<void> {
    await this.table.expectRowVisible(code);
  }
}
