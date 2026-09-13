import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import settingsApi from "../services/settings.api";
import { AnnotatorProfilePayload } from "../types";
import { toast } from "sonner";
import { getCurrentOrgId } from "@/features/auth/store/auth.store";

export const SETTINGS_QUERY_KEYS = {
  PROFILE: (orgId: string) => ["settings", "profile", orgId] as const,
} as const;

export function useAnnotatorProfile() {
  const orgId = getCurrentOrgId();
  return useQuery({
    queryKey: SETTINGS_QUERY_KEYS.PROFILE(orgId!),
    queryFn: () => settingsApi.getAnnotatorProfile(),
    enabled: !!orgId,
  });
}

export function useUpdateAnnotatorProfile() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: AnnotatorProfilePayload) =>
      settingsApi.updateAnnotatorProfile(data),
    onSuccess: () => {
      toast.success("Profile updated successfully!");
      queryClient.invalidateQueries({
        queryKey: SETTINGS_QUERY_KEYS.PROFILE(getCurrentOrgId()),
      });
    },
    onError: () => {
      toast.error("Failed to update profile.");
    },
  });
}
