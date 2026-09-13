"use client";

import { useState } from "react";
import { useDriverApplications } from "../hooks/use-drivers";
import { DriverRegistration } from "../types";
import { KycReviewDialog } from "./KycReviewDialog";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Loader2, Eye, RefreshCcw } from "lucide-react";
import { format } from "date-fns";

export function DriverRegistrationsClient() {
  const [selectedDriver, setSelectedDriver] = useState<DriverRegistration | null>(null);
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  const { data: drivers, isLoading, isError, refetch } = useDriverApplications();

  const handleViewDetails = (driver: DriverRegistration) => {
    setSelectedDriver(driver);
    setIsDialogOpen(true);
  };

  const columns: ColumnDef<DriverRegistration>[] = [
    {
      key: "id",
      label: "ID",
      render: (_, driver) => <span className="font-medium">#{driver.id}</span>,
    },
    {
      key: "personal_info",
      label: "Applicant",
      render: (_, driver) => (
        <div className="flex flex-col">
          <span>{driver.personal_info.first_name} {driver.personal_info.last_name}</span>
          <span className="text-xs text-muted-foreground">{driver.personal_info.mobile_number}</span>
        </div>
      ),
    },
    {
      key: "vehicle_details",
      label: "Vehicle",
      render: (_, driver) => (
        <div className="flex flex-col">
          <span>{driver.vehicle_details.make} {driver.vehicle_details.model}</span>
          <span className="text-xs text-muted-foreground">{driver.vehicle_details.plate_number}</span>
        </div>
      ),
    },
    {
      key: "submitted_at",
      label: "Submitted At",
      render: (_, driver) => format(new Date(driver.submitted_at), "PPp"),
    },
    {
      key: "status",
      label: "Status",
      render: (_, driver) => (
        <Badge
          variant={
            driver.status === "APPROVED"
              ? "default"
              : driver.status === "REJECTED"
              ? "destructive"
              : "secondary"
          }
        >
          {driver.status}
        </Badge>
      ),
    },
    {
      key: "id",
      label: "",
      width: "120px",
      render: (_, driver) => (
        <div className="flex justify-end">
          <Button
            variant="outline"
            size="sm"
            onClick={() => handleViewDetails(driver)}
          >
            <Eye className="w-4 h-4 mr-2" />
            View KYC
          </Button>
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
        <p>Failed to load driver registrations.</p>
        <Button variant="outline" onClick={() => refetch()}>
          <RefreshCcw className="mr-2 h-4 w-4" />
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PageHeaderwithAddButton
        title="Driver Onboarding & KYC"
        description="Review driver applications, verify documents, and approve accounts."
      />

      <DataTable
        columns={columns}
        data={drivers || []}
        isLoading={false}
        emptyMessage="No applications found."
      />

      <KycReviewDialog
        driver={selectedDriver}
        isOpen={isDialogOpen}
        onClose={() => {
          setIsDialogOpen(false);
          setSelectedDriver(null);
        }}
      />
    </div>
  );
}
