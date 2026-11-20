import { Table } from "@/core/components/Table";

export class TableActions {
  static async editRow(table: Table, identifierText: string): Promise<void> {
    await table.clickEditAction(identifierText);
  }

  static async deleteRow(table: Table, identifierText: string): Promise<void> {
    await table.clickDeleteAction(identifierText);
  }

  static async verifyRowExists(table: Table, identifierText: string): Promise<void> {
    await table.expectRowVisible(identifierText);
  }

  static async verifyRowNotExists(table: Table, identifierText: string): Promise<void> {
    await table.expectRowNotVisible(identifierText);
  }
}
