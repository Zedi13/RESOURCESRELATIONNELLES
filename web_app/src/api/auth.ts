import client from './client';
import type { AuthResponse, LoginRequest, RegisterRequest, Utilisateur } from '../types';

export const login = (data: LoginRequest) =>
  client.post<AuthResponse>('/api/auth/login', data).then((r) => r.data);

export const register = (data: RegisterRequest) =>
  client.post<AuthResponse>('/api/auth/register', data).then((r) => r.data);

export const me = () =>
  client.get<Utilisateur>('/api/auth/me').then((r) => r.data);
