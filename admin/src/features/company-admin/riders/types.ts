export interface CompanyRider {
  id: number;
  driver_name: string;
  phone: string;
  route_assigned: string;
  start_date: string; // ISO date string
  end_date: string; // ISO date string
  status: "ACTIVE" | "EXPIRED" | "TERMINATED";
}

export interface AssignRiderRequest {
  driver_name: string;
  phone: string;
  route_assigned: string;
  start_date: string;
  end_date: string;
  status: "ACTIVE" | "EXPIRED" | "TERMINATED";
}

export interface UpdateRiderRequest {
  driver_name?: string;
  phone?: string;
  route_assigned?: string;
  start_date?: string;
  end_date?: string;
  status?: "ACTIVE" | "EXPIRED" | "TERMINATED";
}
