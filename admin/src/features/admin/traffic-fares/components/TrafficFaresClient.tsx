"use client";

import { useEffect } from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { useTrafficFares, useBulkUpdateTrafficFares } from "../hooks/use-traffic-fares";
import PageHeader from "@/components/shared/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { FormProvider } from "react-hook-form";
import NumberInput from "@/components/forms/NumberInput";
import TextInput from "@/components/forms/TextInput";
import ToggleSwitch from "@/components/forms/ToggleSwitch";
import { Button } from "@/components/ui/button";
import { Loader2, Save, RefreshCcw, Car } from "lucide-react";
import { BulkUpdateTrafficRequest } from "../types";

export function TrafficFaresClient() {
  const { data, isLoading, isError, refetch } = useTrafficFares();
  const updateMutation = useBulkUpdateTrafficFares();

  const form = useForm<BulkUpdateTrafficRequest>({
    defaultValues: {
      items: [],
    },
  });

  const { fields } = useFieldArray({
    name: "items",
    control: form.control,
  });

  useEffect(() => {
    if (data) {
      form.reset({
        items: data.map((item) => ({
          traffic_code: item.traffic_code,
          multiplier: item.multiplier,
          description: item.description,
          is_active: item.is_active,
        })),
      });
    }
  }, [data, form]);

  const onSubmit = (values: BulkUpdateTrafficRequest) => {
    const payload: BulkUpdateTrafficRequest = {
      items: values.items.map((item) => ({
        ...item,
        multiplier: Number(item.multiplier),
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
        <p>Failed to load traffic configurations.</p>
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
        title="Traffic Surge Multipliers"
        description="Configure dynamic surge pricing multipliers based on live traffic congestion levels."
      />

      <FormProvider {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {fields.map((field, index) => (
              <Card key={field.id} className={!form.watch(`items.${index}.is_active`) ? "opacity-60" : ""}>
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="flex items-center text-lg">
                      <Car className="w-5 h-5 mr-2 text-orange-500" />
                      {field.traffic_code}
                    </CardTitle>
                    <ToggleSwitch
                      name={`items.${index}.is_active`}
                      className="m-0"
                    />
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  <NumberInput
                    name={`items.${index}.multiplier`}
                    label="Surge Multiplier (x)"
                    step="0.05"
                    min={1}
                  />
                  <TextInput
                    name={`items.${index}.description`}
                    label="Description"
                  />
                </CardContent>
              </Card>
            ))}
          </div>

          <div className="flex justify-end sticky bottom-6 bg-slate-50/80 backdrop-blur-sm p-4 rounded-xl border shadow-sm">
            <Button type="submit" size="lg" disabled={updateMutation.isPending}>
              {updateMutation.isPending ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : (
                <Save className="mr-2 h-4 w-4" />
              )}
              Save Traffic Configurations
            </Button>
          </div>
        </form>
      </FormProvider>
    </div>
  );
}
