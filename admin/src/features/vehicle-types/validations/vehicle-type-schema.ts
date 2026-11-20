import { z } from "zod";

export const vehicleTypeSchema = z.object({
  code: z.string().min(1, "Code is required"),
  name: z.string().min(1, "Name is required"),
  description: z.string().min(1, "Description is required"),
  icon_url: z.string().url("Must be a valid URL").optional().or(z.literal("")),
  max_passengers: z.number().min(1, "Must be at least 1"),
  max_weight_kg: z.number().min(1, "Must be at least 1"),
  is_active: z.boolean(),
});

export type VehicleTypeFormData = z.infer<typeof vehicleTypeSchema>;
