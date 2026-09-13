export interface QuickService {
  id: number;
  title: string;
  icon_url: string;
  target_screen: string;
  sort_order: number;
  is_active: boolean;
}

export type CreateQuickServiceRequest = Omit<QuickService, "id" | "sort_order">;
export type UpdateQuickServiceRequest = Partial<CreateQuickServiceRequest>;

export interface ReorderQuickServicesRequest {
  items: {
    id: number;
    sort_order: number;
  }[];
}
