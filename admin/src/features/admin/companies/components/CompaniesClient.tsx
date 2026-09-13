"use client";

import { useState } from "react";
import {
  useCompanies,
  useCreateCompany,
  useUpdateCompany,
} from "../hooks/use-companies";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { CompanyDialog } from "./CompanyDialog";
import { Company, CreateCompanyRequest, UpdateCompanyRequest } from "../types";
import { Button } from "@/components/ui/button";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Badge } from "@/components/ui/badge";
import { Loader2, Plus, Building2, ExternalLink, Pencil } from "lucide-react";
import Link from "next/link";

export function CompaniesClient() {
  const { data: companies, isLoading, isError, refetch } = useCompanies();
  const createMutation = useCreateCompany();
  const updateMutation = useUpdateCompany();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedCompany, setSelectedCompany] = useState<Company | null>(null);

  const handleOpenCreate = () => {
    setSelectedCompany(null);
    setDialogOpen(true);
  };

  const handleOpenEdit = (company: Company) => {
    setSelectedCompany(company);
    setDialogOpen(true);
  };

  const handleDialogSubmit = (values: CreateCompanyRequest | UpdateCompanyRequest) => {
    if (selectedCompany) {
      updateMutation.mutate(
        { id: selectedCompany.id, data: values as UpdateCompanyRequest },
        {
          onSuccess: () => setDialogOpen(false),
        }
      );
    } else {
      createMutation.mutate(values as CreateCompanyRequest, {
        onSuccess: () => setDialogOpen(false),
      });
    }
  };

  const columns: ColumnDef<Company>[] = [
    {
      key: "company_name",
      label: "Company Details",
      render: (_, company) => (
        <div className="flex items-start gap-3">
          <div className="mt-1 h-8 w-8 rounded-md bg-blue-50 border border-blue-100 flex items-center justify-center shrink-0">
            <Building2 className="h-4 w-4 text-blue-600" />
          </div>
          <div>
            <p className="font-semibold text-base">{company.company_name}</p>
            <p className="text-sm text-muted-foreground font-mono mt-0.5">
              {company.registration_number}
            </p>
            <div className="flex items-center gap-1 mt-1 text-xs text-muted-foreground">
              <Badge variant="outline" className="text-[10px] uppercase h-5 px-1.5">
                {company.billing_type}
              </Badge>
            </div>
          </div>
        </div>
      ),
    },
    {
      key: "contact_person",
      label: "Contact Point",
      render: (_, company) => (
        <div className="text-sm space-y-1">
          <p className="font-medium">{company.contact_person}</p>
          <p className="text-muted-foreground text-xs">{company.contact_email}</p>
          <p className="text-muted-foreground text-xs">{company.contact_phone}</p>
        </div>
      ),
    },
    {
      key: "credit_limit",
      label: "Financials",
      render: (_, company) => (
        <div className="text-sm space-y-1.5">
          <div className="flex justify-between items-center gap-4">
            <span className="text-muted-foreground">Credit Limit:</span>
            <span className="font-mono font-medium">
              {company.billing_type === "PREPAID" ? "-" : `$${company.credit_limit.toLocaleString()}`}
            </span>
          </div>
          <div className="flex justify-between items-center gap-4">
            <span className="text-muted-foreground">Balance:</span>
            <span className={`font-mono font-medium ${company.current_balance < 0 ? "text-red-600" : "text-green-600"}`}>
              ${company.current_balance.toLocaleString()}
            </span>
          </div>
        </div>
      ),
    },
    {
      key: "status",
      label: "Status",
      render: (_, company) => (
        <>
          {company.status === "ACTIVE" && (
            <Badge variant="default" className="bg-green-500 hover:bg-green-600">Active</Badge>
          )}
          {company.status === "SUSPENDED" && (
            <Badge variant="destructive">Suspended</Badge>
          )}
          {company.status === "INACTIVE" && (
            <Badge variant="secondary">Inactive</Badge>
          )}
        </>
      ),
    },
    {
      key: "id",
      label: "",
      width: "120px",
      render: (_, company) => (
        <div className="flex items-center justify-end gap-2">
          <Button variant="outline" size="sm" asChild>
            <Link href={`/admin/companies/${company.id}/employees`} className="text-xs">
              <ExternalLink className="mr-1 h-3 w-3" />
              Employees
            </Link>
          </Button>
          <Button variant="ghost" size="icon" onClick={() => handleOpenEdit(company)}>
            <Pencil className="h-4 w-4" />
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
        <p>Failed to load companies.</p>
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
          title="Corporate B2B Companies"
          description="Manage corporate accounts, track postpaid/prepaid billing, and review credit limits."
        />
        <Button onClick={handleOpenCreate}>
          <Plus className="mr-2 h-4 w-4" />
          Onboard Company
        </Button>
      </div>

      <DataTable
        columns={columns}
        data={companies || []}
        isLoading={false}
        emptyMessage="No corporate accounts found."
      />

      <CompanyDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        company={selectedCompany}
        onSubmit={handleDialogSubmit}
        isSubmitting={createMutation.isPending || updateMutation.isPending}
      />
    </div>
  );
}
