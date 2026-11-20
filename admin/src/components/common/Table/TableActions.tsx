import React from "react";
import { EditIcon, DeleteIcon, ViewIcon } from "@/icons";
import { ActionDef } from "./DataTable";

export interface ActionConfig<T> {
  onView?: (item: T) => void;
  onEdit?: (item: T) => void;
  onDelete?: (item: T) => void;
  customActions?: ActionDef<T>[];
}

export function getStandardTableActions<T>(
  config: ActionConfig<T>,
): ActionDef<T>[] {
  const actions: ActionDef<T>[] = [];

  if (config.onView) {
    actions.push({
      icon: <ViewIcon className="h-4 w-4" />,
      onClick: config.onView,
      className:
        "bg-white text-primary hover:bg-primary/5 rounded-md p-2 transition-all border border-slate-100 shadow-sm",
    });
  }

  if (config.onEdit) {
    actions.push({
      icon: <EditIcon className="h-4 w-4" />,
      onClick: config.onEdit,
      className:
        "bg-white text-slate-400 hover:text-slate-600 rounded-md p-2 transition-all border border-slate-100 shadow-sm",
    });
  }

  if (config.onDelete) {
    actions.push({
      icon: <DeleteIcon className="h-4 w-4" />,
      onClick: config.onDelete,
      className:
        "bg-[#FFF5F5] text-[#FF4D4D] hover:bg-[#FFEBEB] rounded-md p-2 transition-all border border-[#FFE0E0] shadow-sm",
    });
  }

  if (config.customActions) {
    actions.push(...config.customActions);
  }

  return actions;
}
