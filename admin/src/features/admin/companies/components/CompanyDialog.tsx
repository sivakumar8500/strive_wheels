import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { FormProvider } from "react-hook-form";
import FormDialogHeader from "@/components/shared/FormDialogHeader";
import FormDialogFooter from "@/components/shared/FormDialogFooter";
import TextInput from "@/components/forms/TextInput";
import SelectInput from "@/components/forms/SelectInput";
import NumberInput from "@/components/forms/NumberInput";
import { Company, CreateCompanyRequest, UpdateCompanyRequest } from "../types";

interface CompanyDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  company?: Company | null;
  onSubmit: (data: any) => void;
  isSubmitting: boolean;
}

export function CompanyDialog({
  open,
  onOpenChange,
  company,
  onSubmit,
  isSubmitting,
}: CompanyDialogProps) {
  const form = useForm<CreateCompanyRequest | UpdateCompanyRequest>({
    defaultValues: {
      company_name: "",
      registration_number: "",
      contact_person: "",
      contact_email: "",
      contact_phone: "",
      address: "",
      billing_type: "PREPAID",
      credit_limit: 0,
      status: "ACTIVE",
    },
  });

  useEffect(() => {
    if (open) {
      if (company) {
        form.reset({
          company_name: company.company_name,
          registration_number: company.registration_number,
          contact_person: company.contact_person,
          contact_email: company.contact_email,
          contact_phone: company.contact_phone,
          address: company.address,
          billing_type: company.billing_type,
          credit_limit: company.credit_limit,
          status: company.status,
        });
      } else {
        form.reset({
          company_name: "",
          registration_number: "",
          contact_person: "",
          contact_email: "",
          contact_phone: "",
          address: "",
          billing_type: "PREPAID",
          credit_limit: 0,
          status: "ACTIVE",
        });
      }
    }
  }, [open, company, form]);

  const handleSubmit = (values: any) => {
    onSubmit({
      ...values,
      credit_limit: Number(values.credit_limit),
    });
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
        <FormDialogHeader
          title={company ? "Edit Corporate Account" : "Onboard Corporate Account"}
          description={company ? "Modify the details of this B2B corporate client." : "Register a new B2B client in the system."}
          onClose={() => onOpenChange(false)}
        />
        <FormProvider {...form}>
          <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
            
            <div className="space-y-4 rounded-lg border p-4">
              <h3 className="text-sm font-medium">Company Information</h3>
              <div className="grid grid-cols-2 gap-4">
                <TextInput
                  name="company_name"
                  label="Company Name"
                  placeholder="e.g. Acme Corp"
                />
                <TextInput
                  name="registration_number"
                  label="Registration Number"
                  placeholder="e.g. TAX1234"
                />
              </div>
            </div>

            <div className="space-y-4 rounded-lg border p-4">
              <h3 className="text-sm font-medium">Contact Person</h3>
              <div className="grid grid-cols-2 gap-4">
                <TextInput
                  name="contact_person"
                  label="Full Name"
                  placeholder="e.g. Jane Doe"
                />
                <TextInput
                  name="contact_phone"
                  label="Phone Number"
                  placeholder="e.g. +1234567890"
                />
              </div>
              <TextInput
                name="contact_email"
                label="Email Address"
                placeholder="jane@acme.com"
                type="email"
              />
              <TextInput
                name="address"
                label="Billing Address"
                placeholder="123 Office Park, City"
              />
            </div>

            <div className="space-y-4 rounded-lg border p-4 bg-slate-50">
              <h3 className="text-sm font-medium">Financial & Status Setup</h3>
              <div className="grid grid-cols-2 gap-4">
                <SelectInput
                  name="billing_type"
                  label="Billing Type"
                  placeholder="Select billing type"
                  options={[
                    { label: "Prepaid Wallet", value: "PREPAID" },
                    { label: "Postpaid Invoice", value: "POSTPAID" },
                  ]}
                />
                <NumberInput
                  name="credit_limit"
                  label="Credit Limit ($)"
                />
              </div>

              {company && (
                <SelectInput
                  name="status"
                  label="Account Status"
                  placeholder="Select status"
                  options={[
                    { label: "Active", value: "ACTIVE" },
                    { label: "Suspended", value: "SUSPENDED" },
                    { label: "Inactive", value: "INACTIVE" },
                  ]}
                />
              )}
            </div>

            <FormDialogFooter
              isEdit={!!company}
              isPending={isSubmitting}
              onClose={() => onOpenChange(false)}
              createText="Onboard Company"
              editText="Save Changes"
            />
          </form>
        </FormProvider>
      </DialogContent>
    </Dialog>
  );
}
