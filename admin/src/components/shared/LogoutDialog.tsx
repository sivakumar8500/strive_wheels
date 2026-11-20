"use client";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useUIStore } from "@/components/ui/store/ui-store";
import { LogOut } from "lucide-react";
import { performGlobalLogout } from "@/lib/logout";

/**
 * A global confirmation modal for signing out of the application.
 */
export function LogoutDialog() {
  const { activeModal, setActiveModal } = useUIStore();

  const isOpen = activeModal === "logout";

  const onOpenChange = (open: boolean) => {
    if (!open) setActiveModal(null);
  };

  const handleLogout = () => {
    // 1. Close Modal first
    setActiveModal(null);

    // 2. Perform Global Logout (handles store, cookies, and redirect)
    performGlobalLogout();
  };

  return (
    <AlertDialog open={isOpen} onOpenChange={onOpenChange}>
      <AlertDialogContent className="border-border bg-card flex max-w-[400px] flex-col items-center justify-center rounded-3xl p-6 shadow-2xl transition-all">
        <AlertDialogHeader className="flex flex-col items-center justify-center text-center">
          <div className="bg-destructive/10 text-destructive animate-in fade-in zoom-in mb-4 flex h-14 w-14 items-center justify-center rounded-2xl duration-300">
            <LogOut className="h-7 w-7" />
          </div>
          <AlertDialogTitle className="text-foreground text-center text-2xl font-black tracking-tight">
            Sign Out?
          </AlertDialogTitle>
          <AlertDialogDescription className="text-muted-foreground max-w-[320px] text-center text-base font-medium leading-relaxed">
            Are you sure you want to end your session? You will be redirected to
            the login page.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter className="mt-6 flex w-full flex-row items-center justify-center gap-3">
          <AlertDialogCancel className="border-border hover:bg-secondary flex-1 rounded-2xl border px-8 py-3 text-sm font-bold transition-all duration-200">
            Cancel
          </AlertDialogCancel>
          <AlertDialogAction
            onClick={handleLogout}
            className="bg-destructive hover:bg-destructive/90 flex-1 rounded-2xl px-8 py-3 text-sm font-bold text-white shadow-lg shadow-destructive/20 transition-all duration-200"
          >
            Sign Out
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
