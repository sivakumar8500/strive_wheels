"use client";

import { useState, useMemo } from "react";
import {
  useQuickServices,
  useCreateQuickService,
  useUpdateQuickService,
  useDeleteQuickService,
  useReorderQuickServices,
} from "../hooks/use-quick-services";
import PageHeader from "@/components/shared/PageHeader";
import { QuickServiceDialog } from "./QuickServiceDialog";
import { QuickService, CreateQuickServiceRequest, UpdateQuickServiceRequest } from "../types";
import { Button } from "@/components/ui/button";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Badge } from "@/components/ui/badge";
import DeleteDialog from "@/components/shared/DeleteDialog";
import { Loader2, ArrowUp, ArrowDown } from "lucide-react";
import { EditIcon, DeleteIcon } from "@/icons";

export function QuickServicesClient() {
  const { data: services, isLoading, isError, refetch } = useQuickServices();
  const createMutation = useCreateQuickService();
  const updateMutation = useUpdateQuickService();
  const deleteMutation = useDeleteQuickService();
  const reorderMutation = useReorderQuickServices();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedService, setSelectedService] = useState<QuickService | null>(null);

  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [serviceToDelete, setServiceToDelete] = useState<number | null>(null);

  const handleOpenCreate = () => {
    setSelectedService(null);
    setDialogOpen(true);
  };

  const handleOpenEdit = (service: QuickService) => {
    setSelectedService(service);
    setDialogOpen(true);
  };

  const handleDialogSubmit = (values: CreateQuickServiceRequest) => {
    if (selectedService) {
      updateMutation.mutate(
        { id: selectedService.id, data: values as UpdateQuickServiceRequest },
        {
          onSuccess: () => setDialogOpen(false),
        }
      );
    } else {
      createMutation.mutate(values, {
        onSuccess: () => setDialogOpen(false),
      });
    }
  };

  const confirmDelete = (id: number) => {
    setServiceToDelete(id);
    setDeleteDialogOpen(true);
  };

  const handleDelete = () => {
    if (serviceToDelete !== null) {
      deleteMutation.mutate(serviceToDelete, {
        onSuccess: () => setDeleteDialogOpen(false),
      });
    }
  };

  const handleReorder = (currentIndex: number, direction: "up" | "down") => {
    if (!services) return;
    const newIndex = direction === "up" ? currentIndex - 1 : currentIndex + 1;
    if (newIndex < 0 || newIndex >= services.length) return;

    // We swap the display_order of the two items
    const items = [...services];
    const itemA = { ...items[currentIndex] };
    const itemB = { ...items[newIndex] };

    const tempDisplayOrder = itemA.display_order;
    itemA.display_order = itemB.display_order;
    itemB.display_order = tempDisplayOrder;

    reorderMutation.mutate({
      items: [itemA, itemB],
    });
  };

  const columns: ColumnDef<QuickService>[] = [
    {
      key: "display_order" as const,
      label: "Order",
      width: "100px",
      render: (_: any, service: QuickService) => {
        const index = services?.findIndex((s) => s.id === service.id) ?? -1;
        return (
          <div className="flex items-center space-x-1">
            <Button
              variant="ghost"
              size="icon"
              className="h-8 w-8"
              disabled={index <= 0 || reorderMutation.isPending}
              onClick={() => handleReorder(index, "up")}
            >
              <ArrowUp className="h-4 w-4" />
            </Button>
            <Button
              variant="ghost"
              size="icon"
              className="h-8 w-8"
              disabled={index === -1 || index === (services?.length ?? 0) - 1 || reorderMutation.isPending}
              onClick={() => handleReorder(index, "down")}
            >
              <ArrowDown className="h-4 w-4" />
            </Button>
          </div>
        );
      },
    },
    {
      key: "icon_url",
      label: "Icon",
      render: (_: any, service: QuickService) => (
        <div className="h-10 w-10 rounded-md bg-slate-100 flex items-center justify-center p-1">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          {service.icon_url && <img src={service.icon_url} alt={service.title} className="max-h-full max-w-full object-contain" />}
        </div>
      ),
    },
    {
      key: "title",
      label: "Title",
      render: (_: any, service: QuickService) => <span className="font-medium">{service.title}</span>,
    },
    {
      key: "service_code" as const,
      label: "Service Code",
      render: (_: any, service: QuickService) => (
        <code className="text-xs bg-slate-100 px-2 py-1 rounded">
          {service.service_code}
        </code>
      ),
    },
    {
      key: "is_active",
      label: "Status",
      render: (_: any, service: QuickService) => (
        service.is_active ? (
          <Badge variant="default" className="bg-green-500 hover:bg-green-600">Active</Badge>
        ) : (
          <Badge variant="secondary">Inactive</Badge>
        )
      ),
    },
  ];

  const actions = useMemo(
    () => [
      {
        icon: <EditIcon className="h-4 w-4" />,
        onClick: (service: QuickService) => handleOpenEdit(service),
        className: "text-blue-600 hover:text-blue-700",
      },
      {
        icon: <DeleteIcon className="h-4 w-4" />,
        onClick: (service: QuickService) => confirmDelete(service.id),
        className: "text-red-600 hover:text-red-700",
      },
    ],
    []
  );

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
        <p>Failed to load quick services.</p>
        <Button variant="outline" onClick={() => refetch()}>
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Dynamic Quick Service Tiles"
        description="Manage the main action tiles displayed on the customer app home screen."
        onAddButtonClick={handleOpenCreate}
        buttonText="Add New Service"
      />

      <DataTable
        maxHeight="calc(90vh - 210px)"
        columns={columns}
        data={services || []}
        actions={actions.length > 0 ? actions : undefined}
        isLoading={false}
        emptyMessage="No quick services found."
      />

      <QuickServiceDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        service={selectedService}
        onSubmit={handleDialogSubmit}
        isSubmitting={createMutation.isPending || updateMutation.isPending}
      />

      <DeleteDialog
        isOpen={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
        onConfirm={handleDelete}
        entityLabel="quick service"
      />
    </div>
  );
}
