import { z } from "zod";

export const bookingFormSchema = z.object({
  customer_id: z.number(),
  service_mode: z.enum(["NORMAL", "OUTSTATION", "RENTAL", "COURIER"]),
  status: z.enum(["PENDING", "ACCEPTED", "ARRIVED", "IN_TRIP", "COMPLETED", "CANCELLED", "ADMIN_CANCELLED"]),
  final_fare: z.preprocess(
    (val) => (typeof val === "string" ? parseFloat(val) : val),
    z.number().min(0, "Fare must be a positive number"),
  ),
});

export type BookingFormData = z.infer<typeof bookingFormSchema>;
