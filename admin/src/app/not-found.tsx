"use client";

import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import { FileQuestion, Home, ArrowLeft } from "lucide-react";

export default function NotFound() {
  const router = useRouter();
  return (
    <div className="flex min-h-screen flex-1 flex-col items-center justify-center bg-zinc-50 p-6 font-sans">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-md text-center"
      >
        <div className="relative mb-8 flex justify-center">
          <motion.div
            initial={{ scale: 0.8 }}
            animate={{ scale: 1 }}
            transition={{
              type: "spring",
              stiffness: 260,
              damping: 20,
              delay: 0.2,
            }}
            className="flex h-24 w-24 items-center justify-center rounded-3xl bg-zinc-900 shadow-2xl"
          >
            <FileQuestion className="h-12 w-12 text-zinc-100" />
          </motion.div>
          <motion.div
            animate={{
              rotate: [0, 10, -10, 0],
              y: [0, -5, 5, 0],
            }}
            transition={{
              duration: 4,
              repeat: Infinity,
              ease: "easeInOut",
            }}
            className="absolute -top-4 -right-4 flex h-12 w-12 rotate-12 transform items-center justify-center rounded-2xl border border-zinc-200 bg-white shadow-lg"
          >
            <span className="text-xl font-bold">404</span>
          </motion.div>
        </div>

        <h1 className="mb-4 text-4xl font-bold tracking-tight text-zinc-900">
          Page Not Found
        </h1>
        <p className="mb-10 text-lg leading-relaxed text-zinc-600">
          The page you are looking for might have been removed, had its name
          changed, or is temporarily unavailable.
        </p>

        <div className="flex flex-col justify-center gap-4 sm:flex-row">
          <button
            onClick={() => router.push("/login")}
            className="flex h-12 items-center justify-center gap-2 rounded-full bg-zinc-900 px-6 font-semibold text-zinc-100 shadow-lg transition-all hover:scale-[1.02] active:scale-[0.98]"
          >
            <Home className="h-4 w-4" />
            Back to Home
          </button>
          <button
            onClick={() => router.back()}
            className="flex h-12 items-center justify-center gap-2 rounded-full border border-zinc-200 px-6 font-semibold text-zinc-900 transition-all hover:bg-zinc-100 active:scale-[0.98]"
          >
            <ArrowLeft className="h-4 w-4" />
            Go Back
          </button>
        </div>
      </motion.div>

      <div className="fixed bottom-8 text-sm text-zinc-400">
        © {new Date().getFullYear()} Next.js FastAPI Boilerplate
      </div>
    </div>
  );
}
