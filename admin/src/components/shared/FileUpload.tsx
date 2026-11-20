"use client";

import React, { useState, useRef } from "react";
import { Upload, X, Loader2, CheckCircle2 } from "lucide-react";
import uploadService from "@/services/uploadService";
import { cn } from "@/lib/utils";

interface FileUploadProps {
  onUploadSuccess: (url: string, s3Key: string) => void;
  onUploadError?: (error: Error) => void;
  acceptedFileTypes?: string;
  maxSizeMB?: number;
  label?: string;
  className?: string;
}

export function FileUpload({
  onUploadSuccess,
  onUploadError,
  acceptedFileTypes = "*",
  maxSizeMB = 5,
  label = "Click or drag file to upload",
  className,
}: FileUploadProps) {
  const [isDragging, setIsDragging] = useState(false);
  const [isUploading, setIsUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [uploadedFile, setUploadedFile] = useState<{ name: string; url: string } | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const maxSizeBytes = maxSizeMB * 1024 * 1024;

  const handleUpload = async (file: File) => {
    if (file.size > maxSizeBytes) {
      onUploadError?.(new Error(`File size exceeds ${maxSizeMB}MB`));
      return;
    }

    setIsUploading(true);
    setUploadProgress(10); // Start progress

    try {
      const { s3Key, url } = await uploadService.uploadFile(file);
      setUploadProgress(100);
      setUploadedFile({ name: file.name, url });
      onUploadSuccess(url, s3Key);
    } catch (error) {
      console.error("Upload failed:", error);
      onUploadError?.(error instanceof Error ? error : new Error("Upload failed"));
    } finally {
      setIsUploading(false);
      // Reset progress after a short delay
      setTimeout(() => setUploadProgress(0), 1000);
    }
  };

  const onDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const onDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const onDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
      handleUpload(e.dataTransfer.files[0]);
    }
  };

  const onChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      handleUpload(e.target.files[0]);
    }
  };

  const clearUpload = () => {
    setUploadedFile(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = "";
    }
  };

  return (
    <div className={cn("w-full", className)}>
      {!uploadedFile ? (
        <div
          onDragOver={onDragOver}
          onDragLeave={onDragLeave}
          onDrop={onDrop}
          onClick={() => fileInputRef.current?.click()}
          className={cn(
            "border-2 border-dashed rounded-lg p-6 flex flex-col items-center justify-center cursor-pointer transition-colors",
            isDragging ? "border-primary bg-primary/5" : "border-muted hover:bg-accent",
            isUploading && "opacity-50 pointer-events-none"
          )}
        >
          <input
            type="file"
            ref={fileInputRef}
            onChange={onChange}
            accept={acceptedFileTypes}
            className="hidden"
          />
          {isUploading ? (
            <div className="flex flex-col items-center">
              <Loader2 className="h-8 w-8 animate-spin text-primary mb-2" />
              <p className="text-sm text-muted-foreground">Uploading... {uploadProgress}%</p>
            </div>
          ) : (
            <>
              <Upload className="h-8 w-8 text-muted-foreground mb-2" />
              <p className="text-sm font-medium">{label}</p>
              <p className="text-xs text-muted-foreground mt-1">
                Max size: {maxSizeMB}MB
              </p>
            </>
          )}
        </div>
      ) : (
        <div className="flex items-center justify-between p-3 border rounded-lg bg-accent/50">
          <div className="flex items-center space-x-3 overflow-hidden">
            <CheckCircle2 className="h-5 w-5 text-green-500 shrink-0" />
            <span className="text-sm font-medium truncate">{uploadedFile.name}</span>
          </div>
          <button
            onClick={clearUpload}
            className="p-1 hover:bg-destructive/10 hover:text-destructive rounded-md transition-colors"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      )}
    </div>
  );
}
