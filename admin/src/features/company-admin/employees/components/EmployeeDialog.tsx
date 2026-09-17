import { useEffect } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import TextInput from "@/components/forms/TextInput";
import NumberInput from "@/components/forms/NumberInput";
import SelectInput from "@/components/forms/SelectInput";
import { CorporateEmployee, CreateEmployeeRequest } from "../types";
import { useCreateEmployee, useUpdateEmployee } from "../hooks/use-employees";

interface EmployeeDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  employee?: CorporateEmployee | null;
}

export function EmployeeDialog({ open, onOpenChange, employee }: EmployeeDialogProps) {
  const isEditing = !!employee;
  
  const form = useForm<CreateEmployeeRequest>({
    defaultValues: {
      employee_code: "",
      name: "",
      phone: "",
      spending_limit: 0,
      status: "ACTIVE",
    },
  });

  const { mutate: createEmployee, isPending: isCreating } = useCreateEmployee();
  const { mutate: updateEmployee, isPending: isUpdating } = useUpdateEmployee();

  useEffect(() => {
    if (employee && open) {
      form.reset({
        employee_code: employee.employee_code || "",
        name: employee.name,
        phone: employee.phone,
        spending_limit: employee.spending_limit,
        status: employee.status,
      });
    } else if (open && !employee) {
      form.reset({
        employee_code: "",
        name: "",
        phone: "",
        spending_limit: 0,
        status: "ACTIVE",
      });
    }
  }, [employee, open, form]);

  const handleSubmit = (values: CreateEmployeeRequest) => {
    if (isEditing && employee) {
      updateEmployee(
        { id: employee.id, data: values },
        {
          onSuccess: () => {
            onOpenChange(false);
          },
        }
      );
    } else {
      createEmployee(values, {
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
        <FormDialogHeader
          title={isEditing ? "Edit Employee" : "Whitelist Employee"}
          description={
            isEditing
              ? "Update corporate commute privileges for this employee."
              : "Add an employee to your corporate roster. They will be able to book rides using their registered phone number."
          }
          onClose={() => onOpenChange(false)}
        />
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)}>
            <div className="grid gap-4 py-4">
              <TextInput
                name="employee_code"
                label="Employee Code (Optional)"
                placeholder="e.g. EMP-1042"
              />
              
              <TextInput
                name="name"
                label="Full Name *"
                placeholder="Jane Doe"
                required
              />

              <TextInput
                name="phone"
                label="Phone Number *"
                placeholder="+1234567890"
                required
                disabled={isEditing}
              />
              {!isEditing && (
                <p className="text-xs text-muted-foreground -mt-2">
                  The employee must use this number to log into the Strive App.
                </p>
              )}

              <NumberInput
                name="spending_limit"
                label="Monthly Spending Limit ($) *"
                required
              />

              <SelectInput
                name="status"
                label="Status"
                options={[
                  { label: "Active (Can Book)", value: "ACTIVE" },
                  { label: "Inactive (Suspended)", value: "INACTIVE" },
                ]}
              />
            </div>
            
            <FormDialogFooter
              isEdit={isEditing}
              isPending={isPending}
              onClose={() => onOpenChange(false)}
              createText="Add Employee"
              editText="Save Changes"
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
