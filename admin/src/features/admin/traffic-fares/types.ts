export interface TrafficMultiplier {
  id?: number;
  traffic_code: string;
  multiplier: number;
  description: string;
  is_active: boolean;
}

export interface BulkUpdateTrafficRequest {
  items: TrafficMultiplier[];
}
