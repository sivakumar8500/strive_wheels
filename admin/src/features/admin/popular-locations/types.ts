export interface PopularLocation {
  id: number;
  name: string;
  subtitle_desc?: string | null;
  category: string;
  address: string;
  latitude: number;
  longitude: number;
  image_url?: string | null;
  icon_name?: string | null;
  display_order?: number;
  is_active: boolean;
  created_at?: string;
}

export type CreatePopularLocationRequest = Omit<PopularLocation, "id" | "created_at">;
export type UpdatePopularLocationRequest = Partial<CreatePopularLocationRequest>;

