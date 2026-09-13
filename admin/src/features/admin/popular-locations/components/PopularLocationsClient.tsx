"use client";

import { useState } from "react";
import {
  usePopularLocations,
  useCreatePopularLocation,
  useUpdatePopularLocation,
  useDeletePopularLocation,
} from "../hooks/use-popular-locations";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { PopularLocationDialog } from "./PopularLocationDialog";
import { PopularLocation, CreatePopularLocationRequest, UpdatePopularLocationRequest } from "../types";
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
import { Loader2, Plus, MoreHorizontal, Pencil, Trash2, MapPin } from "lucide-react";

export function PopularLocationsClient() {
  const { data: locations, isLoading, isError, refetch } = usePopularLocations();
  const createMutation = useCreatePopularLocation();
  const updateMutation = useUpdatePopularLocation();
  const deleteMutation = useDeletePopularLocation();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedLocation, setSelectedLocation] = useState<PopularLocation | null>(null);

  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [locationToDelete, setLocationToDelete] = useState<number | null>(null);

  const handleOpenCreate = () => {
    setSelectedLocation(null);
    setDialogOpen(true);
  };

  const handleOpenEdit = (location: PopularLocation) => {
    setSelectedLocation(location);
    setDialogOpen(true);
  };

  const handleDialogSubmit = (values: CreatePopularLocationRequest) => {
    if (selectedLocation) {
      updateMutation.mutate(
        { id: selectedLocation.id, data: values as UpdatePopularLocationRequest },
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
    setLocationToDelete(id);
    setDeleteDialogOpen(true);
  };

  const handleDelete = () => {
    if (locationToDelete !== null) {
      deleteMutation.mutate(locationToDelete, {
        onSuccess: () => setDeleteDialogOpen(false),
      });
    }
  };

  const columns: ColumnDef<PopularLocation>[] = [
    {
      key: "name",
      label: "Location",
      render: (_, location) => (
        <div className="flex items-start gap-3">
          <div className="mt-1 h-8 w-8 rounded-full bg-slate-100 flex items-center justify-center shrink-0">
            <MapPin className="h-4 w-4 text-slate-500" />
          </div>
          <div>
            <p className="font-medium">{location.name}</p>
            <p className="text-sm text-muted-foreground">{location.address}</p>
          </div>
        </div>
      ),
    },
    {
      key: "category",
      label: "Category",
      render: (_, location) => (
        <Badge variant="outline">{location.category}</Badge>
      ),
    },
    {
      key: "latitude",
      label: "Coordinates (Lat, Lng)",
      render: (_, location) => (
        <span className="text-sm text-muted-foreground font-mono">
          {location.latitude.toFixed(4)}, {location.longitude.toFixed(4)}
        </span>
      ),
    },
    {
      key: "is_active",
      label: "Status",
      render: (_, location) => (
        location.is_active ? (
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
      render: (_, location) => (
        <div className="flex justify-end w-full">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="h-8 w-8 p-0">
                <span className="sr-only">Open menu</span>
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => handleOpenEdit(location)}>
                <Pencil className="mr-2 h-4 w-4" />
                Edit
              </DropdownMenuItem>
              <DropdownMenuItem
                onClick={() => confirmDelete(location.id)}
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
        <p>Failed to load popular locations.</p>
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
          title="Popular Destination Locations"
          description="Manage quick-select destinations for users to easily select during ride booking."
        />
        <Button onClick={handleOpenCreate}>
          <Plus className="mr-2 h-4 w-4" />
          Add New Location
        </Button>
      </div>

      <DataTable
        columns={columns}
        data={locations || []}
        isLoading={false}
        emptyMessage="No popular locations found."
      />

      <PopularLocationDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        location={selectedLocation}
        onSubmit={handleDialogSubmit}
        isSubmitting={createMutation.isPending || updateMutation.isPending}
      />

      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
            <AlertDialogDescription>
              This action cannot be undone. This will permanently delete the popular location shortcut.
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
