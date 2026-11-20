/**
 * Collision-free random data utilities for test data generation
 */
export class RandomUtils {
  static getTimestamp(): number {
    return Date.now();
  }

  static getRandomString(length: number = 8): string {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    let result = "";
    for (let i = 0; i < length; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }

  static getRandomEmail(prefix: string = "test"): string {
    return `${prefix}_${Date.now()}_${RandomUtils.getRandomString(4)}@example.com`;
  }

  static getRandomPhone(): string {
    // 10 digit phone starting with 98
    const suffix = Math.floor(10000000 + Math.random() * 90000000);
    return `+9198${suffix.toString().slice(0, 8)}`;
  }

  static getRandomName(prefix: string = "User"): { firstName: string; lastName: string } {
    const randomSuffix = RandomUtils.getRandomString(5);
    return {
      firstName: `${prefix}`,
      lastName: `${randomSuffix.charAt(0).toUpperCase() + randomSuffix.slice(1)}`,
    };
  }

  static getRandomCode(prefix: string = "PROMO"): string {
    return `${prefix}${Math.floor(1000 + Math.random() * 9000)}`;
  }

  static getRandomNumber(min: number = 10, max: number = 100): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
}
