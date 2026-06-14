const TOKEN_KEY = "edip_token";

export function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string): void {
  if (typeof window === "undefined") return;
  localStorage.setItem(TOKEN_KEY, token);
}

export function removeToken(): void {
  if (typeof window === "undefined") return;
  localStorage.removeItem(TOKEN_KEY);
}

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8007";

export type ApiFetchOptions = RequestInit & { skipAuth?: boolean };

/** Fetch with optional Bearer token. Use for admin/jobs; use plain fetch for public endpoints. */
export async function apiFetch(
  path: string,
  options: ApiFetchOptions = {}
): Promise<Response> {
  const { skipAuth, ...init } = options;
  const headers = new Headers(init.headers);
  if (!skipAuth && typeof window !== "undefined") {
    const t = getToken();
    if (t) headers.set("Authorization", `Bearer ${t}`);
  }
  return fetch(`${API_BASE}${path}`, { ...init, headers });
}
