"use client";

import { useState } from "react";
import { useCompanyRiders, useDeleteCompanyRider } from "../hooks/use-riders";
import { CompanyRider } from "../types";
import { RiderDialog } from "./RiderDialog";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Plus, Search, MoreHorizontal, Pencil, Trash2, Calendar, MapPin } from "lucide-react";
import { format, isBefore, parseISO } from "date-fns";

export function CompanyRidersClient() {
  const { data: riders, isLoading } = useCompanyRiders();
  const { mutate: deleteRider } = useDeleteCompanyRider();
  
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedRider, setSelectedRider] = useState<CompanyRider | null>(null);

  const filteredRiders = riders?.filter((rider) =>
    rider.driver_name.toLowerCase().includes(search.toLowerCase()) ||
    rider.route_assigned.toLowerCase().includes(search.toLowerCase()) ||
    rider.phone.includes(search)
  );

  const handleEdit = (rider: CompanyRider) => {
    setSelectedRider(rider);
    setDialogOpen(true);
  };

  const handleCreate = () => {
    setSelectedRider(null);
    setDialogOpen(true);
  };

  const handleDelete = (id: number) => {
    if (confirm("Are you sure you want to terminate this dedicated route assignment?")) {
      deleteRider(id);
    }
  };

  const getStatusBadge = (status: string, endDateStr: string) => {
    if (status === "TERMINATED") return <Badge variant="destructive">Terminated</Badge>;
    if (status === "EXPIRED" || isBefore(parseISO(endDateStr), new Date())) {
      return <Badge variant="secondary">Expired</Badge>;
    }
    return <Badge variant="default">Active</Badge>;
  };

  const columns: ColumnDef<CompanyRider>[] = [
    {
      key: "driver_name",
      label: "Driver Details",
      render: (_, rider) => (
        <div>
          <div className="font-medium">{rider.driver_name}</div>
          <div className="text-sm text-muted-foreground">{rider.phone}</div>
        </div>
      ),
    },
    {
      key: "route_assigned",
      label: "Assigned Route",
      render: (_, rider) => (
        <div className="flex items-center gap-2">
          <MapPin className="h-4 w-4 text-muted-foreground shrink-0" />
          <span className="font-medium max-w-[200px] truncate" title={rider.route_assigned}>
            {rider.route_assigned}
          </span>
        </div>
      ),
    },
    {
      key: "start_date",
      label: "Contract Period",
      render: (_, rider) => (
        <div className="flex items-center gap-2 text-sm text-muted-foreground">
          <Calendar className="h-4 w-4" />
          <span>
            {format(parseISO(rider.start_date), "MMM d, yyyy")} - {format(parseISO(rider.end_date), "MMM d, yyyy")}
          </span>
        </div>
      ),
    },
    {
      key: "status",
      label: "Status",
      render: (_, rider) => getStatusBadge(rider.status, rider.end_date),
    },
    {
      key: "id",
      label: "",
      width: "80px",
      render: (_, rider) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <span className="sr-only">Open menu</span>
              <MoreHorizontal className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            <DropdownMenuItem onClick={() => handleEdit(rider)}>
              <Pencil className="mr-2 h-4 w-4" />
              Edit Assignment
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem 
              onClick={() => handleDelete(rider.id)}
              className="text-red-600 focus:text-red-600"
            >
              <Trash2 className="mr-2 h-4 w-4" />
              Terminate
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <PageHeaderwithAddButton
          title="Company Riders"
          description="Manage dedicated drivers and cabs assigned to specific corporate routes."
        />
        <Button onClick={handleCreate} className="shrink-0">
          <Plus className="mr-2 h-4 w-4" />
          Assign Rider
        </Button>
      </div>

      <div className="flex items-center">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search by driver, phone, or route..."
            className="pl-8"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <DataTable
        columns={columns}
        data={filteredRiders || []}
        isLoading={isLoading}
        emptyMessage="No assigned riders found."
      />

      <RiderDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        rider={selectedRider}
      />
    </div>
  );
}
