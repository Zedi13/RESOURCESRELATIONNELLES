import client from './client';
import type { Commentaire, CommentaireRequest, ModerationCommentaireRequest, PageResponse, StatutCommentaire } from '../types';

export const listerApprouves = (ressourceId: number) =>
  client.get<Commentaire[]>(`/api/ressources/${ressourceId}/commentaires`).then((r) => r.data);

export const commenter = (ressourceId: number, data: CommentaireRequest) =>
  client.post<Commentaire>(`/api/ressources/${ressourceId}/commentaires`, data).then((r) => r.data);

export const supprimer = (id: number) =>
  client.delete(`/api/commentaires/${id}`);

export const moderer = (id: number, data: ModerationCommentaireRequest) =>
  client.patch<Commentaire>(`/api/commentaires/${id}/moderer`, data).then((r) => r.data);

export const listerAdmin = (filters: { statut?: StatutCommentaire; ressourceId?: number; page?: number } = {}) =>
  client.get<PageResponse<Commentaire>>('/api/admin/commentaires', {
    params: Object.fromEntries(Object.entries(filters).filter(([, v]) => v !== undefined)),
  }).then((r) => r.data);
