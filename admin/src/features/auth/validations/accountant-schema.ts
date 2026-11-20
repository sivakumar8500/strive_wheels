import { z } from "zod";

export const accountantSchema = z.object({
  first_name: z.string().min(2, "First name must be at least 2 characters"),
  last_name: z.string().min(2, "Last name must be at least 2 characters"),
  phone_number: z.string().optional(),
  gender: z.string().optional(),
  date_of_birth: z.string().optional(),
  designation: z.string().optional(),
});

export type AccountDetailsData = z.infer<typeof accountantSchema>;
