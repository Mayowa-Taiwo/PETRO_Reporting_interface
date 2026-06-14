const TOKEN_KEY = "edip_token";

/** Browser calls same-origin proxy (no CORS). Set NEXT_PUBLIC_API_URL to hit the API directly. */
export function getApiBase(): string {
  const direct = process.env.NEXT_PUBLIC_API_URL?.trim();
  if (direct) return direct;
  if (typeof window !== "undefined") return "/api/edip";
  return process.env.EDIP_API_INTERNAL_URL?.trim() || "http://127.0.0.1:8001";
}

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

export async function apiFetch(path: string, options: RequestInit = {}): Promise<Response> {
  const headers = new Headers(options.headers);
  if (typeof window !== "undefined") {
    const t = getToken();
    if (t) headers.set("Authorization", `Bearer ${t}`);
  }
  return fetch(`${getApiBase()}${path}`, { ...options, headers });
}
