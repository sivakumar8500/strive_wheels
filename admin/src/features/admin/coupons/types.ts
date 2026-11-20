export interface Coupon {
  id: number;
  code: string;
  discount_type: "PERCENTAGE" | "FLAT";
  discount_value: number;
  max_discount: number | null;
  valid_from: string;
  valid_until: string;
  usage_limit: number | null;
  times_used: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export type CreateCouponRequest = Omit<Coupon, "id" | "times_used" | "created_at" | "updated_at">;
export type UpdateCouponRequest = Partial<CreateCouponRequest>;
