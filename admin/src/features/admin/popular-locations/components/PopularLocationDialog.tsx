import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import { FormProvider } from "react-hook-form";
import TextInput from "@/components/forms/TextInput";
import SelectInput from "@/components/forms/SelectInput";
import NumberInput from "@/components/forms/NumberInput";
import ToggleSwitch from "@/components/forms/ToggleSwitch";
import { PopularLocation, CreatePopularLocationRequest } from "../types";

interface PopularLocationDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  location?: PopularLocation | null;
  onSubmit: (data: CreatePopularLocationRequest) => void;
  isSubmitting: boolean;
}

export function PopularLocationDialog({
  open,
  onOpenChange,
  location,
  onSubmit,
  isSubmitting,
}: PopularLocationDialogProps) {
  const form = useForm<CreatePopularLocationRequest>({
    defaultValues: {
      name: "",
      address: "",
      latitude: 0,
      longitude: 0,
      category: "AIRPORT",
      is_active: true,
    },
  });

  useEffect(() => {
    if (open) {
      if (location) {
        form.reset({
          name: location.name,
          address: location.address,
          latitude: location.latitude,
          longitude: location.longitude,
          category: location.category,
          is_active: location.is_active,
        });
      } else {
        form.reset({
          name: "",
          address: "",
          latitude: 0,
          longitude: 0,
          category: "AIRPORT",
          is_active: true,
        });
      }
    }
  }, [open, location, form]);

  const handleSubmit = (values: CreatePopularLocationRequest) => {
    onSubmit({
      ...values,
      latitude: Number(values.latitude),
      longitude: Number(values.longitude),
    });
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent showCloseButton={false} className="sm:max-w-[425px]">
        <FormDialogHeader
          title={location ? "Edit Popular Location" : "Add Popular Location"}
          onClose={() => onOpenChange(false)}
        />
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            <TextInput
              name="name"
              label="Location Name"
              placeholder="e.g. Central Station"
            />
            <TextInput
              name="address"
              label="Address / Description"
              placeholder="e.g. Station Rd, City Center"
            />
            <div className="grid grid-cols-2 gap-4">
              <NumberInput
                name="latitude"
                label="Latitude"
                step="any"
              />
              <NumberInput
                name="longitude"
                label="Longitude"
                step="any"
              />
            </div>
            <SelectInput
              name="category"
              label="Category"
              placeholder="Select a category"
              options={[
                { label: "Airport", value: "AIRPORT" },
                { label: "Railway Station", value: "RAILWAY" },
                { label: "Tech Park", value: "TECH_PARK" },
                { label: "Transit", value: "TRANSIT" },
                { label: "Office", value: "OFFICE" },
                { label: "Leisure", value: "LEISURE" },
                { label: "Hospital", value: "HOSPITAL" },
              ]}
            />
            <div className="rounded-lg border p-4 mt-2">
              <ToggleSwitch
                name="is_active"
                label="Active Status"
                description="Should this location be visible to users?"
              />
            </div>
            <FormDialogFooter
              isEdit={!!location}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
              createText="Create Location"
              editText="Save Changes"
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
