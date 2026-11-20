import { Table } from "@/core/components/Table";

export class TableAssertions {
  static async expectRowVisible(table: Table, text: string): Promise<void> {
    await table.expectRowVisible(text);
  }

  static async expectRowNotVisible(table: Table, text: string): Promise<void> {
    await table.expectRowNotVisible(text);
  }

  static async expectEmptyState(table: Table, emptyMessage?: string): Promise<void> {
    await table.expectEmpty(emptyMessage);
  }
}
