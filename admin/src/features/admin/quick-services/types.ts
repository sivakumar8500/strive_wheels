export interface QuickService {
  id: number;
  title: string;
  subtitle?: string | null;
  icon_url?: string | null;
  service_code: string;
  display_order: number;
  is_active: boolean;
  created_at?: string;
}

export type CreateQuickServiceRequest = Omit<QuickService, "id" | "display_order" | "created_at">;
export type UpdateQuickServiceRequest = Partial<CreateQuickServiceRequest>;

export interface ReorderQuickServicesRequest {
  items: QuickService[];
}

