"use client";

import { User } from "../types";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";
import {
  getRoleLabel,
  getStatusLabel,
  calculateUserInitials,
  getStatusColor,
} from "../utils/helpers";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";

interface UserViewDialogProps {
  isOpen: boolean;
  user: User | null;
  onClose: () => void;
  onEdit?: (user: User) => void;
  onDelete?: (user: User) => void;
}

export function UserViewDialog({
  isOpen,
  user,
  onClose,
  onEdit,
  onDelete,
}: UserViewDialogProps) {
  if (!user) return null;

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent showCloseButton={false} className="max-w-md">
        <DialogHeader className="flex flex-row items-center justify-between">
          <DialogTitle>User Details</DialogTitle>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-lg bg-slate-50 text-slate-500 hover:bg-slate-100"
            onClick={onClose}
          >
            <X className="h-4 w-4" />
          </Button>
        </DialogHeader>

        <div className="space-y-6">
          {/* User Avatar and Name */}
          <div className="flex items-center gap-4">
            <Avatar className="h-16 w-16">
              <AvatarFallback className="bg-blue-100 text-blue-600 font-bold">
                {calculateUserInitials(`${user.first_name} ${user.last_name}`)}
              </AvatarFallback>
            </Avatar>
            <div>
              <h3 className="font-semibold text-lg">{`${user.first_name} ${user.last_name}`}</h3>
              <p className="text-sm text-muted-foreground">{user.email}</p>
            </div>
          </div>

          {/* User Details Grid */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Role
              </label>
              <p className="text-sm font-medium capitalize">
                {getRoleLabel(user.role)}
              </p>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Status
              </label>
              <Badge className={`${getStatusColor((user.is_active ? "Active" : "Inactive"))} capitalize`}>
                {getStatusLabel((user.is_active ? "Active" : "Inactive"))}
              </Badge>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Joined
              </label>
              <p className="text-sm font-medium">
                {new Date(user.created_at).toLocaleDateString()}
              </p>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Last Login
              </label>
              <p className="text-sm font-medium">
                {user.last_login
                  ? new Date(user.last_login).toLocaleDateString()
                  : "Never"}
              </p>
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-2 pt-4">
            {onEdit && (
              <Button
                variant="outline"
                className="flex-1"
                onClick={() => {
                  onEdit(user);
                  onClose();
                }}
              >
                Edit
              </Button>
            )}
            {onDelete && (
              <Button
                variant="destructive"
                className="flex-1"
                onClick={() => {
                  onDelete(user);
                  onClose();
                }}
              >
                Delete
              </Button>
            )}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
