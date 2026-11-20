import { test as baseTest, expect } from "@playwright/test";
import { ApiClient } from "@/api/ApiClient";
import { Toast } from "@/core/components/Toast";

export type BaseFixtures = {
  apiClient: ApiClient;
  toast: Toast;
};

export const test = baseTest.extend<BaseFixtures>({
  apiClient: async ({}, use) => {
    const client = new ApiClient();
    await use(client);
    await client.dispose();
  },

  toast: async ({ page }, use) => {
    const toast = new Toast(page);
    await use(toast);
  },
});

export { expect };
