"use client";

import { User } from "../types";
import { useDeleteUser } from "../hooks/useUsers";
import DeleteDialog from "@/components/shared/DeleteDialog";

interface UserDeleteDialogProps {
  isOpen: boolean;
  user: User | null;
  onClose: () => void;
  onSuccess?: () => void;
}

export function UserDeleteDialog({
  isOpen,
  user,
  onClose,
  onSuccess,
}: UserDeleteDialogProps) {
  const deleteUserMutation = useDeleteUser();

  const handleConfirm = async () => {
    if (!user) return;

    try {
      await deleteUserMutation.mutateAsync(String(user.id));
      onClose();
      onSuccess?.();
    } catch {}
  };

  return (
    <DeleteDialog
      isOpen={isOpen}
      onClose={onClose}
      onConfirm={handleConfirm}
      entityLabel="user"
      entityName={user ? `${user.first_name} ${user.last_name}` : ""}
      title="Delete User"
      message={`Are you sure you want to delete ${user ? `${user.first_name} ${user.last_name}` : ""}? This action cannot be undone.`}
    />
  );
}
