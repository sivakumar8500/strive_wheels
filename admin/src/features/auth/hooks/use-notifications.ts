import { useQuery, useMutation } from "@tanstack/react-query";
import { PreferenceItem } from "../types";

export function useNotifications() {
  const { data, isLoading } = useQuery({
    queryKey: ["notifications-prefs"],
    queryFn: async (): Promise<PreferenceItem[]> => {
      return [
        {
          id: "email-task-assigned",
          title: "Task Assigned",
          description: "Get notified when a new task is assigned to you.",
          checked: true,
        },
        {
          id: "email-campaign-status",
          title: "Campaign Status",
          description:
            "Receive updates on the status of your active campaigns.",
          checked: false,
        },
      ];
    },
  });

  const { mutate, isPending } = useMutation({
    mutationFn: async (prefs: PreferenceItem[]) => {
      return new Promise((resolve) => setTimeout(() => resolve(prefs), 1000));
    },
  });

  return { data, isLoading, update: mutate, isUpdating: isPending };
}
