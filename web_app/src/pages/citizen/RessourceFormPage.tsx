import { useEffect, useState } from 'react';
import { useNavigate, useParams, Navigate } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import * as categoriesApi from '../../api/categories';
import * as typeRelationsApi from '../../api/typeRelations';
import type { Categorie, RessourceRequest, TypeRelation, TypeRessource, Visibilite } from '../../types';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import './RessourceFormPage.css';

const TYPES: TypeRessource[] = ['ARTICLE', 'VIDEO', 'AUDIO', 'ACTIVITE', 'JEU', 'PODCAST', 'DOCUMENT', 'LIEN'];
const TYPE_LABELS: Record<TypeRessource, string> = {
  ARTICLE: 'Article', VIDEO: 'Vidéo', AUDIO: 'Audio', ACTIVITE: 'Activité',
  JEU: 'Jeu', PODCAST: 'Podcast', DOCUMENT: 'Document', LIEN: 'Lien',
};
const VISIBILITES: { value: Visibilite; label: string }[] = [
  { value: 'PUBLIQUE', label: 'Publique — visible de tous' },
  { value: 'PRIVEE', label: 'Privée — visible uniquement par moi' },
  { value: 'PARTAGEE', label: 'Partagée — visible des membres connectés' },
];

export default function RessourceFormPage() {
  const { id } = useParams<{ id: string }>();
  const isEdit = Boolean(id);
  const { user, loading: authLoading } = useAuth();
  const navigate = useNavigate();

  const [form, setForm] = useState<RessourceRequest>({
    titre: '', description: '', contenu: '',
    type: 'ARTICLE', visibilite: 'PUBLIQUE',
    categorieId: undefined, typesRelationIds: [],
    urlExterne: '', dureeEstimeeMin: undefined,
  });
  const [categories, setCategories] = useState<Categorie[]>([]);
  const [typeRelations, setTypeRelations] = useState<TypeRelation[]>([]);
  const [loading, setLoading] = useState(false);
  const [initLoading, setInitLoading] = useState(isEdit);
  const [error, setError] = useState('');
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});

  if (!authLoading && !user) return <Navigate to="/connexion" replace />;

  useEffect(() => {
    categoriesApi.lister().then(setCategories);
    typeRelationsApi.lister().then(setTypeRelations);
    if (isEdit && id) {
      ressourcesApi.getById(parseInt(id))
        .then((r) => {
          setForm({
            titre: r.titre, description: r.description, contenu: r.contenu,
            type: r.type, visibilite: r.visibilite,
            categorieId: r.categorie?.id,
            typesRelationIds: r.typesRelation.map(t => t.id),
            urlExterne: r.urlExterne ?? '',
            dureeEstimeeMin: r.dureeEstimeeMin,
          });
        })
        .finally(() => setInitLoading(false));
    }
  }, []);

  const setField = <K extends keyof RessourceRequest>(key: K, value: RessourceRequest[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const toggleRelation = (id: number) => {
    const ids = form.typesRelationIds ?? [];
    setField('typesRelationIds', ids.includes(id) ? ids.filter(i => i !== id) : [...ids, id]);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setFieldErrors({});

    const validationErrors: Record<string, string> = {};
    if (!form.categorieId) validationErrors.categorieId = 'Veuillez sélectionner une catégorie.';
    if (!form.typesRelationIds || form.typesRelationIds.length === 0)
      validationErrors.typesRelationIds = 'Veuillez sélectionner au moins un type de relation.';
    if (Object.keys(validationErrors).length > 0) {
      setFieldErrors(validationErrors);
      return;
    }

    setLoading(true);
    try {
      const payload = { ...form, urlExterne: form.urlExterne || undefined };
      if (isEdit && id) await ressourcesApi.modifier(parseInt(id), payload);
      else await ressourcesApi.creer(payload);
      navigate('/mon-espace/mes-ressources');
    } catch (err: any) {
      const data = err.response?.data;
      if (data?.erreurs) setFieldErrors(data.erreurs);
      setError(data?.message ?? 'Erreur lors de la sauvegarde.');
    } finally {
      setLoading(false);
    }
  };

  if (initLoading) return <div className="container" style={{ padding: '3rem 0' }}><LoadingSpinner /></div>;

  return (
    <div className="ressource-form-page container">
      <h1>{isEdit ? 'Modifier la ressource' : 'Créer une ressource'}</h1>

      <form onSubmit={handleSubmit} className="ressource-form" noValidate>
        <div className="form-grid">
          <div className="form-main">
            <div className="form-group">
              <label htmlFor="titre">Titre <span className="required">*</span></label>
              <input
                id="titre" type="text" className="form-input"
                value={form.titre} onChange={(e) => setField('titre', e.target.value)}
                required maxLength={200} placeholder="Titre de la ressource"
              />
            </div>

            <div className="form-group">
              <label htmlFor="description">Description courte <span className="required">*</span></label>
              <textarea
                id="description" className="form-textarea" rows={3}
                value={form.description} onChange={(e) => setField('description', e.target.value)}
                required maxLength={500} placeholder="Résumé de la ressource…"
              />
            </div>

            <div className="form-group">
              <label htmlFor="contenu">Contenu <span className="required">*</span></label>
              <textarea
                id="contenu" className="form-textarea contenu-area" rows={12}
                value={form.contenu} onChange={(e) => setField('contenu', e.target.value)}
                required placeholder="Contenu détaillé de la ressource…"
              />
            </div>

            <div className="form-group">
              <label htmlFor="urlExterne">URL externe (optionnel)</label>
              <input
                id="urlExterne" type="url" className="form-input"
                value={form.urlExterne ?? ''} onChange={(e) => setField('urlExterne', e.target.value)}
                placeholder="https://..."
              />
            </div>
          </div>

          <aside className="form-sidebar">
            <div className="form-card">
              <h3>Publication</h3>

              <div className="form-group">
                <label htmlFor="type">Type de ressource</label>
                <select id="type" className="form-select"
                  value={form.type} onChange={(e) => setField('type', e.target.value as TypeRessource)}>
                  {TYPES.map(t => <option key={t} value={t}>{TYPE_LABELS[t]}</option>)}
                </select>
              </div>

              <div className="form-group">
                <label htmlFor="visibilite">Visibilité</label>
                <select id="visibilite" className="form-select"
                  value={form.visibilite} onChange={(e) => setField('visibilite', e.target.value as Visibilite)}>
                  {VISIBILITES.map(v => <option key={v.value} value={v.value}>{v.label}</option>)}
                </select>
              </div>

              <div className="form-group">
                <label htmlFor="categorie">Catégorie <span className="required">*</span></label>
                <select id="categorie" className="form-select"
                  value={form.categorieId ?? ''}
                  onChange={(e) => setField('categorieId', e.target.value ? parseInt(e.target.value) : undefined)}>
                  <option value="">— Sélectionner une catégorie —</option>
                  {categories.map(c => <option key={c.id} value={c.id}>{c.nom}</option>)}
                </select>
                {fieldErrors.categorieId && <p className="field-error">{fieldErrors.categorieId}</p>}
              </div>

              <div className="form-group">
                <label htmlFor="duree">Durée estimée (minutes)</label>
                <input id="duree" type="number" className="form-input" min={1}
                  value={form.dureeEstimeeMin ?? ''}
                  onChange={(e) => setField('dureeEstimeeMin', e.target.value ? parseInt(e.target.value) : undefined)}
                  placeholder="ex: 30"
                />
              </div>
            </div>

            <div className="form-card">
              <h3>Types de relations <span className="required">*</span></h3>
              <div className="relations-check">
                {typeRelations.map(t => (
                  <label key={t.id} className="check-option">
                    <input
                      type="checkbox"
                      checked={(form.typesRelationIds ?? []).includes(t.id)}
                      onChange={() => toggleRelation(t.id)}
                    />
                    {t.libelle}
                  </label>
                ))}
              </div>
              {fieldErrors.typesRelationIds && <p className="field-error">{fieldErrors.typesRelationIds}</p>}
            </div>
          </aside>
        </div>

        {error && <div role="alert" className="form-error-box">{error}</div>}

        <div className="form-actions">
          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? 'Sauvegarde…' : isEdit ? 'Enregistrer les modifications' : 'Créer la ressource'}
          </button>
          <button type="button" className="btn btn-outline" onClick={() => navigate(-1)} disabled={loading}>
            Annuler
          </button>
        </div>
      </form>
    </div>
  );
}
