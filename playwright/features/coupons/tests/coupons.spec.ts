import { test, expect } from "@/fixtures/feature.fixture";
import { CouponBuilder } from "@/data/builders/CouponBuilder";
import { ROUTES, ROUTE_PATTERNS } from "@/data/constants/routes";

test.describe("Coupons Feature", () => {
  const couponsDb: any[] = [];

  test.beforeEach(async ({ couponsPage }) => {
    await couponsPage.page.route(new RegExp(ROUTES.ADMIN_COUPONS), async (route) => {
      // Intercept only API XHR/Fetch requests, allowing Next.js HTML page navigation through
      if (route.request().resourceType() !== "fetch" && route.request().resourceType() !== "xhr") {
        await route.continue();
        return;
      }

      const method = route.request().method();
      if (method === "GET") {
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: couponsDb }),
        });
      } else if (method === "POST") {
        const postData = route.request().postDataJSON();
        const newCoupon = { ...postData, id: couponsDb.length + 1 };
        couponsDb.push(newCoupon);
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: newCoupon }),
        });
      } else if (method === "DELETE") {
        const url = route.request().url();
        const idMatch = url.match(ROUTE_PATTERNS.ADMIN_COUPON_ID);
        if (idMatch) {
          const id = Number(idMatch[1]);
          const index = couponsDb.findIndex((c) => c.id === id);
          if (index !== -1) couponsDb.splice(index, 1);
        } else {
          couponsDb.pop();
        }
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, message: "Deleted" }),
        });
      } else {
        await route.continue();
      }
    });

    await couponsPage.open();
  });

  test("should display coupons management table @smoke", async ({ couponsPage }) => {
    await expect(couponsPage.pageTitle).toHaveText(/Coupon/i);
    await expect(couponsPage.createButton).toBeVisible();
    expect(await couponsPage.table.getRowCount()).toBeGreaterThanOrEqual(0);
  });

  test("admin should create a new coupon @regression", async ({ couponsPage }) => {
    const newCoupon = CouponBuilder.valid();

    await couponsPage.createCoupon(newCoupon);
    await couponsPage.expectCouponVisible(newCoupon.code);
  });

  test("admin should delete an existing coupon @regression", async ({ couponsPage }) => {
    const couponToDelete = CouponBuilder.valid();
    await couponsPage.createCoupon(couponToDelete);
    await couponsPage.expectCouponVisible(couponToDelete.code);

    await couponsPage.deleteCoupon(couponToDelete.code);
    await couponsPage.table.expectRowNotVisible(couponToDelete.code);
  });
});
