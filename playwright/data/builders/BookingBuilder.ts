import { RandomUtils } from "@/core/utils/random.utils";

export interface BookingCancelData {
  reason: string;
}

export class BookingBuilder {
  static cancellationReason(customReason?: string): BookingCancelData {
    return {
      reason: customReason || `System administrative cancellation due to test audit - ${RandomUtils.getRandomString(6)}`,
    };
  }

  static filterParams() {
    return {
      statuses: ["PENDING", "ACCEPTED", "IN_TRIP", "COMPLETED", "CANCELLED"],
      services: ["NORMAL", "OUTSTATION", "RENTAL", "COURIER"],
    };
  }
}
