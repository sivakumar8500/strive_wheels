import { useEffect } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import TextInput from "@/components/forms/TextInput";
import SelectInput from "@/components/forms/SelectInput";
import DateInput from "@/components/forms/DateInput";
import { CompanyRider, AssignRiderRequest } from "../types";
import { useAssignCompanyRider, useUpdateCompanyRider } from "../hooks/use-riders";

interface RiderDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  rider?: CompanyRider | null;
}

export function RiderDialog({ open, onOpenChange, rider }: RiderDialogProps) {
  const isEditing = !!rider;
  
  const form = useForm<AssignRiderRequest>({
    defaultValues: {
      driver_name: "",
      phone: "",
      route_assigned: "",
      start_date: new Date().toISOString().split("T")[0],
      end_date: "",
      status: "ACTIVE",
    },
  });

  const { mutate: assignRider, isPending: isAssigning } = useAssignCompanyRider();
  const { mutate: updateRider, isPending: isUpdating } = useUpdateCompanyRider();

  useEffect(() => {
    if (open) {
      if (rider) {
        form.reset({
          driver_name: rider.driver_name,
          phone: rider.phone,
          route_assigned: rider.route_assigned,
          start_date: rider.start_date,
          end_date: rider.end_date,
          status: rider.status,
        });
      } else {
        form.reset({
          driver_name: "",
          phone: "",
          route_assigned: "",
          start_date: new Date().toISOString().split("T")[0],
          end_date: "",
          status: "ACTIVE",
        });
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, rider?.id, form]);

  const handleSubmit = (values: AssignRiderRequest) => {
    if (isEditing && rider) {
      updateRider(
        { id: rider.id, data: values },
        {
          onSuccess: () => {
            onOpenChange(false);
          },
        }
      );
    } else {
      assignRider(values, {
        onSuccess: () => {
          onOpenChange(false);
        },
      });
    }
  };

  const isPending = isAssigning || isUpdating;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <FormDialogHeader
          title={isEditing ? "Edit Assignment" : "Assign Dedicated Rider"}
          description={
            isEditing
              ? "Update the dedicated route contract details."
              : "Assign a new dedicated driver to a specific corporate route."
          }
          onClose={() => onOpenChange(false)}
        />
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)}>
            <div className="grid gap-4 py-4">
              
              <TextInput
                name="driver_name"
                label="Driver Name *"
                placeholder="Rajesh Kumar"
                required
              />

              <TextInput
                name="phone"
                label="Phone Number *"
                placeholder="+919876543210"
                required
              />

              <TextInput
                name="route_assigned"
                label="Route Description *"
                placeholder="e.g. Noida Sector 62 to Office"
                required
              />
              
              <div className="grid grid-cols-2 gap-4">
                <DateInput
                  name="start_date"
                  label="Contract Start"
                />
                <DateInput
                  name="end_date"
                  label="Contract End"
                />
              </div>

              <SelectInput
                name="status"
                label="Status"
                options={[
                  { label: "Active", value: "ACTIVE" },
                  { label: "Expired", value: "EXPIRED" },
                  { label: "Terminated", value: "TERMINATED" },
                ]}
              />
            </div>
            
            <FormDialogFooter
              isEdit={isEditing}
              isPending={isPending}
              onClose={() => onOpenChange(false)}
              createText="Assign Rider"
              editText="Save Changes"
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
