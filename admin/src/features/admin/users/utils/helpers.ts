import { User } from "../types";

export function formatUserForForm(user: User) {
  return {
    first_name: user.first_name,
    last_name: user.last_name,
    email: user.email,
    role: user.role,
    is_active: user.is_active,
  };
}

export function calculateUserInitials(name: string): string {
  return name
    .split(" ")
    .map((word) => word[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);
}

export function getStatusLabel(status: string): string {
  const labels: Record<string, string> = {
    active: "Active",
    inactive: "Inactive",
    pending: "Pending",
  };
  return labels[status] || status;
}

export function getRoleLabel(role: string): string {
  const labels: Record<string, string> = {
    admin: "Administrator",
    moderator: "Moderator",
    user: "User",
  };
  return labels[role] || role;
}

export function getStatusColor(status: string): string {
  switch (status) {
    case "active":
      return "bg-green-50 text-green-600 border-green-100";
    case "inactive":
      return "bg-red-50 text-red-600 border-red-100";
    case "pending":
      return "bg-yellow-50 text-yellow-600 border-yellow-100";
    default:
      return "bg-slate-50 text-slate-600 border-slate-100";
  }
}
