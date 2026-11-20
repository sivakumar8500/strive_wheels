export enum UserRole {
  SUPER_ADMIN = 'super_admin',
  ADMIN = 'admin',
  COMPANY_ADMIN = 'company_admin',
  USER = 'user',
  RIDER = 'rider'
}

export interface Role {
  id: string;
  name: string;
  permissions: string[];
  created_at: string;
  updated_at: string;
}
