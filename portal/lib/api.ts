const TOKEN_KEY = "edip_token";

export function getEdipApiBase(): string {
  if (typeof window !== "undefined") return "/api/edip";
  return (process.env.EDIP_API_PROXY_TARGET || "http://127.0.0.1:8000").replace(/\/$/, "");
}

export function getGovernanceApiBase(): string {
  if (typeof window !== "undefined") return "/api/governance";
  return (process.env.GOVERNANCE_API_PROXY_TARGET || "http://127.0.0.1:8007").replace(/\/$/, "");
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

async function apiFetch(base: string, path: string, options: RequestInit = {}): Promise<Response> {
  const headers = new Headers(options.headers);
  if (typeof window !== "undefined") {
    const t = getToken();
    if (t) headers.set("Authorization", `Bearer ${t}`);
  }
  return fetch(`${base}${path}`, { ...options, headers });
}

export function edipFetch(path: string, options: RequestInit = {}): Promise<Response> {
  return apiFetch(getEdipApiBase(), path, options);
}

export function governanceFetch(path: string, options: RequestInit = {}): Promise<Response> {
  return apiFetch(getGovernanceApiBase(), path, options);
}
