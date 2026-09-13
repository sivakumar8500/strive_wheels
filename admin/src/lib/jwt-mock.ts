/**
 * This is a simple Base64-based "mock" JWT implementation for prototype purposes.
 * It encodes user data into a token string and decodes it back.
 */

export interface MockTokenPayload {
  sub: string; // userId
  email: string;
  role: string | string[];
  iat?: number;
  exp?: number;
}

/**
 * Encodes a JSON payload into a Base64-string "mock" JWT.
 */
export const encodeMockToken = (payload: MockTokenPayload): string => {
  try {
    const json = JSON.stringify({ ...payload, iat: new Date().getTime() });
    return btoa(json);
  } catch (err) {
    console.error("Error encoding mock token:", err);
    return "invalid-token";
  }
};

/**
 * Decodes a Base64-string "mock" JWT back into a JSON payload.
 */
export const decodeMockToken = <T = MockTokenPayload>(
  token: string,
): T | null => {
  try {
    const json = atob(token);
    return JSON.parse(json) as T;
  } catch {
    // console.warn("Invalid mock token decode attempt");
    return null;
  }
};
