import { format, addDays, subDays } from "date-fns";

export class DateUtils {
  static getTodayFormatted(formatStr: string = "yyyy-MM-dd"): string {
    return format(new Date(), formatStr);
  }

  static getFutureDateFormatted(daysInFuture: number = 7, formatStr: string = "yyyy-MM-dd"): string {
    return format(addDays(new Date(), daysInFuture), formatStr);
  }

  static getPastDateFormatted(daysInPast: number = 7, formatStr: string = "yyyy-MM-dd"): string {
    return format(subDays(new Date(), daysInPast), formatStr);
  }

  static formatReadable(date: Date | string, formatStr: string = "MMM d, yyyy"): string {
    return format(new Date(date), formatStr);
  }
}
