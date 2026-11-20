export interface AnnotatorProfilePayload {
  first_name?: string;
  last_name?: string;
  education?: string;
  location?: string;
  language?: string;
  availability?: string;
  skills?: string[];
  experience?: string;
  domain?: string;
  resume?: string;
  aht?: number;
  cost_per_hour?: number;
}

export interface AnnotatorProfileResponse {
  id: string;
  user_id: string;
  email: string;
  first_name: string;
  last_name: string;
  phone_number: string | null;
  cost_per_hour: number;
  domain: string;
  resume: string;
  quality: number;
  aht: number;
  location: string;
  education: string;
  experience: string;
  language: string;
  availability: string;
  skills: string[];
  total_time: number;
  total_amount: number;
  created_at: string;
  tasks_completed: number;
  total_tasks: number;
  campaigns_count: number;
  campaigns: unknown[];
  tasks: unknown[];
}
