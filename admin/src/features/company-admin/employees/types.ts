export interface CorporateEmployee {
  id: number;
  employee_code?: string;
  user_id?: number; // Linked user in the Strive app
  name: string;
  phone: string;
  spending_limit: number;
  amount_spent: number;
  status: "ACTIVE" | "INACTIVE";
}

export interface CreateEmployeeRequest {
  employee_code?: string;
  name: string;
  phone: string;
  spending_limit: number;
  status: "ACTIVE" | "INACTIVE";
}

export interface UpdateEmployeeRequest {
  employee_code?: string;
  name?: string;
  phone?: string;
  spending_limit?: number;
  status?: "ACTIVE" | "INACTIVE";
}
