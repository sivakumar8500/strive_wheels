import { APIRequestContext, request } from "@playwright/test";
import { getEnvironment } from "@/config/environments";

export class ApiClient {
  private requestContext: APIRequestContext | null = null;
  private token: string | null = null;
  private readonly baseUrl: string;

  constructor(token?: string) {
    this.baseUrl = getEnvironment().apiUrl;
    this.token = token || null;
  }

  async init(): Promise<void> {
    if (!this.requestContext) {
      const headers: Record<string, string> = {
        "Content-Type": "application/json",
        Accept: "application/json",
      };
      if (this.token) {
        headers["Authorization"] = `Bearer ${this.token}`;
      }
      this.requestContext = await request.newContext({
        baseURL: this.baseUrl,
        extraHTTPHeaders: headers,
      });
    }
  }

  setToken(token: string): void {
    this.token = token;
    this.requestContext = null; // Forces re-initialization with new token
  }

  async get<T>(endpoint: string, params?: Record<string, any>): Promise<T> {
    await this.init();
    const response = await this.requestContext!.get(endpoint, { params });
    if (!response.ok()) {
      throw new Error(`API GET ${endpoint} failed with ${response.status()}: ${await response.text()}`);
    }
    return (await response.json()) as T;
  }

  async post<T>(endpoint: string, data?: any): Promise<T> {
    await this.init();
    const response = await this.requestContext!.post(endpoint, { data });
    if (!response.ok()) {
      throw new Error(`API POST ${endpoint} failed with ${response.status()}: ${await response.text()}`);
    }
    return (await response.json()) as T;
  }

  async put<T>(endpoint: string, data?: any): Promise<T> {
    await this.init();
    const response = await this.requestContext!.put(endpoint, { data });
    if (!response.ok()) {
      throw new Error(`API PUT ${endpoint} failed with ${response.status()}: ${await response.text()}`);
    }
    return (await response.json()) as T;
  }

  async delete<T>(endpoint: string): Promise<T> {
    await this.init();
    const response = await this.requestContext!.delete(endpoint);
    if (!response.ok()) {
      throw new Error(`API DELETE ${endpoint} failed with ${response.status()}: ${await response.text()}`);
    }
    return (await response.json()) as T;
  }

  async dispose(): Promise<void> {
    if (this.requestContext) {
      await this.requestContext.dispose();
      this.requestContext = null;
    }
  }
}
