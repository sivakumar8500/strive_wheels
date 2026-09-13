import React from "react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import BackButton from "../ui/back-button";

interface PageHeaderProps {
  title: React.ReactNode;
  description: string;
  buttonText?: string;
  onBackButtonClick?: () => void;
  onAddButtonClick?: () => void;
  actionMenu?: React.ReactNode;
  icon?: React.ReactNode;
  className?: string;
  buttonBelowTag?: string;
  isBackButton?: boolean;
}

const PageHeaderwithAddButton = ({
  title,
  description,
  buttonText,
  onBackButtonClick,
  onAddButtonClick,
  actionMenu,
  icon,
  className,
  buttonBelowTag,
  isBackButton,
  ...props
}: PageHeaderProps) => {
  return (
    <div className={cn("flex flex-col gap-4", className)}>
      <div className="flex flex-col justify-between gap-4 sm:flex-row sm:items-center">
        <div className="flex flex-col gap-1">
          <div className="flex items-center">
            {isBackButton ? (
              <BackButton
                className="text-slate-500 p-0 m-0"
                onClick={onBackButtonClick}
              />
            ) : null}
            <h1 className="text-xl font-bold tracking-tight text-slate-900">
              {title}
            </h1>
          </div>
          <p className="max-w-2xl text-[13px] leading-relaxed font-medium text-slate-500 pl-1">
            {description}
          </p>
        </div>
        <div className="flex shrink-0 flex-col items-start gap-2 sm:items-end">
          {actionMenu ? (
            actionMenu
          ) : icon && buttonText ? (
            <Button
              onClick={onAddButtonClick}
              className="flex w-full items-center gap-2 sm:w-auto"
              {...props}
            >
              {icon && <span className="shrink-0">{icon}</span>}
              <span>{buttonText}</span>
            </Button>
          ) : null}
          {buttonBelowTag && (
            <p className="text-sm font-medium text-slate-500">
              Available balance:{" "}
              <span className="font-black text-green-600">
                {buttonBelowTag}
              </span>
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

export default PageHeaderwithAddButton;
