"use client";

import { useState } from "react";
import { DataTable } from "@/components/common/Table";
import { Badge } from "@/components/ui/badge";
import { Plus } from "lucide-react";
import { EditIcon, DeleteIcon } from "@/icons";
import {
  useVehicleTypes,
  useCreateVehicleType,
  useUpdateVehicleType,
  useDeleteVehicleType,
} from "../hooks/use-vehicle-types";
import { VehicleTypeFormDialog } from "./VehicleTypeFormDialog";
import { VehicleType, CreateVehicleTypeDto } from "../types";
import PageHeader from "@/components/shared/PageHeader";
import DeleteDialog from "@/components/shared/DeleteDialog";

export function VehicleTypesClient() {
  const { data: vehicleTypes, isLoading } = useVehicleTypes();
  const createMutation = useCreateVehicleType();
  const updateMutation = useUpdateVehicleType();
  const deleteMutation = useDeleteVehicleType();

  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<VehicleType | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [itemToDelete, setItemToDelete] = useState<VehicleType | null>(null);

  const confirmDelete = (row: VehicleType) => {
    setItemToDelete(row);
    setDeleteDialogOpen(true);
  };

  const handleDelete = async () => {
    if (itemToDelete) {
      await deleteMutation.mutateAsync(itemToDelete.id);
      setDeleteDialogOpen(false);
      setItemToDelete(null);
    }
  };

  const handleEdit = (row: VehicleType) => {
    setEditingItem(row);
    setIsDialogOpen(true);
  };

  const handleCreateNew = () => {
    setEditingItem(null);
    setIsDialogOpen(true);
  };

  const handleSubmitForm = async (data: CreateVehicleTypeDto) => {
    if (editingItem) {
      await updateMutation.mutateAsync({ id: editingItem.id, data });
    } else {
      await createMutation.mutateAsync(data);
    }
    setIsDialogOpen(false);
  };

  const columns = [
    {
      key: "icon_url" as const,
      label: "Icon",
      render: (value: string) => (
        <div className="flex h-10 w-10 items-center justify-center rounded-lg border bg-muted/50 p-1 overflow-hidden">
          {value ? (
            <>
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={value} alt="Vehicle Icon" className="h-full w-full object-contain" />
            </>
          ) : (
            <span className="text-xs text-muted-foreground">N/A</span>
          )}
        </div>
      ),
    },
    { key: "code" as const, label: "Code" },
    { key: "name" as const, label: "Name" },
    {
      key: "max_passengers" as const,
      label: "Passengers",
    },
    {
      key: "is_active" as const,
      label: "Status",
      render: (value: boolean) => (
        <Badge variant={value ? "default" : "destructive"}>
          {value ? "Active" : "Inactive"}
        </Badge>
      ),
    },
  ];

  const actions = [
    {
      icon: <EditIcon className="h-4 w-4" />,
      onClick: handleEdit,
      className: "text-blue-600 hover:text-blue-700",
    },
    {
      icon: <DeleteIcon className="h-4 w-4" />,
      onClick: confirmDelete,
      className: "text-red-600 hover:text-red-700",
    },
  ];

  return (
    <div className="space-y-6">
      <PageHeader
        title="Vehicle Types"
        description="Manage the vehicle categories available on the platform."
        buttonText="Add Vehicle Type"
        icon={<Plus className="mr-2 h-4 w-4" />}
        onAddButtonClick={handleCreateNew}
      />

      <DataTable
        maxHeight="calc(90vh - 210px)"
        columns={columns}
        data={vehicleTypes || []}
        actions={actions}
        isLoading={isLoading}
        itemsPerPage={10}
        showCard={true}
      />

      <VehicleTypeFormDialog
        open={isDialogOpen}
        onOpenChange={setIsDialogOpen}
        initialData={editingItem}
        onSubmit={handleSubmitForm}
        isSubmitting={createMutation.isPending || updateMutation.isPending}
      />

      <DeleteDialog
        isOpen={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
        onConfirm={handleDelete}
        title={`Deactivate ${itemToDelete?.name}?`}
        message={`Are you sure you want to deactivate the vehicle type ${itemToDelete?.name}? This action can be undone later by re-activating it.`}
      />
    </div>
  );
}
