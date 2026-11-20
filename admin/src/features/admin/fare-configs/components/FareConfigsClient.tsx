"use client";

import { useEffect } from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { useFareConfigs, useBulkUpdateFareConfigs } from "../hooks/use-fare-configs";
import PageHeader from "@/components/shared/PageHeader";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { FormProvider } from "react-hook-form";
import NumberInput from "@/components/forms/NumberInput";
import SelectInput from "@/components/forms/SelectInput";
import { Button } from "@/components/ui/button";
import { Loader2, Save, RefreshCcw } from "lucide-react";
import { BulkUpdateFareConfigRequest } from "../types";
import { Accordion, AccordionItem, AccordionTrigger, AccordionContent } from "@/components/ui/accordion";

export function FareConfigsClient() {
  const { data, isLoading, isError, refetch } = useFareConfigs();
  const updateMutation = useBulkUpdateFareConfigs();

  const form = useForm<BulkUpdateFareConfigRequest>({
    defaultValues: {
      global_base_fare: null,
      global_per_km_rate: null,
      global_surge_multiplier: 1,
      configs: [],
    },
  });

  const { fields } = useFieldArray({
    name: "configs",
    control: form.control,
  });

  useEffect(() => {
    if (data) {
      form.reset({
        global_base_fare: data.global_base_fare,
        global_per_km_rate: data.global_per_km_rate,
        global_surge_multiplier: data.global_surge_multiplier,
        configs: data.configs.map((c: any) => ({
          vehicle_type_id: c.vehicle_type_id,
          vehicle_type_name: c.vehicle_type_name,
          base_fare: c.base_fare,
          min_fare: c.min_fare,
          per_km_rate: c.per_km_rate,
          per_min_rate: c.per_min_rate,
          waiting_per_min_rate: c.waiting_per_min_rate,
          cancellation_fee: c.cancellation_fee,
          night_charge_multiplier: c.night_charge_multiplier,
          surge_multiplier: c.surge_multiplier,
          platform_commission_pct: c.platform_commission_pct,
          ac_per_km: c.ac_per_km,
          non_ac_per_km: c.non_ac_per_km,
          short_distance_ac_per_km: c.short_distance_ac_per_km,
          outstation_ac_per_km: c.outstation_ac_per_km,
          outstation_non_ac_per_km: c.outstation_non_ac_per_km,
          vehicle_age_tier: c.vehicle_age_tier,
          outstation_min_km_per_day: c.outstation_min_km_per_day,
          outstation_min_hours_per_day: c.outstation_min_hours_per_day,
        })),
      });
    }
  }, [data, form]);

  const onSubmit = (values: BulkUpdateFareConfigRequest) => {
    const payload: BulkUpdateFareConfigRequest = {
      global_base_fare: values.global_base_fare ? Number(values.global_base_fare) : null,
      global_per_km_rate: values.global_per_km_rate ? Number(values.global_per_km_rate) : null,
      global_surge_multiplier: Number(values.global_surge_multiplier),
      configs: values.configs.map((c: any) => ({
        vehicle_type_id: c.vehicle_type_id,
        base_fare: c.base_fare ? Number(c.base_fare) : null,
        min_fare: c.min_fare ? Number(c.min_fare) : null,
        per_km_rate: c.per_km_rate ? Number(c.per_km_rate) : null,
        per_min_rate: c.per_min_rate ? Number(c.per_min_rate) : null,
        waiting_per_min_rate: c.waiting_per_min_rate ? Number(c.waiting_per_min_rate) : null,
        cancellation_fee: c.cancellation_fee ? Number(c.cancellation_fee) : null,
        night_charge_multiplier: c.night_charge_multiplier ? Number(c.night_charge_multiplier) : null,
        surge_multiplier: c.surge_multiplier ? Number(c.surge_multiplier) : null,
        platform_commission_pct: c.platform_commission_pct ? Number(c.platform_commission_pct) : null,
        ac_per_km: c.ac_per_km ? Number(c.ac_per_km) : null,
        non_ac_per_km: c.non_ac_per_km ? Number(c.non_ac_per_km) : null,
        short_distance_ac_per_km: c.short_distance_ac_per_km ? Number(c.short_distance_ac_per_km) : null,
        outstation_ac_per_km: c.outstation_ac_per_km ? Number(c.outstation_ac_per_km) : null,
        outstation_non_ac_per_km: c.outstation_non_ac_per_km ? Number(c.outstation_non_ac_per_km) : null,
        vehicle_age_tier: c.vehicle_age_tier || null,
        outstation_min_km_per_day: c.outstation_min_km_per_day ? Number(c.outstation_min_km_per_day) : null,
        outstation_min_hours_per_day: c.outstation_min_hours_per_day ? Number(c.outstation_min_hours_per_day) : null,
      })),
    };
    updateMutation.mutate(payload);
  };

  if (isLoading) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="flex h-[400px] flex-col items-center justify-center gap-4 text-red-500">
        <p>Failed to load fare configurations.</p>
        <Button variant="outline" onClick={() => refetch()}>
          <RefreshCcw className="mr-2 h-4 w-4" />
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Fare Configurations & Pricing"
        description="Manage dynamic pricing, global surge multipliers, and base fares across vehicle types."
      />

      <FormProvider {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
          <Card>
            <CardHeader>
              <CardTitle>Global Settings</CardTitle>
              <CardDescription>
                These settings apply to all rides unless overridden by specific vehicle configurations.
              </CardDescription>
            </CardHeader>
            <CardContent className="grid gap-6 md:grid-cols-3">
              <NumberInput
                name="global_surge_multiplier"
                label="Global Surge Multiplier (x)"
                step="0.1"
                min={1}
              />
              <NumberInput
                name="global_base_fare"
                label="Global Base Fare (₹) - Optional"
                step="0.5"
              />
              <NumberInput
                name="global_per_km_rate"
                label="Global Per KM Rate (₹) - Optional"
                step="0.5"
              />
            </CardContent>
          </Card>

          <div className="space-y-6">
            <h3 className="text-xl font-semibold tracking-tight">Vehicle Type Pricing</h3>
            <p className="text-sm text-muted-foreground">
              Configure detailed pricing structures including base fares, multipliers, outstation rates, and AC options per vehicle type.
            </p>
            
            <Accordion type="multiple" className="w-full space-y-4">
              {fields.map((field: any, index) => (
                <AccordionItem key={field.id} value={field.id} className="border rounded-lg bg-card text-card-foreground shadow-sm px-4">
                  <AccordionTrigger className="hover:no-underline py-4">
                    <div className="flex items-center gap-2 text-left">
                      <h4 className="text-lg font-semibold">{field.vehicle_type_name}</h4>
                      <span className="text-sm font-normal text-muted-foreground">(ID: {field.vehicle_type_id})</span>
                    </div>
                  </AccordionTrigger>
                  <AccordionContent className="pb-6 pt-2 space-y-8 border-t mt-2">
                    {/* Basic Fares */}
                    <div>
                      <h5 className="font-medium mb-4 text-primary">Basic Fares & Rates</h5>
                      <div className="grid gap-4 md:grid-cols-4">
                        <NumberInput name={`configs.${index}.base_fare`} label="Base Fare (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.min_fare`} label="Min Fare (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.per_km_rate`} label="Per KM (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.per_min_rate`} label="Per Min (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.waiting_per_min_rate`} label="Waiting Per Min (₹)" step="0.5" />
                      </div>
                    </div>

                    {/* Multipliers & Fees */}
                    <div>
                      <h5 className="font-medium mb-4 text-primary">Multipliers & Fees</h5>
                      <div className="grid gap-4 md:grid-cols-4">
                        <NumberInput name={`configs.${index}.cancellation_fee`} label="Cancel Fee (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.night_charge_multiplier`} label="Night Multiplier (x)" step="0.1" />
                        <NumberInput name={`configs.${index}.surge_multiplier`} label="Surge Multiplier (x)" step="0.1" />
                        <NumberInput name={`configs.${index}.platform_commission_pct`} label="Platform Comm. (%)" step="0.1" />
                      </div>
                    </div>

                    {/* AC & Non-AC Rates */}
                    <div>
                      <h5 className="font-medium mb-4 text-primary">AC / Non-AC KM Rates</h5>
                      <div className="grid gap-4 md:grid-cols-4">
                        <NumberInput name={`configs.${index}.ac_per_km`} label="AC Per KM (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.non_ac_per_km`} label="Non-AC Per KM (₹)" step="0.5" />
                        <NumberInput name={`configs.${index}.short_distance_ac_per_km`} label="Short Dist. AC (₹)" step="0.5" />
                      </div>
                    </div>

                    {/* Outstation Fares */}
                    <div>
                      <h5 className="font-medium mb-4 text-primary">Outstation & Special Settings</h5>
                      <div className="grid gap-4 md:grid-cols-5">
                        <NumberInput name={`configs.${index}.outstation_ac_per_km`} label="Outstation AC (₹/km)" step="0.5" />
                        <NumberInput name={`configs.${index}.outstation_non_ac_per_km`} label="Outstation Non-AC" step="0.5" />
                        <NumberInput name={`configs.${index}.outstation_min_km_per_day`} label="Min KM / Day" step="1" />
                        <NumberInput name={`configs.${index}.outstation_min_hours_per_day`} label="Min Hours / Day" step="1" />
                        <SelectInput
                          name={`configs.${index}.vehicle_age_tier`}
                          label="Age Tier"
                          options={[
                            { label: "Any", value: "ANY" },
                            { label: "New", value: "NEW" },
                            { label: "Old", value: "OLD" },
                          ]}
                        />
                      </div>
                    </div>
                  </AccordionContent>
                </AccordionItem>
              ))}
            </Accordion>
          </div>

          <div className="mt-8 flex justify-end">
            <Button type="submit" size="lg" disabled={updateMutation.isPending} className="shadow-md">
              {updateMutation.isPending ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : (
                <Save className="mr-2 h-4 w-4" />
              )}
              Save Pricing Configurations
            </Button>
          </div>
        </form>
      </FormProvider>
    </div>
  );
}
