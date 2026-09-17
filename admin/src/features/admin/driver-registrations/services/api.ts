import apiService from "@/services/apiService";
import DRIVER_REGISTRATION_ENDPOINTS from "./endpoints";
import { DriverRegistrationSummary, DriverRegistrationDetail } from "../types";

export async function getDriverRegistrations(): Promise<DriverRegistrationSummary[]> {

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: DriverRegistrationSummary[];
  }>(DRIVER_REGISTRATION_ENDPOINTS.LIST, null);

  return response.data;
}

export async function getDriverRegistrationDetails(
  id: number
): Promise<DriverRegistrationDetail> {

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: DriverRegistrationDetail;
  }>(DRIVER_REGISTRATION_ENDPOINTS.DETAILS(id));

  return response.data;
}

export async function verifyDriverDocument(
  registrationId: number,
  documentId: number,
  status: "APPROVED" | "REJECTED",
  rejectionReason?: string
): Promise<any> {

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: any;
  }>(DRIVER_REGISTRATION_ENDPOINTS.VERIFY_DOC(registrationId), {
    document_id: documentId,
    document_category: "KYC",
    status,
    rejection_reason: rejectionReason,
  });

  return response.data;
}

export async function reviewDriverRegistration(
  registrationId: number,
  status: "APPROVED" | "REJECTED",
  rejectionReason?: string
): Promise<any> {
  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: any;
  }>(DRIVER_REGISTRATION_ENDPOINTS.REVIEW(registrationId), {
    status,
    rejection_reason: rejectionReason,
  });

  return response.data;
}
