import { CorporateEmployee } from "../types";

export const MOCK_CORPORATE_EMPLOYEES: CorporateEmployee[] = [
  {
    id: 1,
    employee_code: "EMP-001",
    user_id: 105,
    name: "John Doe",
    phone: "+1234567890",
    spending_limit: 5000,
    amount_spent: 1200,
    status: "ACTIVE",
  },
  {
    id: 2,
    employee_code: "EMP-002",
    user_id: 106,
    name: "Jane Smith",
    phone: "+1987654321",
    spending_limit: 3000,
    amount_spent: 2950, // Nearing limit
    status: "ACTIVE",
  },
  {
    id: 3,
    employee_code: "EMP-003",
    name: "Alice Johnson",
    phone: "+1555666777",
    spending_limit: 10000,
    amount_spent: 0,
    status: "INACTIVE",
  },
];
