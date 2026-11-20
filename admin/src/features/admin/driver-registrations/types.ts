export interface DriverRegistrationSummary {
  id?: number;
  registration_id: number;
  user_id: number;
  driver_name: string;
  phone: string;
  vehicle: string;
  status: string;
  progress_percentage: number;
  submitted_at: string | null;
  updated_at: string;
}

export interface DriverPersonalInfo {
  first_name: string;
  last_name: string;
  mobile_number: string;
  email?: string | null;
  dob: string;
  gender: string;
  referral_code?: string;
  profile_photo_url?: string | null;
}

export interface KYCDocumentRead {
  id: number;
  document_type: string;
  document_number_masked?: string | null;
  file_url: string;
  verification_status: string;
  rejection_reason?: string | null;
}

export interface VehicleDetailRead {
  id: number;
  registration_id: number;
  vehicle_type_id: number;
  compenyName: string;
  vehicalModel: string;
  registrationNumber: string;
  registrationyear: number;
  registrationcolor: string;
  chassisNumber: string;
  engineNumber: string;
  total_seats: number;
  fuel_type: string;
  documents?: VehicleDocumentRead[];
}

export interface VehicleDocumentRead {
  id: number;
  vehicle_id: number;
  document_type: string;
  document_number: string | null;
  issue_date: string | null;
  expiry_date: string | null;
  file_url: string;
  verification_status: string;
  rejection_reason: string | null;
  created_at: string;
}

export interface AddressRead {
  id: number;
  registration_id: number;
  house_no: string;
  street_area: string;
  landmark: string;
  pincode: string;
  city: string;
  state: string;
  latitude: number;
  longitude: number;
}

export interface BankAccountRead {
  id: number;
  registration_id: number;
  account_holder_name: string;
  bank_name: string;
  ifsc_code: string;
  account_number_masked: string;
  upi_id: string;
  cancelled_cheque_url: string;
  verification_status: string;
}

export interface EmergencyContactRead {
  id: number;
  registration_id: number;
  contact_name: string;
  relationship_type: string;
  phone_number: string;
}

export interface DriverRegistrationDetail {
  id?: number;
  registration_id: number;
  user_id: number;
  status: string;
  submitted_at?: string | null;
  progress_percentage: number;
  personal_info: DriverPersonalInfo | null;
  vehicle_detail: VehicleDetailRead | null;
  kyc_documents: KYCDocumentRead[];
  address: AddressRead | null;
  bank_account: BankAccountRead | null;
  emergency_contact: EmergencyContactRead | null;
  terms_accepted?: boolean;
  privacy_policy_accepted?: boolean;
}
