"use client";

import { useState } from "react";
import { format } from "date-fns";
import {
  useAdminUsers,
  useCreateAdminUser,
  useUpdateAdminUser,
  useDeleteAdminUser,
} from "../hooks/use-users";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { UserDialog } from "./UserDialog";
import { AdminUser, CreateAdminUserRequest, UpdateAdminUserRequest } from "../types";
import { Button } from "@/components/ui/button";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Loader2, Plus, MoreHorizontal, Pencil, Trash2, Shield, UserCog, Building } from "lucide-react";

export function UsersClient() {
  const { data: users, isLoading, isError, refetch } = useAdminUsers();
  const createMutation = useCreateAdminUser();
  const updateMutation = useUpdateAdminUser();
  const deleteMutation = useDeleteAdminUser();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState<AdminUser | null>(null);

  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [userToDelete, setUserToDelete] = useState<number | null>(null);

  const handleOpenCreate = () => {
    setSelectedUser(null);
    setDialogOpen(true);
  };

  const handleOpenEdit = (user: AdminUser) => {
    setSelectedUser(user);
    setDialogOpen(true);
  };

  const handleDialogSubmit = (values: CreateAdminUserRequest | UpdateAdminUserRequest) => {
    if (selectedUser) {
      updateMutation.mutate(
        { id: selectedUser.id, data: values as UpdateAdminUserRequest },
        {
          onSuccess: () => setDialogOpen(false),
        }
      );
    } else {
      createMutation.mutate(values as CreateAdminUserRequest, {
        onSuccess: () => setDialogOpen(false),
      });
    }
  };

  const confirmDelete = (id: number) => {
    setUserToDelete(id);
    setDeleteDialogOpen(true);
  };

  const handleDelete = () => {
    if (userToDelete !== null) {
      deleteMutation.mutate(userToDelete, {
        onSuccess: () => setDeleteDialogOpen(false),
      });
    }
  };

  const getRoleIcon = (role: string) => {
    switch (role) {
      case "SUPER_ADMIN":
        return <Shield className="h-4 w-4 text-purple-600" />;
      case "COMPANY_ADMIN":
        return <Building className="h-4 w-4 text-blue-600" />;
      default:
        return <UserCog className="h-4 w-4 text-slate-600" />;
    }
  };

  const getRoleBadgeVariant = (role: string) => {
    switch (role) {
      case "SUPER_ADMIN":
        return "bg-purple-100 text-purple-800 border-purple-200 hover:bg-purple-100";
      case "COMPANY_ADMIN":
        return "bg-blue-100 text-blue-800 border-blue-200 hover:bg-blue-100";
      default:
        return "bg-slate-100 text-slate-800 border-slate-200 hover:bg-slate-100";
    }
  };

  const columns: ColumnDef<AdminUser>[] = [
    {
      key: "first_name",
      label: "User",
      render: (_, user) => (
        <div className="flex items-center gap-3">
          <div className="h-9 w-9 rounded-full bg-slate-100 flex items-center justify-center shrink-0 font-medium text-slate-600">
            {user.first_name[0]}{user.last_name[0]}
          </div>
          <div>
            <p className="font-medium">{user.first_name} {user.last_name}</p>
            <p className="text-sm text-muted-foreground">{user.email}</p>
          </div>
        </div>
      ),
    },
    {
      key: "role",
      label: "Role",
      render: (_, user) => (
        <Badge variant="outline" className={`flex w-fit items-center gap-1.5 ${getRoleBadgeVariant(user.role)}`}>
          {getRoleIcon(user.role)}
          {user.role.replace("_", " ")}
        </Badge>
      ),
    },
    {
      key: "is_active",
      label: "Status",
      render: (_, user) => (
        user.is_active ? (
          <Badge variant="default" className="bg-green-500 hover:bg-green-600">Active</Badge>
        ) : (
          <Badge variant="secondary">Inactive</Badge>
        )
      ),
    },
    {
      key: "last_login",
      label: "Last Login",
      render: (_, user) => (
        <span className="text-sm text-muted-foreground">
          {user.last_login ? format(new Date(user.last_login), "MMM d, yyyy HH:mm") : "Never"}
        </span>
      ),
    },
    {
      key: "id",
      label: "",
      width: "80px",
      render: (_, user) => (
        <div className="flex justify-end w-full">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="h-8 w-8 p-0">
                <span className="sr-only">Open menu</span>
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => handleOpenEdit(user)}>
                <Pencil className="mr-2 h-4 w-4" />
                Edit Access
              </DropdownMenuItem>
              <DropdownMenuItem
                onClick={() => confirmDelete(user.id)}
                className="text-red-600 focus:text-red-600 focus:bg-red-50"
              >
                <Trash2 className="mr-2 h-4 w-4" />
                Revoke User
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      ),
    },
  ];

  if (isLoading) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="flex h-[400px] flex-col items-center justify-center gap-4 text-red-500">
        <p>Failed to load users.</p>
        <Button variant="outline" onClick={() => refetch()}>
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <PageHeaderwithAddButton
          title="Super Admin User Provisioning"
          description="Manage administrative accounts, assign roles (Super Admin, Admin, Company Admin), and control system access."
        />
        <Button onClick={handleOpenCreate}>
          <Plus className="mr-2 h-4 w-4" />
          Provision User
        </Button>
      </div>

      <DataTable
        columns={columns}
        data={users || []}
        isLoading={false}
        emptyMessage="No admin users found."
      />

      <UserDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        user={selectedUser}
        onSubmit={handleDialogSubmit}
        isSubmitting={createMutation.isPending || updateMutation.isPending}
      />

      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Revoke Admin Access?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete this administrative user and revoke their access to the system. This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700"
              disabled={deleteMutation.isPending}
            >
              {deleteMutation.isPending ? "Revoking..." : "Revoke Access"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
