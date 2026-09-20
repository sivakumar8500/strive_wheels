import { Page } from "@playwright/test";
import { Navigation } from "@/core/components/Navigation";

export class NavigationActions {
  static async goToModule(page: Page, moduleName: string): Promise<void> {
    const nav = new Navigation(page);
    await nav.navigateTo(moduleName);
  }

  static async goToRoute(page: Page, route: string): Promise<void> {
    const nav = new Navigation(page);
    await nav.navigateToRoute(route);
  }

  static async performLogout(page: Page): Promise<void> {
    const nav = new Navigation(page);
    await nav.logout();
  }
}
