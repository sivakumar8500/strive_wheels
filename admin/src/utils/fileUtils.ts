// extract the first row column names and remove the Id columns
export const getColumnNames = (data: unknown) => {
  if (!Array.isArray(data) || data.length === 0) {
    return [];
  }

  return Object.keys(data[0] as object);
};
