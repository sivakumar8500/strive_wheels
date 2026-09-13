"use client";

import { useState } from "react";
import { User } from "../types";
import { useCreateUser, useUpdateUser } from "./useUsers";
import { UserFormData } from "../utils/formSchema";

interface UseUserFormOptions {
  onSuccess?: () => void;
}

export function useUserForm(options?: UseUserFormOptions) {
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [isOpen, setIsOpen] = useState(false);

  const createUserMutation = useCreateUser();
  const updateUserMutation = useUpdateUser();

  const openCreateDialog = () => {
    setSelectedUser(null);
    setIsOpen(true);
  };

  const openEditDialog = (user: User) => {
    setSelectedUser(user);
    setIsOpen(true);
  };

  const closeDialog = () => {
    setIsOpen(false);
    setSelectedUser(null);
  };

  const handleSubmit = async (data: UserFormData) => {
    if (selectedUser) {
      await updateUserMutation.mutateAsync({
        id: String(selectedUser.id),
        data: {
          first_name: data.first_name,
          last_name: data.last_name,
          email: data.email,
          role: data.role,
          is_active: data.is_active,
        created_at: new Date().toISOString(),
        },
      });
    } else {
      await createUserMutation.mutateAsync({
        first_name: data.first_name,
        last_name: data.last_name,
        email: data.email,
        role: data.role,
        is_active: data.is_active,
        created_at: new Date().toISOString(),
      });
    }

    closeDialog();
    options?.onSuccess?.();
  };

  return {
    selectedUser,
    isOpen,
    openCreateDialog,
    openEditDialog,
    closeDialog,
    handleSubmit,
    isLoading: createUserMutation.isPending || updateUserMutation.isPending,
  };
}
