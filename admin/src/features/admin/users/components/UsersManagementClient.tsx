"use client";

import { useState } from "react";
import { UsersTable } from "./UsersTable";
import { useUsers } from "../hooks/useUsers";
import { useUserForm } from "../hooks/useUserForm";
import { User } from "../types";
import { UserFormDialog } from "./UserFormDialog";
import { UserDeleteDialog } from "./UserDeleteDialog";
import { UserViewDialog } from "./UserViewDialog";
import { Plus } from "lucide-react";
import { useHasHydrated } from "@/hooks/use-hydrated";
import { SuspenseLoader } from "@/components/ui/suspense-loader";
import { SuspenseError } from "@/components/ui/suspense-error";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";

export function UsersManagementClient() {
  const isMounted = useHasHydrated();
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [viewUser, setViewUser] = useState<User | null>(null);
  const [deleteUser, setDeleteUser] = useState<User | null>(null);

  const {
    data: usersData,
    isLoading,
    isError,
    refetch,
  } = useUsers({
    page,
    limit,
  });

  const {
    selectedUser,
    isOpen,
    openCreateDialog,
    openEditDialog,
    closeDialog,
    handleSubmit,
    isLoading: isFormLoading,
  } = useUserForm({
    onSuccess: () => refetch(),
  });

  const handleRowClick = (user: User) => {
    setViewUser(user);
  };

  const handleEdit = (user: User) => {
    openEditDialog(user);
  };

  const handleDelete = (user: User) => {
    setDeleteUser(user);
  };

  const handleCloseViewDialog = () => {
    setViewUser(null);
  };

  const handleCloseDeleteDialog = () => {
    setDeleteUser(null);
  };

  if (!isMounted || isLoading) {
    return (
      <SuspenseLoader
        title="Loading Users..."
        description="Please wait while we fetch the user data."
      />
    );
  }

  if (isError) {
    return <SuspenseError />;
  }

  return (
    <div className="flex flex-col gap-6">
      {/* Header */}
      <PageHeaderwithAddButton
        title="Users Management"
        description="Manage and monitor all users in your system"
        icon={<Plus className="h-4 w-4" />}
        buttonText="Add User"
        onAddButtonClick={openCreateDialog}
      />

      {/* Users Table */}
      <UsersTable
        users={usersData?.data || []}
        isLoading={isLoading}
        onRowClick={handleRowClick}
        onEdit={handleEdit}
        onDelete={handleDelete}
        currentPage={page}
        totalItems={usersData?.total || 0}
        itemsPerPage={limit}
        onPageChange={setPage}
        onItemsPerPageChange={setLimit}
      />

      {/* Form Dialog for Create/Edit */}
      <UserFormDialog
        isOpen={isOpen}
        isLoading={isFormLoading}
        user={selectedUser}
        onClose={closeDialog}
        onSubmit={handleSubmit}
      />

      {/* View User Dialog */}
      <UserViewDialog
        isOpen={!!viewUser}
        user={viewUser}
        onClose={handleCloseViewDialog}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />

      {/* Delete Confirmation Dialog */}
      <UserDeleteDialog
        isOpen={!!deleteUser}
        user={deleteUser}
        onClose={handleCloseDeleteDialog}
        onSuccess={() => {
          refetch();
          setDeleteUser(null);
        }}
      />
    </div>
  );
}
