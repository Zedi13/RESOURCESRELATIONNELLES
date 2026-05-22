import client from './client';
import type { CreateUserRequest, PageResponse, Role, Utilisateur } from '../types';

export const lister = (filters: { role?: Role; actif?: boolean; search?: string; page?: number } = {}) =>
  client.get<PageResponse<Utilisateur>>('/api/utilisateurs', {
    params: Object.fromEntries(Object.entries(filters).filter(([, v]) => v !== undefined && v !== '')),
  }).then((r) => r.data);

export const activer = (id: number) =>
  client.patch<Utilisateur>(`/api/utilisateurs/${id}/activer`).then((r) => r.data);

export const desactiver = (id: number) =>
  client.patch<Utilisateur>(`/api/utilisateurs/${id}/desactiver`).then((r) => r.data);

export const creerComptePrivilegie = (data: CreateUserRequest) =>
  client.post<Utilisateur>('/api/utilisateurs', data).then((r) => r.data);
