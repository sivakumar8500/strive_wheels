import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatFullName(
  firstName?: string | null,
  lastName?: string | null,
): string {
  return `${firstName || ""} ${lastName || ""}`.trim();
}

export function formatS3Url(url: string | undefined): string | undefined {
  if (!url || !url.startsWith("http")) return url;

  try {
    const urlObj = new URL(url);
    const hostParts = urlObj.hostname.split(".");

    if (
      hostParts.includes("s3") &&
      hostParts.includes("amazonaws") &&
      hostParts.includes("com")
    ) {
      const bucketName = hostParts[0];
      const key = urlObj.pathname.startsWith("/")
        ? urlObj.pathname.slice(1)
        : urlObj.pathname;
      return `s3://${bucketName}/${key}`;
    }
  } catch (e) {
    console.error("Failed to parse S3 URL", e);
  }

  return url;
}
