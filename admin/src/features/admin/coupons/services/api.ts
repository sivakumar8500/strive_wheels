import apiService from "@/services/apiService";
import COUPONS_ENDPOINTS from "./endpoints";
import {
  Coupon,
  CreateCouponRequest,
  UpdateCouponRequest,
} from "../types";
import { MOCK_COUPONS } from "../data/mockData";

const USE_MOCK_DATA = true;

let localMockData: Coupon[] = JSON.parse(JSON.stringify(MOCK_COUPONS));

export async function getCoupons(): Promise<Coupon[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([...localMockData]);
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: Coupon[];
  }>(COUPONS_ENDPOINTS.GET_ALL);

  return response.data;
}

export async function createCoupon(data: CreateCouponRequest): Promise<Coupon> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newId = Math.max(0, ...localMockData.map((c) => c.id)) + 1;
        const newItem: Coupon = {
          ...data,
          id: newId,
          times_used: 0,
        };
        localMockData.push(newItem);
        resolve(newItem);
      }, 500);
    });
  }

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
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((c) => c.id === id);
        if (index === -1) return reject(new Error("Coupon not found"));
        
        localMockData[index] = { ...localMockData[index], ...data };
        resolve(localMockData[index]);
      }, 500);
    });
  }

  const response = await apiService.put<{
    success: boolean;
    message: string;
    data: Coupon;
  }>(COUPONS_ENDPOINTS.UPDATE(id), data);

  return response.data;
}

export async function deleteCoupon(id: number): Promise<void> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = localMockData.findIndex((c) => c.id === id);
        if (index === -1) return reject(new Error("Coupon not found"));
        
        localMockData.splice(index, 1);
        resolve();
      }, 500);
    });
  }

  await apiService.delete(COUPONS_ENDPOINTS.DELETE(id));
}
