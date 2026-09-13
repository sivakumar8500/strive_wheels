export interface PopularLocation {
  id: number;
  name: string;
  address: string;
  latitude: number;
  longitude: number;
  category: string;
  is_active: boolean;
}

export type CreatePopularLocationRequest = Omit<PopularLocation, "id">;
export type UpdatePopularLocationRequest = Partial<CreatePopularLocationRequest>;
