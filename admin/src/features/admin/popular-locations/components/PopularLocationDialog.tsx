import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { PopularLocation, CreatePopularLocationRequest } from "../types";
import { Loader2 } from "lucide-react";

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
        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            <FormField
              control={form.control}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Location Name</FormLabel>
                  <FormControl>
                    <Input placeholder="e.g. Central Station" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="address"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Address / Description</FormLabel>
                  <FormControl>
                    <Input placeholder="e.g. Station Rd, City Center" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="latitude"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Latitude</FormLabel>
                    <FormControl>
                      <Input type="number" step="any" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="longitude"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Longitude</FormLabel>
                    <FormControl>
                      <Input type="number" step="any" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <FormField
              control={form.control}
              name="category"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Category</FormLabel>
                  <Select onValueChange={field.onChange} defaultValue={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Select a category" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="AIRPORT">Airport</SelectItem>
                      <SelectItem value="RAILWAY">Railway Station</SelectItem>
                      <SelectItem value="TECH_PARK">Tech Park</SelectItem>
                      <SelectItem value="TRANSIT">Transit</SelectItem>
                      <SelectItem value="OFFICE">Office</SelectItem>
                      <SelectItem value="LEISURE">Leisure</SelectItem>
                      <SelectItem value="HOSPITAL">Hospital</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="is_active"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                  <div className="space-y-0.5">
                    <FormLabel className="text-base">Active Status</FormLabel>
                    <p className="text-sm text-muted-foreground">
                      Should this location be visible to users?
                    </p>
                  </div>
                  <FormControl>
                    <Switch
                      checked={field.value}
                      onCheckedChange={field.onChange}
                    />
                  </FormControl>
                </FormItem>
              )}
            />
            <FormDialogFooter
              isEdit={!!location}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
              createText="Create Location"
              editText="Save Changes"
            />
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
