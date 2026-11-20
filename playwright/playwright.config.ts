import { defineConfig, devices } from "@playwright/test";
import { getEnvironment } from "@/config/environments";

const env = getEnvironment();
const isCI = !!process.env.CI;

export default defineConfig({
  testDir: "./features",
  outputDir: "./test-results",
  timeout: env.defaultTimeout,
  expect: {
    timeout: env.expectTimeout,
  },
  fullyParallel: true,
  forbidOnly: isCI,
  retries: isCI ? 2 : 0,
  workers: isCI ? 2 : 2,
  reporter: [
    ["list"],
    ["html", { outputFolder: "./report", open: "never" }],
    ["json", { outputFile: "./report/results.json" }],
  ],
  use: {
    baseURL: env.baseUrl,
    navigationTimeout: env.navigationTimeout,
    actionTimeout: 15000,
    trace: isCI ? "on-first-retry" : "retain-on-failure",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
    extraHTTPHeaders: {
      Accept: "application/json",
    },
  },
  projects: [
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        channel: "chrome",
      },
    },
  ],
  webServer: {
    command: "npm run dev",
    cwd: "../admin",
    url: env.baseUrl,
    reuseExistingServer: !isCI,
    timeout: 120000,
  },
});
