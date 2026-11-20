import React from "react";
import { Upload } from "lucide-react";
import { cn } from "@/lib/utils";

interface FileDropzoneProps {
  accept: string;
  supportedText: string;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
  className?: string;
  icon?: React.ReactNode;
}

export function FileDropzone({
  accept,
  supportedText,
  onChange,
  className,
  icon,
}: FileDropzoneProps) {
  return (
    <label
      className={cn(
        "border-2 border-dashed border-slate-200 rounded-xl p-8 flex flex-col items-center justify-center gap-3 bg-slate-50 cursor-pointer hover:border-slate-300 transition-all w-full",
        className,
      )}
    >
      <input
        type="file"
        accept={accept}
        className="hidden"
        onChange={onChange}
      />
      {icon || <Upload className="h-8 w-8 text-slate-400" />}
      <div className="flex flex-col items-center gap-1">
        <span className="text-sm font-semibold text-slate-700">
          Drag & drop your file here
        </span>
        <span className="text-xs text-slate-400">or click to browse</span>
      </div>
      <span className="text-[10px] font-bold text-slate-400 tracking-wider uppercase">
        {supportedText}
      </span>
    </label>
  );
}
