"use client";

import { useState } from "react";
import { useEmployees, useDeleteEmployee } from "../hooks/use-employees";
import { CorporateEmployee } from "../types";
import { EmployeeDialog } from "./EmployeeDialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Plus, Search, MoreHorizontal, Pencil, Trash2, Smartphone } from "lucide-react";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";

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
    {
      key: "id",
      label: "",
      width: "80px",
      render: (_, employee) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <span className="sr-only">Open menu</span>
              <MoreHorizontal className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            <DropdownMenuItem onClick={() => handleEdit(employee)}>
              <Pencil className="mr-2 h-4 w-4" />
              Edit Settings
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem 
              onClick={() => handleDelete(employee.id)}
              className="text-red-600 focus:text-red-600"
            >
              <Trash2 className="mr-2 h-4 w-4" />
              Revoke Access
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
          title="Employee Roster"
          description="Manage employees who are authorized to book corporate rides."
        />
        <Button onClick={handleCreate} className="shrink-0">
          <Plus className="mr-2 h-4 w-4" />
          Whitelist Employee
        </Button>
      </div>

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
