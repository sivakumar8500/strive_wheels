import apiService from "./apiService";
import UPLOAD_ENDPOINTS from "./endpoints/uploadEndpoints";
import { getCurrentOrgId } from "@/features/auth/store/auth.store";

export interface PresignedUrlResponse {
  presigned_url: string;
  s3_key: string;
  expires_at: string;
}

export interface PermanentUrlResponse {
  download_url: string;
}

const getContentType = (file: File): string => {
  if (file.name.endsWith(".csv") || file.type === "text/csv") {
    return "text/csv";
  }
  if (file.name.endsWith(".xlsx")) {
    return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
  }
  return file.type || "application/octet-stream";
};

//Service for handling file uploads via S3 Presigned URLs
const uploadService = {
  getPresignedUrl: async (
    filename: string,
    contentType: string,
    fileSize: number,
    location?: string,
  ): Promise<PresignedUrlResponse> => {
    const orgId = getCurrentOrgId();
    return apiService.post<PresignedUrlResponse>(
      UPLOAD_ENDPOINTS.PRESIGNED_URL(orgId),
      {
        filename,
        content_type: contentType,
        file_size: fileSize,
        location,
      },
    );
  },

  /**
   * 2. Upload the raw file to S3
   * Note: The backend signs the URL with the ContentType, so it MUST be included.
   */
  uploadToS3: async (
    signedUrl: string,
    file: File,
    contentType: string,
  ): Promise<void> => {
    const response = await fetch(signedUrl, {
      method: "PUT",
      headers: {
        "Content-Type": contentType,
      },
      body: file,
    });

    if (!response.ok) {
      throw new Error(
        `S3 Upload failed: ${response.status} ${response.statusText}`,
      );
    }
  },

  //3. Get a long-lived GET URL for a previously uploaded file
  getPermanentUrl: async (s3Key: string): Promise<PermanentUrlResponse> => {
    const orgId = getCurrentOrgId();
    // Keep slashes intact for FastAPI's :path parameter
    const safeS3Key = s3Key.split("/").map(encodeURIComponent).join("/");
    return apiService.get<PermanentUrlResponse>(
      UPLOAD_ENDPOINTS.PERMANENT_URL(orgId, safeS3Key),
    );
  },

  //4. Delete an uploaded file from S3
  deleteFile: async (s3Key: string): Promise<{ message: string }> => {
    const orgId = getCurrentOrgId();
    const safeS3Key = s3Key.split("/").map(encodeURIComponent).join("/");
    return apiService.delete<{ message: string }>(
      UPLOAD_ENDPOINTS.DELETE_FILE(orgId, safeS3Key),
    );
  },

  //Orchestrated flow: Presigned -> Upload -> Permanent URL
  uploadFile: async (
    file: File,
    location?: string,
  ): Promise<{ s3Key: string; url: string }> => {
    // Automatically detect the proper Content-Type for AWS S3
    const contentType = getContentType(file);

    // Stage 1: Get Presigned URL
    const { presigned_url, s3_key } = await uploadService.getPresignedUrl(
      file.name,
      contentType,
      file.size,
      location,
    );

    // Stage 2: Upload to S3
    await uploadService.uploadToS3(presigned_url, file, contentType);

    // Stage 3: Get the permanent URL for preview/storage
    const { download_url } = await uploadService.getPermanentUrl(s3_key);

    return { s3Key: s3_key, url: download_url };
  },
};

export default uploadService;
