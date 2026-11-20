import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
  images: {
    qualities: [75, 100],
    unoptimized: true,
  },
  turbopack: {
    root: path.join(process.cwd(), "./"),
    resolveAlias: {
      "@/components/ui": path.resolve(process.cwd(), "src/components/ui"),
      "@/lib": path.resolve(process.cwd(), "src/lib"),
      "@/hooks": path.resolve(process.cwd(), "src/hooks"),
      "@/features": path.resolve(process.cwd(), "src/features"),
      "@": path.resolve(process.cwd(), "src"),
    },
  },
};

export default nextConfig;
