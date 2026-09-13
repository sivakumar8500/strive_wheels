import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { CorporateEmployee, CreateEmployeeRequest } from "../types";
import { useCreateEmployee, useUpdateEmployee } from "../hooks/use-employees";

interface EmployeeDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  employee?: CorporateEmployee | null;
}

export function EmployeeDialog({ open, onOpenChange, employee }: EmployeeDialogProps) {
  const isEditing = !!employee;
  
  const [formData, setFormData] = useState<CreateEmployeeRequest>({
    employee_code: "",
    name: "",
    phone: "",
    spending_limit: 0,
    status: "ACTIVE",
  });

  const { mutate: createEmployee, isPending: isCreating } = useCreateEmployee();
  const { mutate: updateEmployee, isPending: isUpdating } = useUpdateEmployee();

  useEffect(() => {
    if (employee && open) {
      setFormData({
        employee_code: employee.employee_code || "",
        name: employee.name,
        phone: employee.phone,
        spending_limit: employee.spending_limit,
        status: employee.status,
      });
    } else if (open && !employee) {
      setFormData({
        employee_code: "",
        name: "",
        phone: "",
        spending_limit: 0,
        status: "ACTIVE",
      });
    }
  }, [employee, open]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (isEditing && employee) {
      updateEmployee(
        { id: employee.id, data: formData },
        {
          onSuccess: () => {
            onOpenChange(false);
          },
        }
      );
    } else {
      createEmployee(formData, {
        onSuccess: () => {
          onOpenChange(false);
        },
      });
    }
  };

  const isPending = isCreating || isUpdating;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>{isEditing ? "Edit Employee" : "Whitelist Employee"}</DialogTitle>
          <DialogDescription>
            {isEditing
              ? "Update corporate commute privileges for this employee."
              : "Add an employee to your corporate roster. They will be able to book rides using their registered phone number."}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit}>
          <div className="grid gap-4 py-4">
            <div className="grid gap-2">
              <Label htmlFor="employee_code">Employee Code (Optional)</Label>
              <Input
                id="employee_code"
                value={formData.employee_code}
                onChange={(e) => setFormData({ ...formData, employee_code: e.target.value })}
                placeholder="e.g. EMP-1042"
              />
            </div>
            
            <div className="grid gap-2">
              <Label htmlFor="name">Full Name <span className="text-red-500">*</span></Label>
              <Input
                id="name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="Jane Doe"
                required
              />
            </div>

            <div className="grid gap-2">
              <Label htmlFor="phone">Phone Number <span className="text-red-500">*</span></Label>
              <Input
                id="phone"
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                placeholder="+1234567890"
                required
                disabled={isEditing} // Phone number shouldn't typically change without re-verification
              />
              {!isEditing && (
                <p className="text-xs text-muted-foreground">
                  The employee must use this number to log into the Strive App.
                </p>
              )}
            </div>

            <div className="grid gap-2">
              <Label htmlFor="spending_limit">Monthly Spending Limit ($) <span className="text-red-500">*</span></Label>
              <Input
                id="spending_limit"
                type="number"
                min="0"
                step="0.01"
                value={formData.spending_limit}
                onChange={(e) => setFormData({ ...formData, spending_limit: Number(e.target.value) })}
                required
              />
            </div>

            <div className="grid gap-2">
              <Label htmlFor="status">Status</Label>
              <Select
                value={formData.status}
                onValueChange={(value: "ACTIVE" | "INACTIVE") => setFormData({ ...formData, status: value })}
              >
                <SelectTrigger id="status">
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="ACTIVE">Active (Can Book)</SelectItem>
                  <SelectItem value="INACTIVE">Inactive (Suspended)</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={isPending}>
              Cancel
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending ? "Saving..." : isEditing ? "Save Changes" : "Add Employee"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
