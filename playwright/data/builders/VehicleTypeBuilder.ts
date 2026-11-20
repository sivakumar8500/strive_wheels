import { RandomUtils } from "@/core/utils/random.utils";

export interface VehicleTypeData {
  code: string;
  name: string;
  description: string;
  max_passengers: number;
  max_weight_kg: number;
  is_active: boolean;
}

export class VehicleTypeBuilder {
  static valid(overrides: Partial<VehicleTypeData> = {}): VehicleTypeData {
    const codeSuffix = RandomUtils.getRandomString(4).toUpperCase();
    return {
      code: `VH_${codeSuffix}`,
      name: `Vehicle ${codeSuffix}`,
      description: "Standard comfort and capacity vehicle category",
      max_passengers: 4,
      max_weight_kg: 350,
      is_active: true,
      ...overrides,
    };
  }
}
