"use client";

import { useEffect } from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { useFareConfigs, useBulkUpdateFareConfigs } from "../hooks/use-fare-configs";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Loader2, Save, RefreshCcw, DollarSign } from "lucide-react";
import { BulkUpdateFareConfigRequest } from "../types";

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
        configs: data.configs.map((c) => ({
          vehicle_type_id: c.vehicle_type_id,
          vehicle_type_name: c.vehicle_type_name,
          base_fare: c.base_fare,
          per_km_rate: c.per_km_rate,
        })),
      });
    }
  }, [data, form]);

  const onSubmit = (values: BulkUpdateFareConfigRequest) => {
    // Convert string inputs to numbers
    const payload: BulkUpdateFareConfigRequest = {
      global_base_fare: values.global_base_fare ? Number(values.global_base_fare) : null,
      global_per_km_rate: values.global_per_km_rate ? Number(values.global_per_km_rate) : null,
      global_surge_multiplier: Number(values.global_surge_multiplier),
      configs: values.configs.map((c) => ({
        vehicle_type_id: c.vehicle_type_id,
        base_fare: Number(c.base_fare),
        per_km_rate: Number(c.per_km_rate),
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
      <PageHeaderwithAddButton
        title="Fare Configurations & Pricing"
        description="Manage dynamic pricing, global surge multipliers, and base fares across vehicle types."
      />

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
          <Card>
            <CardHeader>
              <CardTitle>Global Settings</CardTitle>
              <CardDescription>
                These settings apply to all rides unless overridden by specific vehicle configurations.
              </CardDescription>
            </CardHeader>
            <CardContent className="grid gap-6 md:grid-cols-3">
              <FormField
                control={form.control}
                name="global_surge_multiplier"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Global Surge Multiplier (x)</FormLabel>
                    <FormControl>
                      <Input type="number" step="0.1" min="1" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="global_base_fare"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Global Base Fare (₹) - Optional</FormLabel>
                    <FormControl>
                      <Input type="number" step="0.5" {...field} value={field.value || ""} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="global_per_km_rate"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Global Per KM Rate (₹) - Optional</FormLabel>
                    <FormControl>
                      <Input type="number" step="0.5" {...field} value={field.value || ""} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Vehicle Type Pricing</CardTitle>
              <CardDescription>
                Set the specific base fare and per-kilometer rate for each available vehicle type.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              {fields.map((field: any, index) => (
                <div key={field.id} className="grid gap-4 md:grid-cols-3 p-4 border rounded-md items-center bg-slate-50/50">
                  <div>
                    <h4 className="font-semibold">{field.vehicle_type_name}</h4>
                    <p className="text-sm text-muted-foreground">ID: {field.vehicle_type_id}</p>
                  </div>
                  <FormField
                    control={form.control}
                    name={`configs.${index}.base_fare`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Base Fare (₹)</FormLabel>
                        <FormControl>
                          <Input type="number" step="0.5" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  <FormField
                    control={form.control}
                    name={`configs.${index}.per_km_rate`}
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Per KM Rate (₹)</FormLabel>
                        <FormControl>
                          <Input type="number" step="0.5" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
              ))}
            </CardContent>
          </Card>

          <div className="flex justify-end">
            <Button type="submit" size="lg" disabled={updateMutation.isPending}>
              {updateMutation.isPending ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : (
                <Save className="mr-2 h-4 w-4" />
              )}
              Save Pricing Configurations
            </Button>
          </div>
        </form>
      </Form>
    </div>
  );
}
