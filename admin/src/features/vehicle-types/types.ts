export interface VehicleType {
  id: number;
  code: string;
  name: string;
  description: string;
  icon_url: string;
  max_passengers: number;
  max_weight_kg: number;
  is_active: boolean;
  created_at: string;
}

export interface CreateVehicleTypeDto {
  code: string;
  name: string;
  description: string;
  icon_url: string;
  max_passengers: number;
  max_weight_kg: number;
  is_active: boolean;
}

export type UpdateVehicleTypeDto = Partial<CreateVehicleTypeDto>;
