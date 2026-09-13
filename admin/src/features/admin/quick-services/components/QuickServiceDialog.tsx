import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { QuickService, CreateQuickServiceRequest } from "../types";
import { Loader2 } from "lucide-react";

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
      target_screen: "",
      is_active: true,
    },
  });

  useEffect(() => {
    if (open) {
      if (service) {
        form.reset({
          title: service.title,
          icon_url: service.icon_url,
          target_screen: service.target_screen,
          is_active: service.is_active,
        });
      } else {
        form.reset({
          title: "",
          icon_url: "",
          target_screen: "",
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
        <DialogHeader>
          <DialogTitle>{service ? "Edit Quick Service" : "Add Quick Service"}</DialogTitle>
          <DialogDescription>
            {service
              ? "Modify the details of this quick service tile."
              : "Create a new quick service tile for the customer app home screen."}
          </DialogDescription>
        </DialogHeader>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            <FormField
              control={form.control}
              name="title"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Title</FormLabel>
                  <FormControl>
                    <Input placeholder="e.g. Ride, Package, Intercity" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="icon_url"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Icon URL</FormLabel>
                  <FormControl>
                    <Input placeholder="https://example.com/icon.png" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="target_screen"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Target Screen</FormLabel>
                  <FormControl>
                    <Input placeholder="e.g. RIDE_BOOKING" {...field} />
                  </FormControl>
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
                      Should this tile be visible to users?
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
            <DialogFooter className="pt-4">
              <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
                Cancel
              </Button>
              <Button type="submit" disabled={isSubmitting}>
                {isSubmitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                {service ? "Save Changes" : "Create Service"}
              </Button>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
