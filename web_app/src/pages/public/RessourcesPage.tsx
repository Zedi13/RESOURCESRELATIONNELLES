import { useEffect, useState, useCallback } from 'react';
import { useSearchParams } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import * as categoriesApi from '../../api/categories';
import * as typeRelationsApi from '../../api/typeRelations';
import type { Categorie, RessourceSummary, TypeRelation, TypeRessource } from '../../types';
import RessourceCard from '../../components/common/RessourceCard';
import Pagination from '../../components/common/Pagination';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import './RessourcesPage.css';

const TYPES: TypeRessource[] = ['ARTICLE', 'GUIDE', 'VIDEO', 'PODCAST', 'ACTIVITE', 'JEU', 'ATELIER', 'AUTRE'];
const TYPE_LABELS: Record<TypeRessource, string> = {
  ARTICLE: 'Article', GUIDE: 'Guide', VIDEO: 'Vidéo',
  PODCAST: 'Podcast', ACTIVITE: 'Activité', JEU: 'Jeu',
  ATELIER: 'Atelier', AUTRE: 'Autre',
};

export default function RessourcesPage() {
  const [params, setParams] = useSearchParams();
  const { user } = useAuth();

  const [ressources, setRessources] = useState<RessourceSummary[]>([]);
  const [totalPages, setTotalPages] = useState(0);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<Categorie[]>([]);
  const [typeRelations, setTypeRelations] = useState<TypeRelation[]>([]);

  const page = parseInt(params.get('page') ?? '0');
  const search = params.get('search') ?? '';
  const categorieId = params.get('categorieId') ? parseInt(params.get('categorieId')!) : undefined;
  const type = (params.get('type') ?? '') as TypeRessource | '';

  const fetch = useCallback(() => {
    setLoading(true);
    const filters = { page, search: search || undefined, categorieId, type: type || undefined, size: 12 };
    const fn = user ? ressourcesApi.listerAccessibles : ressourcesApi.listerPubliques;
    fn(filters)
      .then((r) => { setRessources(r.content); setTotalPages(r.totalPages); setTotal(r.totalElements); })
      .finally(() => setLoading(false));
  }, [page, search, categorieId, type, user]);

  useEffect(() => { fetch(); }, [fetch]);

  useEffect(() => {
    categoriesApi.lister().then(setCategories);
    typeRelationsApi.lister().then(setTypeRelations);
  }, []);

  const set = (key: string, value: string) => {
    const next = new URLSearchParams(params);
    if (value) next.set(key, value); else next.delete(key);
    next.delete('page');
    setParams(next);
  };

  return (
    <div className="ressources-page container">
      <div className="ressources-sidebar">
        <h2>Filtres</h2>

        <div className="filter-group">
          <label htmlFor="search-input">Recherche</label>
          <input
            id="search-input"
            type="search"
            className="form-input"
            placeholder="Titre, mot-clé…"
            value={search}
            onChange={(e) => set('search', e.target.value)}
            aria-label="Rechercher une ressource"
          />
        </div>

        <div className="filter-group">
          <fieldset>
            <legend>Type de ressource</legend>
            <div className="filter-options">
              <label className="filter-option">
                <input type="radio" name="type" value="" checked={!type} onChange={() => set('type', '')} />
                Tous
              </label>
              {TYPES.map((t) => (
                <label key={t} className="filter-option">
                  <input type="radio" name="type" value={t} checked={type === t} onChange={() => set('type', t)} />
                  {TYPE_LABELS[t]}
                </label>
              ))}
            </div>
          </fieldset>
        </div>

        <div className="filter-group">
          <label htmlFor="categorie-select">Catégorie</label>
          <select
            id="categorie-select"
            className="form-select"
            value={categorieId ?? ''}
            onChange={(e) => set('categorieId', e.target.value)}
          >
            <option value="">Toutes</option>
            {categories.map((c) => <option key={c.id} value={c.id}>{c.nom}</option>)}
          </select>
        </div>

        <div className="filter-group">
          <p className="filter-relations-title">Type de relation</p>
          <div className="filter-options">
            {typeRelations.map((t) => (
              <label key={t.id} className="filter-option">
                <input type="checkbox" disabled />
                {t.libelle}
              </label>
            ))}
          </div>
        </div>

        {(search || categorieId || type) && (
          <button className="btn btn-outline btn-sm" onClick={() => setParams(new URLSearchParams())}>
            Réinitialiser les filtres
          </button>
        )}
      </div>

      <div className="ressources-main">
        <div className="ressources-header">
          <h1>Ressources <span className="result-count">({total})</span></h1>
          {user && (
            <a href="/mon-espace/creer" className="btn btn-primary btn-sm">+ Créer une ressource</a>
          )}
        </div>

        {loading ? <LoadingSpinner /> : ressources.length === 0 ? (
          <div className="empty-state">
            <p>Aucune ressource ne correspond à votre recherche.</p>
            <button className="btn btn-outline" onClick={() => setParams(new URLSearchParams())}>
              Effacer les filtres
            </button>
          </div>
        ) : (
          <>
            <div className="ressources-grid">
              {ressources.map((r) => (
                <RessourceCard key={r.id} ressource={r} onUpdate={(updated) => setRessources(prev => prev.map(x => x.id === updated.id ? updated : x))} />
              ))}
            </div>
            <Pagination page={page} totalPages={totalPages} onChange={(p) => set('page', p.toString())} />
          </>
        )}
      </div>
    </div>
  );
}
