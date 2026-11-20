import { create } from "zustand";
import { devtools } from "zustand/middleware";

interface AppState {
  version: string;
  isInitialized: boolean;

  // Actions
  setInitialized: (initialized: boolean) => void;
}

export const useAppStore = create<AppState>()(
  devtools(
    (set) => ({
      version: "0.1.0",
      isInitialized: false,

      setInitialized: (initialized) => set({ isInitialized: initialized }),
    }),
    { name: "AppStore" },
  ),
);
