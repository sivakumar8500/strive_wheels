import { Page, Locator } from "@playwright/test";
import { BasePage } from "@/core/base/BasePage";
import { Table } from "@/core/components/Table";
import { Pagination } from "@/core/components/Pagination";
import { CancelBookingDialogComponent } from "@/features/bookings/components/CancelBookingDialogComponent";
import { ROUTES } from "@/data/constants/routes";

export class BookingsPage extends BasePage {
  readonly table: Table;
  readonly pagination: Pagination;
  readonly cancelDialog: CancelBookingDialogComponent;
  readonly searchInput: Locator;
  readonly statusSelectTrigger: Locator;
  readonly serviceSelectTrigger: Locator;

  constructor(page: Page) {
    super(page, ROUTES.ADMIN_BOOKINGS);
    this.table = new Table(page);
    this.pagination = new Pagination(page);
    this.cancelDialog = new CancelBookingDialogComponent(page);
    this.searchInput = page.locator("input[placeholder*='Search by code']").first();
    this.statusSelectTrigger = page.locator("button[role='combobox']:has-text('Status'), button:has-text('All Statuses')").first();
    this.serviceSelectTrigger = page.locator("button[role='combobox']:has-text('Service Mode'), button:has-text('All Services')").first();
  }

  async open(): Promise<void> {
    await this.goto();
    await this.waitForPageLoaded();
  }

  async searchBooking(code: string): Promise<void> {
    await this.searchInput.fill(code);
    await this.waitForPageLoaded();
  }

  async filterByStatus(status: string): Promise<void> {
    await this.statusSelectTrigger.click();
    const option = this.page.locator(`[role='option']:has-text('${status}')`).first();
    await option.click();
    await this.waitForPageLoaded();
  }

  async filterByServiceMode(serviceMode: string): Promise<void> {
    await this.serviceSelectTrigger.click();
    const option = this.page.locator(`[role='option']:has-text('${serviceMode}')`).first();
    await option.click();
    await this.waitForPageLoaded();
  }

  async forceCancelBooking(bookingCode: string, reason: string): Promise<void> {
    await this.table.clickRowAction(bookingCode, "Force Cancel");
    await this.cancelDialog.expectOpen();
    await this.cancelDialog.cancelWithReason(reason);
    await this.cancelDialog.expectClosed();
  }

  async expectBookingVisible(code: string): Promise<void> {
    await this.table.expectRowVisible(code);
  }
}
