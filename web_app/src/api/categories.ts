import client from './client';
import type { Categorie } from '../types';

export const lister = () =>
  client.get<Categorie[]>('/api/categories').then((r) => r.data);

export const listerToutes = () =>
  client.get<Categorie[]>('/api/categories/toutes').then((r) => r.data);

export const creer = (data: { nom: string; description?: string; couleur?: string }) =>
  client.post<Categorie>('/api/categories', data).then((r) => r.data);

export const modifier = (id: number, data: { nom: string; description?: string; couleur?: string }) =>
  client.put<Categorie>(`/api/categories/${id}`, data).then((r) => r.data);

export const supprimer = (id: number) =>
  client.delete(`/api/categories/${id}`);
