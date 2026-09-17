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
import { Coupon, CreateCouponRequest } from "../types";
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
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <TextInput
                name="code"
                label="Coupon Code"
                placeholder="e.g. WELCOME50"
                className="uppercase"
                autoComplete="off"
              />
              <SelectInput
                name="discount_type"
                label="Discount Type"
                placeholder="Select type"
                options={[
                  { label: "Percentage (%)", value: "PERCENTAGE" },
                  { label: "Flat Amount ($)", value: "FLAT" },
                ]}
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <NumberInput
                name="discount_value"
                label="Value"
              />
              <NumberInput
                name="max_discount"
                label="Max Disc. ($)"
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <TextInput
                name="valid_from"
                label="Start Date & Time"
                type="datetime-local"
              />
              <TextInput
                name="valid_until"
                label="End Date & Time"
                type="datetime-local"
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <NumberInput
                name="usage_limit"
                label="Total Usage Limit"
              />
            </div>

            <div className="rounded-lg border p-4 mt-2">
              <ToggleSwitch
                name="is_active"
                label="Campaign Status"
                description="Should this coupon be active and redeemable?"
              />
            </div>
            <FormDialogFooter
              isEdit={!!coupon}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
