import { test, expect } from "@/fixtures/feature.fixture";
import { VehicleTypesPage } from "@/features/vehicle-types/pages/VehicleTypesPage";
import { VehicleTypeBuilder } from "@/data/builders/VehicleTypeBuilder";
import { ROUTES, ROUTE_PATTERNS } from "@/data/constants/routes";

test.describe("Vehicle Types Feature", () => {
  let vehicleTypesPage: VehicleTypesPage;
  const vehiclesDb: any[] = [];

  test.beforeEach(async ({ adminPage }) => {
    await adminPage.route(new RegExp(ROUTES.ADMIN_VEHICLE_TYPES), async (route) => {
      if (route.request().resourceType() !== "fetch" && route.request().resourceType() !== "xhr") {
        await route.continue();
        return;
      }

      const method = route.request().method();
      if (method === "GET") {
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: vehiclesDb }),
        });
      } else if (method === "POST") {
        const postData = route.request().postDataJSON();
        const newVehicle = { ...postData, id: vehiclesDb.length + 1 };
        vehiclesDb.push(newVehicle);
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: newVehicle }),
        });
      } else if (method === "DELETE") {
        const url = route.request().url();
        const idMatch = url.match(ROUTE_PATTERNS.ADMIN_VEHICLE_TYPE_ID);
        if (idMatch) {
          const id = Number(idMatch[1]);
          const index = vehiclesDb.findIndex((v) => v.id === id);
          if (index !== -1) vehiclesDb.splice(index, 1);
        } else {
          vehiclesDb.pop();
        }
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: { deleted: true } }),
        });
      } else {
        await route.continue();
      }
    });

    vehicleTypesPage = new VehicleTypesPage(adminPage);
    await vehicleTypesPage.open();
  });

  test("should display vehicle types catalog @smoke", async () => {
    await expect(vehicleTypesPage.pageTitle).toHaveText(/Vehicle Types/i);
    await expect(vehicleTypesPage.addVehicleButton).toBeVisible();
    expect(await vehicleTypesPage.table.getRowCount()).toBeGreaterThanOrEqual(0);
  });

  test("admin should add a new vehicle category @regression", async () => {
    const newVehicle = VehicleTypeBuilder.valid();

    await vehicleTypesPage.createVehicle(newVehicle);
    await vehicleTypesPage.expectVehicleVisible(newVehicle.name);
  });

  test("admin should delete a vehicle category via confirmation dialog @regression", async () => {
    const vehicleToDelete = VehicleTypeBuilder.valid();
    await vehicleTypesPage.createVehicle(vehicleToDelete);
    await vehicleTypesPage.expectVehicleVisible(vehicleToDelete.name);

    await vehicleTypesPage.deleteVehicle(vehicleToDelete.name);
    await vehicleTypesPage.table.expectRowNotVisible(vehicleToDelete.name);
  });
});
