/* eslint-disable @next/next/no-img-element */
import React, { useState } from "react";
import { useFormContext } from "react-hook-form";
import { ImageOff } from "lucide-react";
import { FileDropzone } from "@/components/forms/FileDropzone";
import tempUploadService from "@/services/tempUploadService";

interface ImageUploadInputProps {
  name: string;
  label?: string;
  folder?: string;
  accept?: string;
  supportedText?: string;
}

export default function ImageUploadInput({
  name,
  label,
  folder = "general",
  accept = "image/*",
  supportedText = "PNG, JPG, SVG",
}: ImageUploadInputProps) {
  const [isUploading, setIsUploading] = useState(false);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [imageError, setImageError] = useState(false);
  const {
    setValue,
    watch,
    formState: { errors },
  } = useFormContext();

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    try {
      setIsUploading(true);
      setUploadError(null);
      setImageError(false);
      const res = await tempUploadService.uploadFile(file, folder);
      setValue(name, res.file_url, { shouldValidate: true });
    } catch (error: any) {
      console.error("Upload failed", error);
      setUploadError(error?.message || "Failed to upload image.");
    } finally {
      setIsUploading(false);
    }
  };

  const imageUrl = watch(name);

  const getNestedError = (obj: any, path: string) => {
    return path
      .split(/[.[\]]/)
      .filter(Boolean)
      .reduce(
        (res: any, key) => (res !== null && res !== undefined ? res[key] : res),
        obj,
      );
  };
  const fieldError = getNestedError(errors, name)?.message as string;
  const displayError = fieldError || uploadError;

  return (
    <div className="flex flex-col gap-2">
      {label && <label className="text-sm font-medium">{label}</label>}
      <div className="w-full">
        {!imageUrl ? (
          <div className="flex-1">
            <FileDropzone
              accept={accept}
              supportedText={supportedText}
              onChange={handleImageUpload}
              className={displayError ? "border-red-500 bg-red-50" : ""}
            />
            {isUploading && (
              <p className="text-sm text-blue-500 mt-2 font-medium">Uploading...</p>
            )}
          </div>
        ) : (
          <div className={`w-full h-48 overflow-hidden rounded-xl border bg-slate-50 flex flex-col items-center justify-center relative group ${displayError ? "border-red-500" : ""}`}>
            {!imageError ? (
              <img
                src={imageUrl}
                alt="Preview"
                className="h-full w-full object-cover"
                onError={() => setImageError(true)}
              />
        ) : (
        <div className="flex flex-col items-center gap-2 text-slate-400">
          <ImageOff className="h-8 w-8 text-slate-300" />
          <span className="text-xs font-medium">Image failed to load</span>
        </div>
            )}
        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center rounded-xl">
          <button
            type="button"
            onClick={() => setValue(name, "", { shouldValidate: true })}
            className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg text-sm font-semibold transition-colors cursor-pointer"
          >
            Remove Image
          </button>
        </div>
      </div>
        )}
    </div>
      {
    displayError && (
      <span className="text-destructive animate-in fade-in slide-in-from-top-1 text-xs font-medium">
        {displayError}
      </span>
    )
  }
    </div >
  );
}
