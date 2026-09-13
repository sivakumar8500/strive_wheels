import { CompanyProfile } from "../types";

export const MOCK_COMPANY_PROFILE: CompanyProfile = {
  id: 1,
  company_name: "Tech Corp",
  registration_number: "TC12345",
  contact_person: "Jane Doe",
  contact_email: "jane@techcorp.com",
  contact_phone: "+1234567890",
  address: "123 Tech Park, Innovation Drive, CA 94043",
  billing_type: "PREPAID",
  credit_limit: 0,
  current_balance: 5000,
  status: "ACTIVE",
  stats: {
    active_employees: 45,
    active_shuttle_routes: 2,
    total_trips_this_month: 120,
    total_spend_this_month: 2500,
  },
};
