import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class Pagination extends BaseComponent {
  readonly summaryText: Locator;
  readonly rowsPerPageSelect: Locator;
  readonly prevButton: Locator;
  readonly nextButton: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    const root = rootLocator || page.locator("div.flex.bg-\\[\\#F8FAFC\\], div:has(button:has(svg.lucide-chevron-left))").first();
    super(page, root);

    this.summaryText = this.root.locator("p:has-text('Showing')").first();
    this.rowsPerPageSelect = this.root.locator("select").first();
    this.prevButton = this.root.locator("button:has(svg.lucide-chevron-left)").first();
    this.nextButton = this.root.locator("button:has(svg.lucide-chevron-right)").first();
  }

  async getSummary(): Promise<string> {
    return (await this.summaryText.textContent()) || "";
  }

  async setRowsPerPage(count: number | string): Promise<void> {
    await this.rowsPerPageSelect.selectOption(String(count));
  }

  async nextPage(): Promise<void> {
    await expect(this.nextButton).toBeEnabled();
    await this.nextButton.click();
  }

  async prevPage(): Promise<void> {
    await expect(this.prevButton).toBeEnabled();
    await this.prevButton.click();
  }

  async goToPage(pageNumber: number): Promise<void> {
    const pageButton = this.root.locator(`button:has-text("${pageNumber}")`).first();
    await pageButton.click();
  }

  async expectCurrentPage(pageNumber: number): Promise<void> {
    const pageButton = this.root.locator(`button:has-text("${pageNumber}")`).first();
    // Active page has text-white and bg-primary
    await expect(pageButton).toHaveClass(/bg-primary/);
  }
}
