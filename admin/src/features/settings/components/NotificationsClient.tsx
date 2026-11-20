"use client";

import { useState, useEffect } from "react";
import { Checkbox } from "@/components/ui/checkbox";
import { Button } from "@/components/ui/button";
import { Save, Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";
import { toast } from "sonner";
import { PreferenceItem } from "@/features/auth/types";
import { useNotifications } from "@/features/auth/hooks/use-notifications";

export default function NotificationsClient() {
  const {
    data: remotePrefs,
    isLoading,
    update,
    isUpdating,
  } = useNotifications();
  const [preferences, setPreferences] = useState<PreferenceItem[]>([]);

  // Sync local state when remote data loads
  useEffect(() => {
    if (remotePrefs) {
      // Defer state update to avoid React Compiler cascading render warning
      const timer = setTimeout(() => {
        setPreferences(remotePrefs);
      }, 0);
      return () => clearTimeout(timer);
    }
  }, [remotePrefs]);

  const togglePreference = (id: string) => {
    setPreferences((prefs) =>
      prefs.map((p) => (p.id === id ? { ...p, checked: !p.checked } : p)),
    );
  };

  const handleSave = () => {
    update(preferences, {
      onSuccess: () => {
        toast.success("Preferences saved");
      },
      onError: (err: unknown) => {
        const error = err as { message?: string };
        toast.error(error.message || "Failed to save preferences");
      },
    });
  };

  if (isLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <Loader2 className="text-primary h-8 w-8 animate-spin" />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-2">
      <h2 className="text-foreground text-2xl font-black">
        Notification Preferences
      </h2>

      <div className="flex flex-col gap-2">
        {preferences.map((pref) => (
          <div
            key={pref.id}
            className={cn(
              "flex cursor-pointer items-center justify-between rounded-2xl border p-4 transition-all",
              pref.checked
                ? "border-primary/20 bg-primary/[0.02]"
                : "border-border hover:border-border/80 bg-transparent",
            )}
            onClick={() => togglePreference(pref.id)}
          >
            <div className="flex min-w-0 flex-1 flex-col gap-1 pr-4">
              <span className="text-foreground truncate font-bold sm:whitespace-normal">
                {pref.title}
              </span>
              <span className="text-muted-foreground line-clamp-2 text-sm font-medium sm:line-clamp-none">
                {pref.description}
              </span>
            </div>
            <div onClick={(e) => e.stopPropagation()} className="shrink-0">
              <Checkbox
                id={pref.id}
                checked={pref.checked}
                onCheckedChange={() => togglePreference(pref.id)}
                className="h-6 w-6 cursor-pointer rounded-sm border-1"
              />
            </div>
          </div>
        ))}
      </div>

      <div className="pt-2">
        <Button
          onClick={(e) => {
            e.stopPropagation();
            handleSave();
          }}
          disabled={isUpdating}
          className="bg-primary shadow-primary/20 flex w-full items-center justify-center gap-2 rounded-2xl px-8 py-6 text-sm font-black shadow-lg transition-all hover:shadow-xl active:scale-[0.98] sm:w-auto"
        >
          {isUpdating ? (
            <Loader2 className="h-4.5 w-4.5 animate-spin" />
          ) : (
            <Save className="h-4.5 w-4.5" />
          )}
          {isUpdating ? "Saving..." : "Save Preferences"}
        </Button>
      </div>
    </div>
  );
}
