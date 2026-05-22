import client from './client';
import type { TypeRelation } from '../types';

export const lister = () =>
  client.get<TypeRelation[]>('/api/types-relation').then((r) => r.data);
