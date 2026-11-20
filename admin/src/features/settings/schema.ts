import * as z from "zod";

export const profileSchema = z.object({
  firstName: z.string().min(1, "First Name is required"),
  lastName: z.string().min(1, "Last Name is required"),
  education: z.string().min(1, "Education is required"),
  experience: z.string().min(1, "Experience is required"),
  location: z.string().min(1, "Location is required"),
  domain: z.string().min(1, "Domain is required"),
  file: z.any().optional(),
  language: z.string().min(1, "Language is required"),
  availability: z.string().min(1, "Availability is required"),
  aht: z.number().min(0, "AHT must be a positive number"),
  costPerHour: z.number().min(0, "Cost per hour must be a positive number"),
  skills: z.array(z.string()).min(1, "At least one skill is required"),
});

export type ProfileFormValues = z.infer<typeof profileSchema>;
