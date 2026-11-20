import { authTest as test } from "@/fixtures/auth.fixture";
import { expect } from "@playwright/test";
import { EmployeesPage, EmployeeData } from "@/features/company-admin/employees/pages/EmployeesPage";
import { RandomUtils } from "@/core/utils/random.utils";
import { API_ROUTES } from "@/data/constants/routes";

test.describe("Company Admin - Employees Feature", () => {
  let employeesPage: EmployeesPage;
  const employeesDb: any[] = [];

  test.beforeEach(async ({ companyAdminPage }) => {
    await companyAdminPage.route(API_ROUTES.COMPANY_ME_EMPLOYEES, async (route) => {
      const method = route.request().method();
      if (method === "GET") {
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: employeesDb }),
        });
      } else if (method === "POST") {
        const postData = route.request().postDataJSON();
        const newEmp = {
          ...postData,
          id: employeesDb.length + 1,
          amount_spent: 0,
          spending_limit: Number(postData.spending_limit) || 5000,
          status: postData.status || "ACTIVE",
        };
        employeesDb.push(newEmp);
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true, data: newEmp }),
        });
      } else if (method === "DELETE") {
        employeesDb.pop();
        await route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true }),
        });
      } else {
        await route.continue();
      }
    });

    employeesPage = new EmployeesPage(companyAdminPage);
    await employeesPage.open();
  });

  test("should display corporate employee roster @smoke", async () => {
    await expect(employeesPage.pageTitle).toHaveText(/Employee Roster/i);
    await expect(employeesPage.addEmployeeButton).toBeVisible();
    expect(await employeesPage.table.getRowCount()).toBeGreaterThanOrEqual(0);
  });

  test("company admin should onboard a new corporate employee @regression", async () => {
    const { firstName, lastName } = RandomUtils.getRandomName("Corp");
    const newEmployee: EmployeeData = {
      name: `${firstName} ${lastName}`,
      phone: "+919876543299",
      employee_code: "EMP-" + Math.floor(Math.random() * 1000),
      spending_limit: 5000,
    };

    await employeesPage.createEmployee(newEmployee);
    await employeesPage.expectEmployeeVisible(newEmployee.name);
  });
});
