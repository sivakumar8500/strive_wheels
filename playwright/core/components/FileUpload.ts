import { Page, Locator, expect } from "@playwright/test";
import { BaseComponent } from "@/core/base/BaseComponent";

export class FileUpload extends BaseComponent {
  readonly fileInput: Locator;
  readonly previewImage: Locator;
  readonly removeButton: Locator;

  constructor(page: Page, rootLocator?: Locator) {
    const root = rootLocator || page.locator("div:has(input[type='file'])").first();
    super(page, root);
    this.fileInput = this.root.locator("input[type='file']").first();
    this.previewImage = this.root.locator("img[alt='Preview']").first();
    this.removeButton = this.root.locator("button:has-text('Remove Image')").first();
  }

  async uploadFile(filePath: string): Promise<void> {
    await this.fileInput.setInputFiles(filePath);
  }

  async expectPreviewVisible(): Promise<void> {
    await expect(this.previewImage).toBeVisible();
  }

  async removeUploadedFile(): Promise<void> {
    // Hover over preview to make remove button visible if opacity is 0
    await this.previewImage.hover();
    await this.removeButton.click();
  }
}
