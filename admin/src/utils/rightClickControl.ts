/* =====================================================
   RIGHT CLICK CONTROL – ALL IN ONE FILE
   Works in JS / React / Next.js (Client)
===================================================== */

type RightClickOptions = {
  target?: HTMLElement | Document;
  enabled?: boolean;
};

export function rightClickControl(options?: RightClickOptions) {
  const { target = document, enabled = true } = options || {};

  // Only disable right-click and keyboard shortcuts in production mode
  const isProduction = process.env.NODE_ENV === "production";

  const contextMenuHandler = (e: Event) => {
    if (enabled && isProduction) {
      e.preventDefault();
    }
  };

  const keyboardHandler = (e: KeyboardEvent) => {
    if (enabled && isProduction) {
      // Block F12 (DevTools)
      if (e.key === "F12") {
        e.preventDefault();
        return;
      }

      // Block Ctrl+Shift+I (DevTools)
      if (e.ctrlKey && e.shiftKey && e.key === "I") {
        e.preventDefault();
        return;
      }

      // Block Ctrl+Shift+J (Console)
      if (e.ctrlKey && e.shiftKey && e.key === "J") {
        e.preventDefault();
        return;
      }

      // Block Ctrl+U (View Source)
      if (e.ctrlKey && e.key === "u") {
        e.preventDefault();
        return;
      }

      // Block Ctrl+Shift+C (Inspect Element)
      if (e.ctrlKey && e.shiftKey && e.key === "C") {
        e.preventDefault();
        return;
      }
    }
  };

  target.addEventListener("contextmenu", contextMenuHandler);
  target.addEventListener("keydown", keyboardHandler as EventListener);

  return {
    enable() {
      target.addEventListener("contextmenu", contextMenuHandler);
      target.addEventListener("keydown", keyboardHandler as EventListener);
    },
    disable() {
      target.removeEventListener("contextmenu", contextMenuHandler);
      target.removeEventListener("keydown", keyboardHandler as EventListener);
    },
  };
}

/* =====================================================
   OPTIONAL: AUTO RUN (GLOBAL)
   Uncomment if you want auto-disable on import
===================================================== */

// rightClickControl();

/* =====================================================
   REACT / NEXT.JS USAGE EXAMPLE
===================================================== */
/*
"use client";
import { useEffect } from "react";
import { rightClickControl } from "@/utils/rightClickControl";

export default function Page() {
  useEffect(() => {
    const rc = rightClickControl();
    return () => rc.disable();
  }, []);

  return <div>Right click disabled</div>;
}
*/
