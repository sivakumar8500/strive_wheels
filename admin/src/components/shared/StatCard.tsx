import { Card } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface StatCardProps {
  label: string;
  value: string | number;
  total?: string | number;
  unit?: string;
  color?: "blue" | "green" | "orange" | "teal" | "purple" | "indigo";
  icon: React.ElementType;
  darkValue?: boolean;
  description?: string;
}

export function StatCard({
  label,
  value,
  total,
  unit,
  color = "blue",
  icon: Icon,
  darkValue = false,
  description,
}: StatCardProps) {
  const themes = {
    blue: { bg: "bg-blue-50/50", text: "text-blue-500" },
    green: { bg: "bg-green-50/50", text: "text-green-500" },
    orange: { bg: "bg-orange-50/50", text: "text-orange-500" },
    teal: { bg: "bg-teal-50/50", text: "text-teal-500" },
    purple: { bg: "bg-purple-50/50", text: "text-purple-500" },
    indigo: { bg: "bg-indigo-50/50", text: "text-indigo-500" },
  };

  const theme = themes[color] || themes.blue;

  return (
    <Card className="group rounded-2xl border border-slate-100 bg-white p-5 shadow-none transition-all hover:border-blue-200">
      <div className="flex flex-col gap-4">
        <div className="flex items-center gap-2.5">
          <div className={cn("rounded-xl p-2 transition-all", theme.bg)}>
            <Icon className={cn("h-4.5 w-4.5", theme.text)} />
          </div>
          <p className="text-xs font-black tracking-widest text-slate-400 uppercase">
            {label}
          </p>
        </div>

        <div className="space-y-0.5">
          <div className="flex items-baseline gap-1">
            <span
              className={cn(
                "text-2xl font-black tracking-tight",
                darkValue ? "text-slate-900" : theme.text,
              )}
            >
              {value}
            </span>
            {total && (
              <span className="text-sm font-bold text-slate-300">/{total}</span>
            )}
            {unit && (
              <span className="ml-0.5 text-sm font-bold text-slate-400">
                {unit}
              </span>
            )}
          </div>
          {description && (
            <p className="text-xs leading-none font-bold tracking-tight text-slate-400 uppercase opacity-80">
              {description}
            </p>
          )}
        </div>
      </div>
    </Card>
  );
}
