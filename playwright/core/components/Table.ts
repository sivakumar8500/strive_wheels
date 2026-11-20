import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class Table extends BaseComponent {
  readonly tableLocator: Locator;
  readonly headerRow: Locator;
  readonly rows: Locator;
  readonly emptyState: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    const root = rootLocator || page.locator("table").first();
    super(page, root);
    this.tableLocator = this.root;
    this.headerRow = this.tableLocator.locator("thead tr").first();
    this.rows = this.tableLocator.locator("tbody tr");
    this.emptyState = page.locator("[data-slot='empty-state'], div:has-text('No data available'), div:has-text('No admin users found')").first();
  }

  async getRowCount(): Promise<number> {
    return this.rows.count();
  }

  async getRow(index: number): Promise<Locator> {
    return this.rows.nth(index);
  }

  findRowByText(text: string): Locator {
    return this.rows.filter({ hasText: text }).first();
  }

  async getCellText(rowIndex: number, colIndex: number): Promise<string> {
    const cell = this.rows.nth(rowIndex).locator("td").nth(colIndex);
    return (await cell.textContent()) || "";
  }

  async clickRowAction(rowIdentifier: string, actionLabelOrTitle?: string): Promise<void> {
    const row = this.findRowByText(rowIdentifier);
    await expect(row).toBeVisible();

    const actionsCell = row.locator("td").last();
    if (actionLabelOrTitle) {
      // Find button by title, text, or aria-label
      const actionButton = actionsCell.locator(
        `button[title*="${actionLabelOrTitle}" i], button:has-text("${actionLabelOrTitle}")`
      ).first();
      await actionButton.click();
    } else {
      // Default to first action button in cell
      await actionsCell.locator("button").first().click();
    }
  }

  async clickEditAction(rowIdentifier: string): Promise<void> {
    const row = this.findRowByText(rowIdentifier);
    await expect(row).toBeVisible();
    const actionsCell = row.locator("td").last();
    // Edit button: check for text-blue, edit text, or first action button
    const editBtn = actionsCell
      .locator("button.text-blue-600, button[title*='Edit' i], button:has-text('Edit')")
      .or(actionsCell.locator("button").first())
      .first();
    await editBtn.click();
  }

  async clickDeleteAction(rowIdentifier: string): Promise<void> {
    const row = this.findRowByText(rowIdentifier);
    await expect(row).toBeVisible();
    const actionsCell = row.locator("td").last();
    // Delete button: check for text-red, delete text, or second action button
    const deleteBtn = actionsCell
      .locator("button.text-red-600, button[title*='Delete' i], button:has-text('Delete')")
      .or(actionsCell.locator("button").nth(1))
      .first();
    await deleteBtn.click();
  }

  async expectRowVisible(text: string): Promise<void> {
    const row = this.findRowByText(text);
    await expect(row).toBeVisible();
  }

  async expectRowNotVisible(text: string): Promise<void> {
    const row = this.findRowByText(text);
    await expect(row).toBeHidden();
  }

  async expectEmpty(expectedMessage?: string): Promise<void> {
    if (expectedMessage) {
      await expect(this.page.locator(`text=${expectedMessage}`)).toBeVisible();
    } else {
      await expect(this.emptyState).toBeVisible();
    }
  }
}
