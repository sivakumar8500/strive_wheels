import { z } from "zod";

export const accountSchema = z.object({
  firstName: z.string().min(1, "First name is required"),
  lastName: z.string().min(1, "Last name is required"),
  email: z.string().email("Invalid email address"),
  role: z.string().optional(),
  phoneNumber: z.string().optional(),
});

export type AccountDetailsData = z.infer<typeof accountSchema>;
