"use client";

import { useState } from "react";
import { DataTable } from "@/components/common/Table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Plus } from "lucide-react";
import {
  useVehicleTypes,
  useCreateVehicleType,
  useUpdateVehicleType,
  useDeleteVehicleType,
} from "../hooks/use-vehicle-types";
import { VehicleTypeFormDialog } from "./VehicleTypeFormDialog";
import { VehicleType, CreateVehicleTypeDto } from "../types";

export function VehicleTypesClient() {
  const { data: vehicleTypes, isLoading } = useVehicleTypes();
  const createMutation = useCreateVehicleType();
  const updateMutation = useUpdateVehicleType();
  const deleteMutation = useDeleteVehicleType();

  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<VehicleType | null>(null);
  
  // For simplicity, using native confirm for delete, but normally use a DeleteDialog
  const handleDelete = async (row: VehicleType) => {
    if (confirm(`Are you sure you want to deactivate ${row.name}?`)) {
      await deleteMutation.mutateAsync(row.id);
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
      label: "Edit",
      onClick: handleEdit,
    },
    {
      label: "Deactivate",
      onClick: handleDelete,
      isDestructive: true,
    },
  ];

  return (
    <div className="space-y-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Vehicle Types</h1>
          <p className="text-muted-foreground">
            Manage the vehicle categories available on the platform.
          </p>
        </div>
        <Button onClick={handleCreateNew}>
          <Plus className="mr-2 h-4 w-4" /> Add Vehicle Type
        </Button>
      </div>

      <DataTable
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
    </div>
  );
}
