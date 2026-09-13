export interface Company {
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
}

export type CreateCompanyRequest = Omit<Company, "id" | "current_balance">;
export type UpdateCompanyRequest = Partial<CreateCompanyRequest & { status: Company["status"] }>;
