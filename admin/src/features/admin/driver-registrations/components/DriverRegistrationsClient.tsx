"use client";


import { useDriverApplications } from "../hooks/use-drivers";
import { useRouter } from "next/navigation";
import PageHeader from "@/components/shared/PageHeader";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Loader2, Eye, RefreshCcw } from "lucide-react";
import { format } from "date-fns";
import { DriverRegistrationSummary } from "../types";

export function DriverRegistrationsClient() {
  const router = useRouter();

  const { data: drivers, isLoading, isError, refetch } = useDriverApplications();

  const handleViewDetails = (driver: DriverRegistrationSummary) => {
    router.push(`/admin/driver-registrations/${driver.registration_id}`);
  };

  const columns: ColumnDef<DriverRegistrationSummary>[] = [
    {
      key: "registration_id",
      label: "ID",
      render: (_: any, driver: DriverRegistrationSummary) => <span className="font-medium">#{driver.registration_id}</span>,
    },
    {
      key: "driver_name",
      label: "Applicant",
      render: (_: any, driver: DriverRegistrationSummary) => (
        <div className="flex flex-col">
          <span>{driver.driver_name}</span>
          <span className="text-xs text-muted-foreground">{driver.phone}</span>
        </div>
      ),
    },
    {
      key: "vehicle",
      label: "Vehicle",
      render: (_: any, driver: DriverRegistrationSummary) => (
        <div className="flex flex-col">
          <span>{driver.vehicle}</span>
        </div>
      ),
    },
    {
      key: "submitted_at",
      label: "Submitted At",
      render: (_: any, driver: DriverRegistrationSummary) => driver.submitted_at ? format(new Date(driver.submitted_at), "PPp") : "N/A",
    },
    {
      key: "status",
      label: "Status",
      render: (_: any, driver: DriverRegistrationSummary) => (
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
      <PageHeader
        title="Driver Onboarding & KYC"
        description="Review driver applications, verify documents, and approve accounts."
      />

      <DataTable
        maxHeight="calc(90vh - 230px)"
        columns={columns}
        data={drivers || []}
        actions={() => [
          {
            label: "View KYC",
            icon: <Eye className="w-4 h-4 mr-2" />,
            onClick: (r) => handleViewDetails(r),
            className: "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors border border-slate-200 bg-white shadow-sm hover:bg-slate-100 hover:text-slate-900 h-8 px-3"
          }
        ]}
        isLoading={false}
        emptyMessage="No applications found."
      />

    </div>
  );
}
