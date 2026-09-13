import { useMutation, useQueryClient } from "@tanstack/react-query";
import { updateProfile } from "../services/auth.api";
import { toast } from "sonner";
import { AccountDetailsData } from "../validations/accountant-schema";

export function useUpdateProfile() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: AccountDetailsData) => {
      return updateProfile(data);
    },
    onSuccess: () => {
      toast.success("Profile updated successfully");
      queryClient.invalidateQueries({ queryKey: ["me"] });
    },
    onError: (error: Error) => {
      toast.error(error.message);
    },
  });
}
