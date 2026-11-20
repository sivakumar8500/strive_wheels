export interface CompanyProfile {
  id: number;
  company_name: string;
  registration_number: string;
  contact_person: string;
  contact_email: string;
  contact_phone: string;
  address: string;
  billing_type: "PREPAID" | "POSTPAID";
  credit_limit: number;
  current_balance: number;
  status: "ACTIVE" | "SUSPENDED" | "INACTIVE";
  stats: {
    active_employees: number;
    active_shuttle_routes: number;
    total_trips_this_month: number;
    total_spend_this_month: number;
  };
}
