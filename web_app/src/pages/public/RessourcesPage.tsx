import { useEffect, useState, useCallback } from 'react';
import { useSearchParams } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import * as categoriesApi from '../../api/categories';
import * as typeRelationsApi from '../../api/typeRelations';
import type { Categorie, RessourceSummary, TypeRelation, TypeRessource } from '../../types';
import RessourceCard from '../../components/common/RessourceCard';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import './RessourcesPage.css';

const TYPES: TypeRessource[] = ['ARTICLE', 'VIDEO', 'AUDIO', 'ACTIVITE', 'JEU', 'PODCAST', 'DOCUMENT', 'LIEN'];
const TYPE_LABELS: Record<TypeRessource, string> = {
  ARTICLE: 'Article', VIDEO: 'Vidéo', AUDIO: 'Audio',
  ACTIVITE: 'Activité', JEU: 'Jeu', PODCAST: 'Podcast',
  DOCUMENT: 'Document', LIEN: 'Lien',
};

export default function RessourcesPage() {
  const [params, setParams] = useSearchParams();
  const { user } = useAuth();

  const [ressources, setRessources] = useState<RessourceSummary[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState<Categorie[]>([]);
  const [typeRelations, setTypeRelations] = useState<TypeRelation[]>([]);
  const [selectedRelations, setSelectedRelations] = useState<number[]>([]);

  const search = params.get('search') ?? '';
  const categorieId = params.get('categorieId') ? parseInt(params.get('categorieId')!) : undefined;
  const type = (params.get('type') ?? '') as TypeRessource | '';

  const fetch = useCallback(() => {
    setLoading(true);
    const filters = { page: 0, search: search || undefined, categorieId, type: type || undefined, size: 1000 };
    const fn = user ? ressourcesApi.listerAccessibles : ressourcesApi.listerPubliques;
    fn(filters)
      .then((r) => { setRessources(r.content); setTotal(r.totalElements); })
      .finally(() => setLoading(false));
  }, [search, categorieId, type, user]);

  useEffect(() => { fetch(); }, [fetch]);

  useEffect(() => {
    categoriesApi.lister().then(setCategories);
    typeRelationsApi.lister().then(setTypeRelations);
  }, []);

  const set = (key: string, value: string) => {
    const next = new URLSearchParams(params);
    if (value) next.set(key, value); else next.delete(key);
    setParams(next);
  };

  const toggleRelation = (id: number) => {
    setSelectedRelations(prev =>
      prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]
    );
  };

  const filteredRessources = selectedRelations.length === 0
    ? ressources
    : ressources.filter(r =>
        selectedRelations.every(id => (r.typesRelation ?? []).some(t => t.id === id))
      );

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
                <input
                  type="checkbox"
                  checked={selectedRelations.includes(t.id)}
                  onChange={() => toggleRelation(t.id)}
                />
                {t.libelle}
              </label>
            ))}
          </div>
        </div>

        {(search || categorieId || type || selectedRelations.length > 0) && (
          <button className="btn btn-outline btn-sm" onClick={() => { setParams(new URLSearchParams()); setSelectedRelations([]); }}>
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

        {loading ? <LoadingSpinner /> : filteredRessources.length === 0 ? (
          <div className="empty-state">
            <p>Aucune ressource ne correspond à votre recherche.</p>
            <button className="btn btn-outline" onClick={() => { setParams(new URLSearchParams()); setSelectedRelations([]); }}>
              Effacer les filtres
            </button>
          </div>
        ) : (
          <>
            <div className="ressources-grid">
              {filteredRessources.map((r) => (
                <RessourceCard key={r.id} ressource={r} onUpdate={(updated) => setRessources(prev => prev.map(x => x.id === updated.id ? updated : x))} />
              ))}
            </div>
</>
        )}
      </div>
    </div>
  );
}
