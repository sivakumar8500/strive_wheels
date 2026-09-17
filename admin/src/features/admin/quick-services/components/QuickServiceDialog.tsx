import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { FormProvider } from "react-hook-form";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import TextInput from "@/components/forms/TextInput";
import ToggleSwitch from "@/components/forms/ToggleSwitch";
import { QuickService, CreateQuickServiceRequest } from "../types";
interface QuickServiceDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  service?: QuickService | null;
  onSubmit: (data: CreateQuickServiceRequest) => void;
  isSubmitting: boolean;
}

export function QuickServiceDialog({
  open,
  onOpenChange,
  service,
  onSubmit,
  isSubmitting,
}: QuickServiceDialogProps) {
  const form = useForm<CreateQuickServiceRequest>({
    defaultValues: {
      title: "",
      icon_url: "",
      service_code: "",
      is_active: true,
    },
  });

  useEffect(() => {
    if (open) {
      if (service) {
        form.reset({
          title: service.title,
          icon_url: service.icon_url || "",
          service_code: service.service_code,
          is_active: service.is_active,
        });
      } else {
        form.reset({
          title: "",
          icon_url: "",
          service_code: "",
          is_active: true,
        });
      }
    }
  }, [open, service, form]);

  const handleSubmit = (values: CreateQuickServiceRequest) => {
    onSubmit(values);
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <FormDialogHeader
          title={service ? "Edit Quick Service" : "Add Quick Service"}
          description={service ? "Modify the details of this quick service tile." : "Create a new quick service tile for the customer app home screen."}
          onClose={() => onOpenChange(false)}
        />
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            <TextInput
              name="title"
              label="Title"
              placeholder="e.g. Ride, Package, Intercity"
            />
            <TextInput
              name="icon_url"
              label="Icon URL"
              placeholder="https://example.com/icon.png"
            />
            <TextInput
              name="service_code"
              label="Service Code"
              placeholder="e.g. BIKE, RIDE"
            />
            <div className="rounded-lg border p-4 mt-2">
              <ToggleSwitch
                name="is_active"
                label="Active Status"
                description="Should this tile be visible to users?"
              />
            </div>
            <FormDialogFooter
              isEdit={!!service}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
              createText="Create Service"
              editText="Save Changes"
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
