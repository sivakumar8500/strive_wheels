"use client";

import { useState } from "react";
import {
  useQuickServices,
  useCreateQuickService,
  useUpdateQuickService,
  useDeleteQuickService,
  useReorderQuickServices,
} from "../hooks/use-quick-services";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { QuickServiceDialog } from "./QuickServiceDialog";
import { QuickService, CreateQuickServiceRequest, UpdateQuickServiceRequest } from "../types";
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
import { Loader2, Plus, MoreHorizontal, Pencil, Trash2, ArrowUp, ArrowDown } from "lucide-react";

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

    // We swap the sort_order of the two items
    const items = [...services];
    const itemA = items[currentIndex];
    const itemB = items[newIndex];

    const tempSortOrder = itemA.sort_order;
    itemA.sort_order = itemB.sort_order;
    itemB.sort_order = tempSortOrder;

    reorderMutation.mutate({
      items: [
        { id: itemA.id, sort_order: itemA.sort_order },
        { id: itemB.id, sort_order: itemB.sort_order },
      ],
    });
  };

  const columns: ColumnDef<QuickService>[] = [
    {
      key: "sort_order",
      label: "Order",
      width: "100px",
      render: (_, service) => {
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
      render: (_, service) => (
        <div className="h-10 w-10 rounded-md bg-slate-100 flex items-center justify-center p-1">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={service.icon_url} alt={service.title} className="max-h-full max-w-full object-contain" />
        </div>
      ),
    },
    {
      key: "title",
      label: "Title",
      render: (_, service) => <span className="font-medium">{service.title}</span>,
    },
    {
      key: "target_screen",
      label: "Target Screen",
      render: (_, service) => (
        <code className="text-xs bg-slate-100 px-2 py-1 rounded">
          {service.target_screen}
        </code>
      ),
    },
    {
      key: "is_active",
      label: "Status",
      render: (_, service) => (
        service.is_active ? (
          <Badge variant="default" className="bg-green-500 hover:bg-green-600">Active</Badge>
        ) : (
          <Badge variant="secondary">Inactive</Badge>
        )
      ),
    },
    {
      key: "id",
      label: "",
      width: "80px",
      render: (_, service) => (
        <div className="flex justify-end w-full">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="h-8 w-8 p-0">
                <span className="sr-only">Open menu</span>
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => handleOpenEdit(service)}>
                <Pencil className="mr-2 h-4 w-4" />
                Edit
              </DropdownMenuItem>
              <DropdownMenuItem
                onClick={() => confirmDelete(service.id)}
                className="text-red-600 focus:text-red-600 focus:bg-red-50"
              >
                <Trash2 className="mr-2 h-4 w-4" />
                Delete
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
        <p>Failed to load quick services.</p>
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
          title="Dynamic Quick Service Tiles"
          description="Manage the main action tiles displayed on the customer app home screen."
        />
        <Button onClick={handleOpenCreate}>
          <Plus className="mr-2 h-4 w-4" />
          Add New Service
        </Button>
      </div>

      <DataTable
        columns={columns}
        data={services || []}
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

      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
            <AlertDialogDescription>
              This action cannot be undone. This will permanently delete the quick service tile from the customer app.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700"
              disabled={deleteMutation.isPending}
            >
              {deleteMutation.isPending ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
