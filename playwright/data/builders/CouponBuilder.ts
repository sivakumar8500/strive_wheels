import { RandomUtils } from "@/core/utils/random.utils";
import { DateUtils } from "@/core/utils/date.utils";

export interface CouponData {
  code: string;
  discount_type: "PERCENTAGE" | "FLAT";
  discount_value: number;
  max_discount_amount: number;
  min_booking_amount: number;
  valid_from: string;
  valid_until: string;
  usage_limit: number;
  is_active: boolean;
}

export class CouponBuilder {
  static valid(overrides: Partial<CouponData> = {}): CouponData {
    return {
      code: RandomUtils.getRandomCode("PROMO"),
      discount_type: "PERCENTAGE",
      discount_value: 20,
      max_discount_amount: 150,
      min_booking_amount: 300,
      valid_from: DateUtils.getTodayFormatted(),
      valid_until: DateUtils.getFutureDateFormatted(30),
      usage_limit: 100,
      is_active: true,
      ...overrides,
    };
  }

  static flatDiscount(overrides: Partial<CouponData> = {}): CouponData {
    return CouponBuilder.valid({
      code: RandomUtils.getRandomCode("FLAT"),
      discount_type: "FLAT",
      discount_value: 50,
      max_discount_amount: 50,
      ...overrides,
    });
  }
}
