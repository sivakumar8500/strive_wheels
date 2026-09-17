"use client";

import { useState, useMemo } from "react";
import { useEmployees, useDeleteEmployee } from "../hooks/use-employees";
import { CorporateEmployee } from "../types";
import { EmployeeDialog } from "./EmployeeDialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Plus, Search, Pencil, Trash2, Smartphone } from "lucide-react";
import PageHeader from "@/components/shared/PageHeader";

export function EmployeeRosterClient() {
  const { data: employees, isLoading } = useEmployees();
  const { mutate: deleteEmployee } = useDeleteEmployee();
  
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedEmployee, setSelectedEmployee] = useState<CorporateEmployee | null>(null);

  const filteredEmployees = employees?.filter((emp) =>
    emp.name.toLowerCase().includes(search.toLowerCase()) ||
    emp.phone.includes(search) ||
    emp.employee_code?.toLowerCase().includes(search.toLowerCase())
  );

  const handleEdit = (employee: CorporateEmployee) => {
    setSelectedEmployee(employee);
    setDialogOpen(true);
  };

  const handleCreate = () => {
    setSelectedEmployee(null);
    setDialogOpen(true);
  };

  const handleDelete = (id: number) => {
    if (confirm("Are you sure you want to revoke this employee's corporate access?")) {
      deleteEmployee(id);
    }
  };

  const columns: ColumnDef<CorporateEmployee>[] = [
    {
      key: "name",
      label: "Employee",
      render: (_, employee) => (
        <div>
          <div className="font-medium">{employee.name}</div>
          <div className="text-xs text-muted-foreground">
            {employee.employee_code || "No Code"}
          </div>
        </div>
      ),
    },
    {
      key: "phone",
      label: "Phone Link",
      render: (_, employee) => (
        <div className="flex items-center gap-2">
          <Smartphone className="h-4 w-4 text-muted-foreground" />
          <span className="font-mono text-sm">{employee.phone}</span>
          {employee.user_id ? (
            <Badge variant="secondary" className="text-[10px] uppercase">Linked</Badge>
          ) : (
            <Badge variant="outline" className="text-[10px] uppercase text-orange-600 border-orange-200">Pending</Badge>
          )}
        </div>
      ),
    },
    {
      key: "amount_spent",
      label: "Budget Usage",
      render: (_, employee) => {
        const spendPercentage = (employee.amount_spent / employee.spending_limit) * 100;
        const isOverBudget = employee.amount_spent >= employee.spending_limit;
        
        return (
          <div className="w-[200px] space-y-2">
            <div className="flex justify-between text-xs">
              <span className="font-medium">${employee.amount_spent.toLocaleString()}</span>
              <span className="text-muted-foreground">/ ${employee.spending_limit.toLocaleString()}</span>
            </div>
            <Progress 
              value={Math.min(spendPercentage, 100)} 
              className={`h-2 ${isOverBudget ? "[&>div]:bg-red-600" : spendPercentage > 80 ? "[&>div]:bg-orange-500" : "[&>div]:bg-emerald-500"}`} 
            />
          </div>
        );
      },
    },
    {
      key: "status",
      label: "Status",
      render: (_, employee) => (
        <Badge variant={employee.status === "ACTIVE" ? "default" : "secondary"}>
          {employee.status}
        </Badge>
      ),
    },
  ];

  const actions = useMemo(
    () => [
      {
        icon: <Pencil className="h-4 w-4" />,
        onClick: (employee: CorporateEmployee) => handleEdit(employee),
        className: "text-blue-600 hover:text-blue-700",
      },
      {
        icon: <Trash2 className="h-4 w-4" />,
        onClick: (employee: CorporateEmployee) => handleDelete(employee.id),
        className: "text-red-600 hover:text-red-700",
      },
    ],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    []
  );

  return (
    <div className="space-y-6">
      <PageHeader
        title="Employee Roster"
        description="Manage employees who are authorized to book corporate rides."
        actionMenu={
          <Button onClick={handleCreate} className="shrink-0">
            <Plus className="mr-2 h-4 w-4" />
            Whitelist Employee
          </Button>
        }
      />

      <div className="flex items-center">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search by name, phone, or code..."
            className="pl-8"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <DataTable
        columns={columns}
        data={filteredEmployees || []}
        actions={actions.length > 0 ? actions : undefined}
        isLoading={isLoading}
        emptyMessage="No employees found."
      />

      <EmployeeDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        employee={selectedEmployee}
      />
    </div>
  );
}
