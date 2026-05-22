import client from './client';
import type { ProgressionResponse } from '../types';

export const getDashboard = () =>
  client.get<ProgressionResponse>('/api/progression').then((r) => r.data);

export const ajouterFavori = (id: number) =>
  client.post(`/api/progression/favoris/${id}`);

export const retirerFavori = (id: number) =>
  client.delete(`/api/progression/favoris/${id}`);

export const marquerExploitee = (id: number) =>
  client.post(`/api/progression/exploitations/${id}`);

export const demarquerExploitee = (id: number) =>
  client.delete(`/api/progression/exploitations/${id}`);

export const sauvegarder = (id: number) =>
  client.post(`/api/progression/sauvegardes/${id}`);

export const retirerSauvegarde = (id: number) =>
  client.delete(`/api/progression/sauvegardes/${id}`);
