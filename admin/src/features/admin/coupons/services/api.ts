import apiService from "@/services/apiService";
import COUPONS_ENDPOINTS from "./endpoints";
import {
  Coupon,
  CreateCouponRequest,
  UpdateCouponRequest,
} from "../types";
import { MOCK_COUPONS } from "../data/mockData";


const localMockData: Coupon[] = JSON.parse(JSON.stringify(MOCK_COUPONS));

export async function getCoupons(): Promise<Coupon[]> {
  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: Coupon[];
  }>(COUPONS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createCoupon(data: CreateCouponRequest): Promise<Coupon> {
 
  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: Coupon;
  }>(COUPONS_ENDPOINTS.CREATE, data);

  return response.data;
}

export async function updateCoupon({
  id,
  data,
}: {
  id: number;
  data: UpdateCouponRequest;
}): Promise<Coupon> {

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: Coupon;
  }>(COUPONS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteCoupon(id: number): Promise<void> {
  await apiService.delete(COUPONS_ENDPOINTS.DELETE(id));
}
