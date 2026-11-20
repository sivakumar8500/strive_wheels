"use client";
import { useEffect } from "react";

import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import TextInput from "@/components/forms/TextInput";
import SelectInput from "@/components/forms/SelectInput";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import { User } from "../types";
import { userFormSchema, UserFormData } from "../utils/formSchema";
import { formatUserForForm } from "../utils/helpers";

interface UserFormDialogProps {
  isOpen: boolean;
  isLoading?: boolean;
  user: User | null; // null for create, User object for edit
  onClose: () => void;
  onSubmit: (data: UserFormData) => Promise<void>;
}

export function UserFormDialog({
  isOpen,
  isLoading = false,
  user,
  onClose,
  onSubmit,
}: UserFormDialogProps) {
  const isEdit = !!user;
  const methods = useForm<UserFormData>({
    resolver: zodResolver(userFormSchema),
    defaultValues: user ? formatUserForForm(user) : undefined,
  });

  const { handleSubmit, reset } = methods;

  useEffect(() => {
    if (user && isOpen) {
      reset(formatUserForForm(user));
    } else if (!isOpen) {
      reset();
    }
  }, [user, isOpen, reset]);

  const handleOpenChange = (open: boolean) => {
    if (!open) {
      reset();
      onClose();
    }
  };

  const onFormSubmit = async (data: UserFormData) => {
    await onSubmit(data);
    reset();
  };

  return (
    <Dialog open={isOpen} onOpenChange={handleOpenChange}>
      <DialogContent showCloseButton={false} className="max-w-md">
        <FormDialogHeader
          title={isEdit ? "Edit User" : "Add New User"}
          onClose={onClose}
        />

        <FormProvider {...methods}>
          <form onSubmit={handleSubmit(onFormSubmit)} className="space-y-4">
            <TextInput name="first_name" label="First Name" placeholder="John" required />
            <TextInput name="last_name" label="Last Name" placeholder="Doe" required />

            <TextInput
              name="email"
              label="Email Address"
              type="email"
              placeholder="john@example.com"
              required
            />

            <SelectInput
              name="role"
              label="Role"
              placeholder="Select role"
              options={[
                { value: "SUPER_ADMIN", label: "Super Admin" },
                { value: "ADMIN", label: "Administrator" },
                { value: "COMPANY_ADMIN", label: "Company Admin" },
              ]}
              required
            />

            <div>
              <label className="text-sm font-medium">Is Active</label>
              <div className="mt-2">
                <input type="checkbox" {...methods.register("is_active")} />
              </div>
            </div>

            <FormDialogFooter
              isEdit={isEdit}
              isPending={isLoading}
              onClose={onClose}
              onSubmit={handleSubmit(onFormSubmit)}
              createText="Create User"
              createLoadingText="Creating..."
              editText="Save Changes"
              editLoadingText="Saving..."
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
