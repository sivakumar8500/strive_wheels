export const getStatusColor = (status: string) => {
  switch (status) {
    case "completed":
      return "bg-green-50 text-green-600 border-green-100";
    case "confirmed":
      return "bg-blue-50 text-blue-600 border-blue-100";
    case "cancelled":
      return "bg-red-50 text-red-600 border-red-100";
    case "pending":
      return "bg-yellow-50 text-yellow-600 border-yellow-100";
    default:
      return "bg-slate-50 text-slate-600 border-slate-100";
  }
};
