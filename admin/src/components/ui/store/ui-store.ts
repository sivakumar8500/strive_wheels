import { create } from "zustand";
import { persist, devtools } from "zustand/middleware";

interface UIState {
  isSidebarCollapsed: boolean;
  activeModal: string | null;
  theme: "light" | "dark" | "system";

  // Actions
  toggleSidebar: () => void;
  toggleSidebarCollapse: () => void;
  setSidebarOpen: (isOpen: boolean) => void;
  setActiveModal: (modalId: string | null) => void;
  setTheme: (theme: "light" | "dark" | "system") => void;
  reset: () => void;
}

export const useUIStore = create<UIState>()(
  devtools(
    persist(
      (set) => ({
        isSidebarCollapsed: false,
        activeModal: null,
        theme: "system",

        toggleSidebar: () => {},
        toggleSidebarCollapse: () =>
          set((state) => ({ isSidebarCollapsed: !state.isSidebarCollapsed })),
        setSidebarOpen: (isOpen) => set({ isSidebarCollapsed: !isOpen }),
        setActiveModal: (modalId) => set({ activeModal: modalId }),
        setTheme: (theme) => set({ theme }),
        reset: () =>
          set({
            isSidebarCollapsed: false,
            activeModal: null,
            theme: "system",
          }),
      }),
      { name: "ui-storage" },
    ),
    { name: "UIStore" },
  ),
);
