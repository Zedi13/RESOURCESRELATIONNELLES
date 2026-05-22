import client from './client';
import type {
  PageResponse, Ressource, RessourceSummary,
  RessourceRequest, ModerationRessourceRequest,
  StatutRessource, TypeRessource, Visibilite,
} from '../types';

export interface RessourceFilters {
  categorieId?: number;
  type?: TypeRessource;
  search?: string;
  page?: number;
  size?: number;
}

export interface AdminRessourceFilters extends RessourceFilters {
  statut?: StatutRessource;
  visibilite?: Visibilite;
  auteurId?: number;
}

const toParams = (f: Record<string, unknown>) =>
  Object.fromEntries(Object.entries(f).filter(([, v]) => v !== undefined && v !== ''));

export const listerPubliques = (filters: RessourceFilters = {}) =>
  client.get<PageResponse<RessourceSummary>>('/api/ressources', {
    params: toParams({ ...filters }),
  }).then((r) => r.data);

export const listerAccessibles = (filters: RessourceFilters = {}) =>
  client.get<PageResponse<RessourceSummary>>('/api/ressources/mes-ressources', {
    params: toParams({ ...filters }),
  }).then((r) => r.data);

export const getById = (id: number) =>
  client.get<Ressource>(`/api/ressources/${id}`).then((r) => r.data);

export const creer = (data: RessourceRequest) =>
  client.post<Ressource>('/api/ressources', data).then((r) => r.data);

export const modifier = (id: number, data: RessourceRequest) =>
  client.put<Ressource>(`/api/ressources/${id}`, data).then((r) => r.data);

export const supprimer = (id: number) =>
  client.delete(`/api/ressources/${id}`);

export const partager = (id: number) =>
  client.post(`/api/ressources/${id}/partager`);

export const listerMesCreations = (params: { page?: number; size?: number } = {}) =>
  client.get<PageResponse<RessourceSummary>>('/api/ressources/mes-creations', {
    params: toParams({ ...params }),
  }).then((r) => r.data);

export const listerAdmin = (filters: AdminRessourceFilters = {}) =>
  client.get<PageResponse<RessourceSummary>>('/api/ressources/admin', {
    params: toParams({ ...filters }),
  }).then((r) => r.data);

export const changerStatut = (id: number, data: ModerationRessourceRequest) =>
  client.patch<Ressource>(`/api/ressources/${id}/statut`, data).then((r) => r.data);
