import apiService from "@/services/apiService";
import DRIVER_REGISTRATION_ENDPOINTS from "./endpoints";
import { DriverRegistration } from "../types";
import { MOCK_DRIVER_REGISTRATIONS } from "../data/mockData";

const USE_MOCK_DATA = true;

// Mutable mock data store for local session changes
const localMockData = [...MOCK_DRIVER_REGISTRATIONS];

export async function getDriverRegistrations(
  status?: string,
  skip = 0,
  limit = 50
): Promise<DriverRegistration[]> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve) => {
      setTimeout(() => {
        let data = [...localMockData];
        if (status) {
          data = data.filter((d) => d.status === status);
        }
        resolve(data.slice(skip, skip + limit));
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: DriverRegistration[];
  }>(DRIVER_REGISTRATION_ENDPOINTS.LIST, null);

  return response.data;
}

export async function getDriverRegistrationDetails(
  id: number
): Promise<DriverRegistration> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const item = localMockData.find((d) => d.id === id);
        if (item) {
          resolve(item);
        } else {
          reject(new Error("Driver registration not found"));
        }
      }, 300);
    });
  }

  const response = await apiService.get<{
    success: boolean;
    message: string;
    data: DriverRegistration;
  }>(DRIVER_REGISTRATION_ENDPOINTS.DETAILS(id));

  return response.data;
}

export async function verifyDriverDocument(
  registrationId: number,
  documentId: number,
  status: "APPROVED" | "REJECTED",
  rejectionReason?: string
): Promise<any> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const regIndex = localMockData.findIndex((r) => r.id === registrationId);
        if (regIndex === -1) return reject(new Error("Not found"));
        
        const docIndex = localMockData[regIndex].documents.findIndex((d) => d.id === documentId);
        if (docIndex === -1) return reject(new Error("Doc not found"));

        localMockData[regIndex].documents[docIndex].status = status;
        localMockData[regIndex].documents[docIndex].rejection_reason = rejectionReason || null;
        
        resolve({
          success: true,
          message: `Document ${status.toLowerCase()} successfully`,
        });
      }, 300);
    });
  }

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

export async function approveDriverRegistration(
  registrationId: number
): Promise<any> {
  if (USE_MOCK_DATA) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const regIndex = localMockData.findIndex((r) => r.id === registrationId);
        if (regIndex === -1) return reject(new Error("Not found"));

        localMockData[regIndex].status = "APPROVED";

        resolve({
          success: true,
          message: "Driver application approved successfully",
        });
      }, 300);
    });
  }

  const response = await apiService.post<{
    success: boolean;
    message: string;
    data: any;
  }>(DRIVER_REGISTRATION_ENDPOINTS.APPROVE(registrationId));

  return response.data;
}
