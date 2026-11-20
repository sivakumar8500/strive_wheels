import { authTest as test } from "@/fixtures/auth.fixture";
import { SettingsPage } from "@/features/settings/pages/SettingsPage";

test.describe("Settings Feature", () => {
  let settingsPage: SettingsPage;

  test.beforeEach(async ({ adminPage }) => {
    settingsPage = new SettingsPage(adminPage);
  });

  test("should load account details settings @smoke", async () => {
    await settingsPage.open();
    await settingsPage.expectOnAccountDetails();
  });

  test("should load notifications settings @regression", async () => {
    await settingsPage.openNotifications();
    await settingsPage.expectOnNotifications();
  });
});

