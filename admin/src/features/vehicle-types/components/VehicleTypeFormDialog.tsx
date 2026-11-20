"use client";

import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
  Dialog,
  DialogContent,
} from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import TextInput from "@/components/forms/TextInput";
import NumberInput from "@/components/forms/NumberInput";
import ToggleSwitch from "@/components/forms/ToggleSwitch";
import TextArea from "@/components/forms/TextArea";
import { VehicleType, CreateVehicleTypeDto } from "../types";
import { useEffect } from "react";
import { vehicleTypeSchema, VehicleTypeFormData } from "../validations/vehicle-type-schema";
import ImageUploadInput from "@/components/forms/ImageUploadInput";


interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  initialData?: VehicleType | null;
  onSubmit: (data: CreateVehicleTypeDto) => void;
  isSubmitting?: boolean;
}

export function VehicleTypeFormDialog({
  open,
  onOpenChange,
  initialData,
  onSubmit,
  isSubmitting = false,
}: Props) {
  const methods = useForm<VehicleTypeFormData>({
    resolver: zodResolver(vehicleTypeSchema),
    defaultValues: {
      code: "",
      name: "",
      description: "",
      icon_url: "",
      max_passengers: 4,
      max_weight_kg: 150,
      is_active: true,
    },
  });

  const { reset, handleSubmit } = methods;

  useEffect(() => {
    if (initialData) {
      reset({
        code: initialData.code,
        name: initialData.name,
        description: initialData.description,
        icon_url: initialData.icon_url,
        max_passengers: initialData.max_passengers,
        max_weight_kg: initialData.max_weight_kg,
        is_active: initialData.is_active,
      });
    } else {
      reset({
        code: "",
        name: "",
        description: "",
        icon_url: "",
        max_passengers: 4,
        max_weight_kg: 150,
        is_active: true,
      });
    }
  }, [initialData, reset, open]);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent showCloseButton={false} className="sm:max-w-[500px]">
        <FormDialogHeader
          title={initialData ? "Edit Vehicle Type" : "Add Vehicle Type"}
        />

        <FormProvider {...methods}>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <TextInput name="code" label="Code (e.g. CAB)" placeholder="CAB" />
            <TextInput name="name" label="Name" placeholder="Sedan / Hatchback" />
            <TextArea name="description" label="Description" />
            <ImageUploadInput
              name="icon_url"
              label="Icon Image"
              folder="vehicle-types"
            />
            
            <div className="grid grid-cols-2 gap-4">
              <NumberInput name="max_passengers" label="Max Passengers" />
              <NumberInput name="max_weight_kg" label="Max Weight (kg)" />
            </div>

            <ToggleSwitch name="is_active" label="Is Active" />

            <FormDialogFooter
              onCancel={() => onOpenChange(false)}
              isPending={isSubmitting}
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
