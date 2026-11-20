"use client";

import * as React from "react";
import { ChevronsUpDown } from "lucide-react";
import { cn } from "@/lib/utils";
import { Checkbox } from "@/components/ui/checkbox";
import { Button } from "./button";
import { Popover, PopoverContent, PopoverTrigger } from "./popover";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "./command";

interface MultiSelectProps {
  options: string[];
  selected: string[];
  onToggle: (option: string) => void;
  placeholder?: string;
  className?: string;
}

export function MultiSelect({
  options,
  selected,
  onToggle,
  placeholder = "Select options...",
  className,
}: MultiSelectProps) {
  const [open, setOpen] = React.useState(false);

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          role="combobox"
          aria-expanded={open}
          className={cn(
            "h-10 w-full justify-between rounded-lg border-slate-100 bg-white font-bold text-slate-700 shadow-none hover:bg-white focus:ring-0",
            selected.length === 0 && "text-slate-400 font-medium",
            className,
          )}
        >
          <div className="flex gap-1 truncate">
            {selected.length > 0 ? selected.join(", ") : placeholder}
          </div>
          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent
        className="w-[var(--radix-popover-trigger-width)] p-2"
        align="start"
      >
        <Command>
          <CommandInput placeholder={`Search...`} className="h-9" />
          <CommandList className="max-h-[300px] overflow-y-auto p-1">
            <CommandEmpty className="py-6 text-center text-sm text-slate-500">
              No options found.
            </CommandEmpty>
            <CommandGroup>
              {options.map((option) => (
                <CommandItem
                  key={option}
                  onSelect={() => onToggle(option)}
                  className="flex cursor-pointer items-center gap-4 rounded-md px-3 py-2.5 mb-1 last:mb-0 transition-colors hover:bg-slate-50 data-[selected=true]:bg-slate-50"
                >
                  <div className="relative flex items-center justify-center">
                    <Checkbox
                      checked={selected.includes(option)}
                      onCheckedChange={() => onToggle(option)}
                      className="h-5 w-5 rounded-[6px] border-slate-300 transition-all data-[state=checked]:border-primary"
                    />
                  </div>
                  <span className="flex-1 text-sm font-medium text-slate-600 transition-colors">
                    {option}
                  </span>
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  );
}
