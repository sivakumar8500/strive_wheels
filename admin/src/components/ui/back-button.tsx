"use client";

import { useRouter } from "next/navigation";
import { ArrowLeft } from "lucide-react";
import { Button } from "./button";

interface BackButtonProps {
  label?: string;
  href?: string;
  className?: string;
  onClick?: () => void;
}

const BackButton = ({ label, href, className, onClick }: BackButtonProps) => {
  const router = useRouter();

  const handleClick = () => {
    if (onClick) {
      onClick();
    } else if (href) {
      router.push(href);
    } else {
      router.back();
    }
  };

  return (
    <Button
      onClick={handleClick}
      variant="link"
      className={`flex w-fit items-center gap-2 text-xs font-medium text-sky-500 transition-colors ${className}`}
    >
      <ArrowLeft className="h-4 w-4 mr-2 font-semibold" />
      {label ? `Back to ${label}` : ""}
    </Button>
  );
};

export default BackButton;
