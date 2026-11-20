"use client";

import React, { useEffect } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useMe } from "@/features/auth/hooks/use-me";
import { useUpdateProfile } from "@/features/auth/hooks/use-profile";
import {
  accountantSchema,
  type AccountDetailsData,
} from "@/features/auth/validations/accountant-schema";
import { Button } from "@/components/ui/button";
import TextInput from "@/components/forms/TextInput";
import { Loader2, Save } from "lucide-react";

export default function AccountDetailsClient() {
  const { data: me, isLoading: isLoadingMe } = useMe();
  const { mutate: updateProfile, isPending: isUpdating } = useUpdateProfile();

  const methods = useForm<AccountDetailsData>({
    resolver: zodResolver(accountantSchema),
    defaultValues: {
      first_name: "",
      last_name: "",
      phone_number: "",
      gender: "",
      date_of_birth: "",
      designation: "",
    },
  });

  const { handleSubmit, reset } = methods;

  useEffect(() => {
    if (me?.user) {
      reset({
        first_name: me.user.first_name || "",
        last_name: me.user.last_name || "",
        phone_number: me.user.phone_number || "",
        gender: me.user.gender || "",
        date_of_birth: me.user.date_of_birth || "",
        designation: me.user.designation || "",
      });
    }
  }, [me, reset]);

  const onSubmit = (data: AccountDetailsData) => {
    updateProfile(data);
  };

  if (isLoadingMe) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h2 className="text-xl font-bold text-foreground">Account Details</h2>
        <p className="text-sm text-muted-foreground mt-1">
          Update your personal information and contact details.
        </p>
      </div>

      <FormProvider {...methods}>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <TextInput
              name="first_name"
              label="First Name"
              placeholder="Enter your first name"
            />
            <TextInput
              name="last_name"
              label="Last Name"
              placeholder="Enter your last name"
            />
            <TextInput
              name="phone_number"
              label="Phone Number"
              placeholder="Enter your phone number"
            />
            <TextInput
              name="gender"
              label="Gender"
              placeholder="Enter your gender"
            />
            <TextInput name="date_of_birth" label="Date of Birth" type="date" />
            <TextInput
              name="designation"
              label="Designation"
              placeholder="Enter your designation"
            />
          </div>

          <div className="flex justify-end pt-4 border-t border-border">
            <Button type="submit" disabled={isUpdating} className="gap-2">
              {isUpdating ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Save className="h-4 w-4" />
              )}
              Save Changes
            </Button>
          </div>
        </form>
      </FormProvider>
    </div>
  );
}
