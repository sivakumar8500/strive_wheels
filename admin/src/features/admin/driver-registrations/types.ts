export interface DriverDocument {
  id: number;
  document_type: string;
  document_url: string;
  status: "PENDING" | "APPROVED" | "REJECTED";
  rejection_reason: string | null;
  uploaded_at: string;
}

export interface DriverPersonalInfo {
  first_name: string;
  last_name: string;
  mobile_number: string;
}

export interface DriverVehicleDetails {
  vehicle_type_id: number;
  make: string;
  model: string;
  plate_number: string;
}

export interface DriverRegistration {
  id: number;
  user_id: number;
  status: "PENDING" | "APPROVED" | "REJECTED";
  current_step: number;
  progress_percentage: number;
  submitted_at: string;
  personal_info: DriverPersonalInfo;
  vehicle_details: DriverVehicleDetails;
  documents: DriverDocument[];
}
