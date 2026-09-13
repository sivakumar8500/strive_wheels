export interface Coupon {
  id: number;
  code: string;
  discount_type: "PERCENTAGE" | "FLAT";
  discount_value: number;
  max_discount_amount: number;
  min_ride_amount: number;
  start_date: string;
  end_date: string;
  usage_limit: number;
  times_used: number;
  is_active: boolean;
}

export type CreateCouponRequest = Omit<Coupon, "id" | "times_used">;
export type UpdateCouponRequest = Partial<CreateCouponRequest>;
