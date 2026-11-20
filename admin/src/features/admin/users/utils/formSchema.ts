import { z } from "zod";

export const userFormSchema = z.object({
  first_name: z.string().min(2, "First name must be at least 2 characters"),
  last_name: z.string().min(2, "Last name must be at least 2 characters"),
  email: z.string().email("Invalid email address"),
  role: z.enum(["SUPER_ADMIN", "ADMIN", "COMPANY_ADMIN"] as const, {
    message: "Please select a valid role",
  }),
  is_active: z.boolean(),
});

export type UserFormData = z.infer<typeof userFormSchema>;
