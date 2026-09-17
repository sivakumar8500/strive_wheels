import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { FormProvider } from "react-hook-form";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import TextInput from "@/components/forms/TextInput";
import SelectInput from "@/components/forms/SelectInput";
import ToggleSwitch from "@/components/forms/ToggleSwitch";
import { AdminUser, CreateAdminUserRequest, UpdateAdminUserRequest } from "../types";

interface UserDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  user?: AdminUser | null;
  onSubmit: (data: any) => void;
  isSubmitting: boolean;
}

export function UserDialog({
  open,
  onOpenChange,
  user,
  onSubmit,
  isSubmitting,
}: UserDialogProps) {
  const form = useForm<CreateAdminUserRequest | UpdateAdminUserRequest>({
    defaultValues: {
      first_name: "",
      last_name: "",
      email: "",
      role: "ADMIN",
      is_active: true,
    },
  });

  useEffect(() => {
    if (open) {
      if (user) {
        form.reset({
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          role: user.role,
          is_active: user.is_active,
        });
      } else {
        form.reset({
          first_name: "",
          last_name: "",
          email: "",
          role: "ADMIN",
          is_active: true,
        });
      }
    }
  }, [open, user, form]);

  const handleSubmit = (values: any) => {
    onSubmit(values);
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <FormDialogHeader
          title={user ? "Edit Admin User" : "Provision Admin User"}
          description={user ? "Update details and permissions for this administrative user." : "Create a new administrative user with specific role permissions."}
          onClose={() => onOpenChange(false)}
        />
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            
            <div className="grid grid-cols-2 gap-4">
              <TextInput
                name="first_name"
                label="First Name"
                placeholder="John"
              />
              <TextInput
                name="last_name"
                label="Last Name"
                placeholder="Doe"
              />
            </div>

            <TextInput
              name="email"
              label="Email Address"
              placeholder="john.doe@example.com"
              type="email"
            />

            <SelectInput
              name="role"
              label="Access Role"
              placeholder="Select a role"
              options={[
                { label: "Super Admin (Full Access)", value: "SUPER_ADMIN" },
                { label: "Admin (Standard Access)", value: "ADMIN" },
                { label: "Company Admin (B2B Only)", value: "COMPANY_ADMIN" },
              ]}
            />

            <div className="rounded-lg border p-4 mt-2">
              <ToggleSwitch
                name="is_active"
                label="Active Account"
                description="Allow this user to log into the admin panel"
              />
            </div>

            <FormDialogFooter
              isEdit={!!user}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
              createText="Provision User"
              editText="Save Changes"
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
