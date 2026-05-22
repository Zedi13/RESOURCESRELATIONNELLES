import client from './client';
import type { TypeRelation } from '../types';

export const lister = () =>
  client.get<TypeRelation[]>('/api/type-relations').then((r) => r.data);
