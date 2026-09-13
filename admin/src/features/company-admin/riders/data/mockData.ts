import { CompanyRider } from "../types";

export const MOCK_COMPANY_RIDERS: CompanyRider[] = [
  {
    id: 1,
    driver_name: "Rajesh Kumar",
    phone: "+919876543210",
    route_assigned: "Cyber City to MG Road Metro",
    start_date: "2024-01-01",
    end_date: "2024-12-31",
    status: "ACTIVE",
  },
  {
    id: 2,
    driver_name: "Suresh Singh",
    phone: "+919876543211",
    route_assigned: "Airport Shuttle - Terminal 3",
    start_date: "2023-06-01",
    end_date: "2024-05-31",
    status: "EXPIRED",
  },
  {
    id: 3,
    driver_name: "Amit Patel",
    phone: "+919876543212",
    route_assigned: "Noida Sector 62 to Office Campus",
    start_date: "2024-02-15",
    end_date: "2025-02-14",
    status: "ACTIVE",
  },
];
