import { RandomUtils } from "@/core/utils/random.utils";
import { UserRole } from "@/data/constants/roles";

export interface UserData {
  first_name: string;
  last_name: string;
  email: string;
  role: string;
  is_active: boolean;
}

export class UserBuilder {
  static valid(overrides: Partial<UserData> = {}): UserData {
    const { firstName, lastName } = RandomUtils.getRandomName("Admin");
    return {
      first_name: firstName,
      last_name: lastName,
      email: RandomUtils.getRandomEmail("admin"),
      role: UserRole.ADMIN,
      is_active: true,
      ...overrides,
    };
  }

  static superAdmin(overrides: Partial<UserData> = {}): UserData {
    return UserBuilder.valid({
      role: UserRole.SUPER_ADMIN,
      ...overrides,
    });
  }

  static companyAdmin(overrides: Partial<UserData> = {}): UserData {
    return UserBuilder.valid({
      role: UserRole.COMPANY_ADMIN,
      ...overrides,
    });
  }

  static invalidEmail(overrides: Partial<UserData> = {}): UserData {
    return UserBuilder.valid({
      email: "invalid-email-without-at-domain",
      ...overrides,
    });
  }

  static missingRequired(): Partial<UserData> {
    return {
      first_name: "",
      last_name: "",
      email: "",
      role: UserRole.ADMIN,
    };
  }
}
