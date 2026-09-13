export const MAX_FILE_BYTES = 25 * 1024 * 1024; // 25 MB
export const MAX_CSV_ROWS = 50000;

export interface FileValidationResult {
  isValid: boolean;
  error?: string;
  rows?: number;
  columns?: string[];
}

import { getColumnNames } from "@/utils/fileUtils";

const parseCSV = (file: File): Promise<FileValidationResult> => {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.onload = (event) => {
      const text = event.target?.result as string;
      const lines = text.split("\n").filter((line) => line.trim() !== "");
      const rowsCount = Math.max(0, lines.length - 1); // Exclude header row

      let columns: string[] = [];
      if (lines.length > 0) {
        columns = lines[0]
          .split(",")
          .map((c) => c.trim().replace(/^"|"$/g, ""))
          .filter(Boolean);
      }

      if (rowsCount > MAX_CSV_ROWS) {
        resolve({
          isValid: false,
          error: `File exceeds maximum limit of ${MAX_CSV_ROWS.toLocaleString()} rows.`,
        });
      } else {
        resolve({ isValid: true, rows: rowsCount, columns });
      }
    };
    reader.onerror = () =>
      resolve({ isValid: false, error: "Failed to read the file." });
    reader.readAsText(file);
  });
};

const parseJSON = (file: File): Promise<FileValidationResult> => {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.onload = (event) => {
      try {
        const text = event.target?.result as string;
        const data = JSON.parse(text);
        if (Array.isArray(data)) {
          const columns = getColumnNames(data);
          resolve({ isValid: true, rows: data.length, columns });
        } else {
          resolve({ isValid: true, rows: 1, columns: Object.keys(data) });
        }
      } catch {
        resolve({ isValid: false, error: "Invalid JSON format." });
      }
    };
    reader.onerror = () =>
      resolve({ isValid: false, error: "Failed to read the file." });
    reader.readAsText(file);
  });
};

const parseExcel = (file: File): Promise<FileValidationResult> => {
  return new Promise(async (resolve) => {
    try {
      const XLSX = await import("xlsx");
      const reader = new FileReader();
      reader.onload = (event) => {
        try {
          const data = new Uint8Array(event.target?.result as ArrayBuffer);
          const workbook = XLSX.read(data, { type: "array" });
          const firstSheetName = workbook.SheetNames[0];
          const worksheet = workbook.Sheets[firstSheetName];
          const json =
            XLSX.utils.sheet_to_json<Record<string, unknown>>(worksheet);

          const rowsCount = json.length;
          let columns: string[] = [];
          if (rowsCount > 0) {
            columns = Object.keys(json[0]);
          }
          resolve({ isValid: true, rows: rowsCount, columns });
        } catch {
          resolve({ isValid: false, error: "Failed to parse Excel file." });
        }
      };
      reader.onerror = () =>
        resolve({ isValid: false, error: "Failed to read the file." });
      reader.readAsArrayBuffer(file);
    } catch {
      resolve({ isValid: true }); // Fallback if xlsx fails to load
    }
  });
};

/**
 * Validates file size (max 25MB) and rows (max 50,000 for CSVs).
 * @param file The file to validate
 * @returns A promise resolving to the validation result
 */
export const validateFileUpload = async (
  file: File,
): Promise<FileValidationResult> => {
  if (file.size > MAX_FILE_BYTES) {
    return { isValid: false, error: "File size exceeds 25 MB limit." };
  }

  const name = file.name.toLowerCase();

  if (name.endsWith(".csv")) return parseCSV(file);
  if (name.endsWith(".json")) return parseJSON(file);
  if (name.endsWith(".xlsx") || name.endsWith(".xls")) return parseExcel(file);

  // For non-CSV/JSON/Excel files, bypass row validation
  return { isValid: true };
};

/**
 * Convenience function to easily calculate just the number of records/rows in a file.
 * @param file The file to parse
 * @returns A promise resolving to the record count
 */
export const countFileRecords = async (file: File): Promise<number> => {
  const result = await validateFileUpload(file);
  return result.rows || 0;
};
