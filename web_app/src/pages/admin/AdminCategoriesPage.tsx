import { useEffect, useState } from 'react';
import * as categoriesApi from '../../api/categories';
import type { Categorie } from '../../types';
import Modal from '../../components/common/Modal';
import LoadingSpinner from '../../components/common/LoadingSpinner';

export default function AdminCategoriesPage() {
  const [categories, setCategories] = useState<Categorie[]>([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState<'create' | 'edit' | null>(null);
  const [selected, setSelected] = useState<Categorie | null>(null);
  const [form, setForm] = useState({ nom: '', description: '', couleur: '#3b82f6' });
  const [deleteId, setDeleteId] = useState<number | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const fetch = () => {
    setLoading(true);
    categoriesApi.listerToutes().then(setCategories).finally(() => setLoading(false));
  };

  useEffect(() => { fetch(); }, []);

  const openCreate = () => { setForm({ nom: '', description: '', couleur: '#3b82f6' }); setSelected(null); setModal('create'); };
  const openEdit = (c: Categorie) => { setForm({ nom: c.nom, description: c.description ?? '', couleur: c.couleur ?? '#3b82f6' }); setSelected(c); setModal('edit'); };

  const handleSave = async () => {
    setError('');
    setSaving(true);
    try {
      if (modal === 'edit' && selected) await categoriesApi.modifier(selected.id, form);
      else await categoriesApi.creer(form);
      setModal(null);
      fetch();
    } catch (e: any) {
      setError(e.response?.data?.message ?? 'Erreur');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!deleteId) return;
    await categoriesApi.supprimer(deleteId);
    setDeleteId(null);
    fetch();
  };

  return (
    <div className="admin-page">
      <div className="admin-page-header">
        <h1>Catégories</h1>
        <button className="btn btn-primary" onClick={openCreate} type="button">+ Ajouter</button>
      </div>

      {loading ? <LoadingSpinner /> : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr><th>Nom</th><th>Description</th><th>Couleur</th><th>Ressources</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {categories.map((c) => (
                <tr key={c.id}>
                  <td>
                    {c.couleur && <span style={{ display: 'inline-block', width: 12, height: 12, borderRadius: '50%', background: c.couleur, marginRight: 6 }} />}
                    <strong>{c.nom}</strong>
                  </td>
                  <td>{c.description ?? '—'}</td>
                  <td>{c.couleur ?? '—'}</td>
                  <td>{c.nombreRessources ?? 0}</td>
                  <td>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                      <button className="btn btn-outline btn-xs" onClick={() => openEdit(c)} type="button">Modifier</button>
                      <button className="btn btn-danger btn-xs" onClick={() => setDeleteId(c.id)} type="button">Supprimer</button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <Modal
        open={modal !== null}
        title={modal === 'edit' ? 'Modifier la catégorie' : 'Nouvelle catégorie'}
        onClose={() => setModal(null)}
        actions={
          <>
            <button className="btn btn-primary" onClick={handleSave} disabled={saving} type="button">
              {saving ? 'Enregistrement…' : 'Enregistrer'}
            </button>
            <button className="btn btn-outline" onClick={() => setModal(null)} type="button">Annuler</button>
          </>
        }
      >
        <div className="form-group">
          <label htmlFor="cat-nom">Nom <span style={{ color: 'red' }}>*</span></label>
          <input id="cat-nom" type="text" className="form-input" value={form.nom} onChange={(e) => setForm(p => ({ ...p, nom: e.target.value }))} required />
        </div>
        <div className="form-group">
          <label htmlFor="cat-desc">Description</label>
          <textarea id="cat-desc" className="form-textarea" rows={2} value={form.description} onChange={(e) => setForm(p => ({ ...p, description: e.target.value }))} />
        </div>
        <div className="form-group">
          <label htmlFor="cat-color">Couleur (hex)</label>
          <input id="cat-color" type="color" className="form-input" value={form.couleur || '#3b82f6'} onChange={(e) => setForm(p => ({ ...p, couleur: e.target.value }))} style={{ height: 44 }} />
        </div>
        {error && <div className="form-error-box">{error}</div>}
      </Modal>

      <Modal
        open={deleteId !== null}
        title="Confirmer la suppression"
        onClose={() => setDeleteId(null)}
        actions={
          <>
            <button className="btn btn-danger" onClick={handleDelete} type="button">Supprimer</button>
            <button className="btn btn-outline" onClick={() => setDeleteId(null)} type="button">Annuler</button>
          </>
        }
      >
        <p>Supprimer cette catégorie ? Les ressources associées seront sans catégorie.</p>
      </Modal>
    </div>
  );
}
