import AsyncStorage from '@react-native-async-storage/async-storage';

const DEFAULT_API_BASE_URL = process.env.EXPO_PUBLIC_API_BASE_URL || 'http://localhost:3000';

export type HttpMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';

export async function apiRequest<T>(path: string, opts: { method?: HttpMethod; body?: any; headers?: Record<string, string> } = {}): Promise<T> {
  const token = await AsyncStorage.getItem('authToken');
  const url = `${DEFAULT_API_BASE_URL}${path}`;
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(opts.headers || {}),
  };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const res = await fetch(url, {
    method: opts.method || 'GET',
    headers,
    body: opts.body ? JSON.stringify(opts.body) : undefined,
  });
  if (!res.ok) {
    let msg = `${res.status} ${res.statusText}`;
    try {
      const err = await res.json();
      msg = JSON.stringify(err);
    } catch {}
    throw new Error(msg);
  }
  const text = await res.text();
  try {
    return text ? (JSON.parse(text) as T) : ({} as T);
  } catch {
    // Fallback for CSV downloads etc.
    return (text as unknown) as T;
  }
}

export async function login(email: string, password: string): Promise<string> {
  const res = await apiRequest<{ token: string }>('/v1/auth/login', {
    method: 'POST',
    body: { email, password },
  });
  await AsyncStorage.setItem('authToken', res.token);
  return res.token;
}

export async function logout(): Promise<void> {
  await AsyncStorage.removeItem('authToken');
}
