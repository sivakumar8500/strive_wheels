import { test, expect } from "@/fixtures/feature.fixture";
import { UserBuilder } from "@/data/builders/UserBuilder";

test.describe("Users Feature", () => {
  test.beforeEach(async ({ usersPage }) => {
    await usersPage.open();
  });

  test("should render the users management table @smoke", async ({ usersPage }) => {
    await expect(usersPage.pageTitle).toHaveText(/Super Admin User Provisioning/i);
    await expect(usersPage.provisionButton).toBeVisible();
    expect(await usersPage.table.getRowCount()).toBeGreaterThanOrEqual(0);
  });

  test("admin should provision a new user @regression", async ({ usersPage }) => {
    // Given
    const newUser = UserBuilder.valid();

    // When
    await usersPage.createUser(newUser);

    // Then
    await usersPage.expectUserVisible(newUser.email);
  });

  test("admin should edit an existing user @regression", async ({ usersPage }) => {
    // Given
    const userToCreate = UserBuilder.valid();
    await usersPage.createUser(userToCreate);

    const updatedData = {
      first_name: "UpdatedFirst",
      last_name: "UpdatedLast",
    };

    // When
    await usersPage.editUser(userToCreate.email, updatedData);

    // Then
    await usersPage.expectUserVisible("UpdatedFirst");
  });

  test("admin should delete a user via confirmation dialog @regression", async ({ usersPage }) => {
    // Given
    const userToDelete = UserBuilder.valid();
    await usersPage.createUser(userToDelete);
    await usersPage.expectUserVisible(userToDelete.email);

    // When
    await usersPage.deleteUser(userToDelete.email);

    // Then
    await usersPage.expectUserNotVisible(userToDelete.email);
  });

  test("should validate required user fields in dialog @regression", async ({ usersPage }) => {
    await usersPage.clickProvisionUser();
    // Submit without entering required fields
    await usersPage.userDialog.submit();
    await usersPage.userDialog.expectOpen();
  });
});
