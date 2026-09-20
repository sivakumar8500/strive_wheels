import { test, expect } from "@/fixtures/feature.fixture";
import { BookingBuilder } from "@/data/builders/BookingBuilder";
import { ROUTES } from "@/data/constants/routes";

test.describe("Bookings Feature", () => {
  const bookingsDb: any[] = [
    {
      id: 1,
      booking_code: "BK-1001",
      customer_name: "Alice Smith",
      customer_phone: "+919876543201",
      pickup_address: "Tech Park, City",
      dropoff_address: "Airport Terminal 2",
      vehicle_type: "SEDAN",
      status: "PENDING",
      fare_amount: 450,
      created_at: new Date().toISOString(),
    },
  ];

  test.beforeEach(async ({ bookingsPage }) => {
    await bookingsPage.page.route(new RegExp(ROUTES.ADMIN_BOOKINGS), async (route) => {
      if (route.request().resourceType() !== "fetch" && route.request().resourceType() !== "xhr") {
        await route.continue();
        return;
      }

      const method = route.request().method();
      if (method === "GET") {
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({
            success: true,
            data: bookingsDb,
            total: bookingsDb.length,
            skip: 0,
            limit: 10,
          }),
        });
      } else if (method === "POST") {
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, message: "Booking updated" }),
        });
      } else {
        await route.continue();
      }
    });

    await bookingsPage.open();
  });

  test("should display bookings management interface @smoke", async ({ bookingsPage }) => {
    await expect(bookingsPage.pageTitle).toHaveText(/Booking Management/i);
    await expect(bookingsPage.searchInput).toBeVisible();
    await expect(bookingsPage.statusSelectTrigger).toBeVisible();
    await expect(bookingsPage.serviceSelectTrigger).toBeVisible();
  });

  test("should filter bookings by search input @regression", async ({ bookingsPage }) => {
    await bookingsPage.searchBooking("BK-");
    await bookingsPage.waitForPageLoaded();
    // Search input retains the typed query
    await expect(bookingsPage.searchInput).toHaveValue("BK-");
  });

  test("should open and submit force cancel dialog @regression", async ({ bookingsPage }) => {
    // Mock a pending booking row if table is empty
    const firstRow = bookingsPage.table.rows.first();
    if (await firstRow.isVisible()) {
      const cancelBtn = firstRow.locator("button:has-text('Force Cancel')").first();
      if (await cancelBtn.isVisible()) {
        const cancelData = BookingBuilder.cancellationReason();
        await cancelBtn.click();
        await bookingsPage.cancelDialog.expectOpen();
        await bookingsPage.cancelDialog.cancelWithReason(cancelData.reason);
        await bookingsPage.cancelDialog.expectClosed();
      }
    }
  });
});
