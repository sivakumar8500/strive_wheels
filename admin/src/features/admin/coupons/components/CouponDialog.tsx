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
import { Coupon, CreateCouponRequest } from "../types";
import { Loader2 } from "lucide-react";

interface CouponDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  coupon?: Coupon | null;
  onSubmit: (data: CreateCouponRequest) => void;
  isSubmitting: boolean;
}

export function CouponDialog({
  open,
  onOpenChange,
  coupon,
  onSubmit,
  isSubmitting,
}: CouponDialogProps) {
  const form = useForm<CreateCouponRequest>({
    defaultValues: {
      code: "",
      discount_type: "PERCENTAGE",
      discount_value: 0,
      max_discount: 0,
      valid_from: new Date().toISOString().slice(0, 16),
      valid_until: new Date(new Date().setMonth(new Date().getMonth() + 1)).toISOString().slice(0, 16),
      usage_limit: 100,
      is_active: true,
    },
  });

  useEffect(() => {
    if (open) {
      if (coupon) {
        form.reset({
          code: coupon.code,
          discount_type: coupon.discount_type,
          discount_value: coupon.discount_value,
          max_discount: coupon.max_discount || 0,
          valid_from: coupon.valid_from.slice(0, 16), // datetime-local format
          valid_until: coupon.valid_until.slice(0, 16),
          usage_limit: coupon.usage_limit || 0,
          is_active: coupon.is_active,
        });
      } else {
        form.reset({
          code: "",
          discount_type: "PERCENTAGE",
          discount_value: 0,
          max_discount: 0,
          valid_from: new Date().toISOString().slice(0, 16),
          valid_until: new Date(new Date().setMonth(new Date().getMonth() + 1)).toISOString().slice(0, 16),
          usage_limit: 100,
          is_active: true,
        });
      }
    }
  }, [open, coupon, form]);

  const handleSubmit = (values: CreateCouponRequest) => {
    onSubmit({
      ...values,
      discount_value: Number(values.discount_value),
      max_discount: Number(values.max_discount) || null,
      usage_limit: Number(values.usage_limit) || null,
      valid_from: new Date(values.valid_from).toISOString(),
      valid_until: new Date(values.valid_until).toISOString(),
    });
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[525px] max-h-[90vh] overflow-y-auto" showCloseButton={false}>
        <FormDialogHeader
          title={coupon ? "Edit Coupon" : "Create Coupon"}
          onClose={() => onOpenChange(false)}
        />
        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="code"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Coupon Code</FormLabel>
                    <FormControl>
                      <Input placeholder="e.g. WELCOME50" {...field} className="uppercase" />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="discount_type"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Discount Type</FormLabel>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Select type" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value="PERCENTAGE">Percentage (%)</SelectItem>
                        <SelectItem value="FLAT">Flat Amount ($)</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="discount_value"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Value</FormLabel>
                    <FormControl>
                      <Input type="number" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="max_discount"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Max Disc. ($)</FormLabel>
                    <FormControl>
                      <Input type="number" {...field} value={field.value ?? ""} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="valid_from"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Start Date & Time</FormLabel>
                    <FormControl>
                      <Input type="datetime-local" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="valid_until"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>End Date & Time</FormLabel>
                    <FormControl>
                      <Input type="datetime-local" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="usage_limit"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Total Usage Limit</FormLabel>
                    <FormControl>
                      <Input type="number" {...field} value={field.value ?? ""} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <FormField
              control={form.control}
              name="is_active"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                  <div className="space-y-0.5">
                    <FormLabel className="text-base">Campaign Status</FormLabel>
                    <p className="text-sm text-muted-foreground">
                      Should this coupon be active and redeemable?
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
              isEdit={!!coupon}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
            />
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
