import apiService from "./apiService";

export interface TempUploadResponse {
  file_id: number;
  filename: string;
  file_url: string;
  file_type: string;
  file_size: number;
}

/**
 * Temporary upload service for directly uploading files to a server endpoint
 * instead of using the S3 presigned URL flow.
 */
const tempUploadService = {
  uploadFile: async (file: File, location?: string): Promise<TempUploadResponse> => {
    const formData = new FormData();
    formData.append("file", file);
    if (location) {
      formData.append("location", location);
    }

    // Based on openapi.json
    const endpoint = "/files/upload"; 
    
    // Use apiService.post and ensure the browser sets the correct multipart boundary 
    // by NOT explicitly setting Content-Type (axios will automatically do it for FormData)
    const response = await apiService.post<{ success: boolean; data: TempUploadResponse }>(
      endpoint,
      formData,
      null, // token
      {}    // options
    );

    return response.data;
  },
};

export default tempUploadService;
