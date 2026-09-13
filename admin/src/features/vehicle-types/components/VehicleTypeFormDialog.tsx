"use client";

import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import TextInput from "@/components/forms/TextInput";
import NumberInput from "@/components/forms/NumberInput";
import ToggleSwitch from "@/components/forms/ToggleSwitch";
import TextArea from "@/components/forms/TextArea";
import { VehicleType, CreateVehicleTypeDto } from "../types";
import { useEffect } from "react";

const schema = z.object({
  code: z.string().min(1, "Code is required"),
  name: z.string().min(1, "Name is required"),
  description: z.string().min(1, "Description is required"),
  icon_url: z.string().url("Must be a valid URL"),
  max_passengers: z.number().min(1, "Must be at least 1"),
  max_weight_kg: z.number().min(1, "Must be at least 1"),
  is_active: z.boolean(),
});

type FormData = z.infer<typeof schema>;

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
  const methods = useForm<FormData>({
    resolver: zodResolver(schema),
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
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>
            {initialData ? "Edit Vehicle Type" : "Add Vehicle Type"}
          </DialogTitle>
        </DialogHeader>

        <FormProvider {...methods}>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <TextInput name="code" label="Code (e.g. CAB)" placeholder="CAB" />
            <TextInput name="name" label="Name" placeholder="Sedan / Hatchback" />
            <TextArea name="description" label="Description" />
            <TextInput name="icon_url" label="Icon URL" placeholder="https://..." />
            
            <div className="grid grid-cols-2 gap-4">
              <NumberInput name="max_passengers" label="Max Passengers" />
              <NumberInput name="max_weight_kg" label="Max Weight (kg)" />
            </div>

            <ToggleSwitch name="is_active" label="Is Active" />

            <DialogFooter className="pt-4">
              <Button
                type="button"
                variant="outline"
                onClick={() => onOpenChange(false)}
                disabled={isSubmitting}
              >
                Cancel
              </Button>
              <Button type="submit" disabled={isSubmitting}>
                {isSubmitting ? "Saving..." : "Save"}
              </Button>
            </DialogFooter>
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
