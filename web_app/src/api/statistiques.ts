import client from './client';
import type { StatistiquesResponse } from '../types';

export const getDashboard = () =>
  client.get<StatistiquesResponse>('/api/statistiques').then((r) => r.data);

export const exportCsv = () =>
  client.get('/api/statistiques/export', { responseType: 'blob' }).then((r) => r.data as Blob);
