import { useEffect, useState, useCallback } from 'react';
import * as utilisateursApi from '../../api/utilisateurs';
import type { Role, Utilisateur } from '../../types';
import Badge from '../../components/common/Badge';
import Pagination from '../../components/common/Pagination';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import Modal from '../../components/common/Modal';
import { useAuth } from '../../contexts/AuthContext';

export default function AdminUsersPage() {
  const { isSuperAdmin } = useAuth();
  const [users, setUsers] = useState<Utilisateur[]>([]);
  const [totalPages, setTotalPages] = useState(0);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [createModal, setCreateModal] = useState(false);
  const [form, setForm] = useState({ nomComplet: '', email: '', motDePasse: '', role: 'MODERATEUR' as Role });
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});

  const fetch = useCallback(() => {
    setLoading(true);
    utilisateursApi.lister({ search: search || undefined, page })
      .then((r) => { setUsers(r.content); setTotalPages(r.totalPages); })
      .finally(() => setLoading(false));
  }, [page, search]);

  useEffect(() => { fetch(); }, [fetch]);

  const toggle = async (u: Utilisateur) => {
    if (u.estActif) await utilisateursApi.desactiver(u.id);
    else await utilisateursApi.activer(u.id);
    fetch();
  };

  const handleCreate = async () => {
    setError('');
    setFieldErrors({});
    setSaving(true);
    try {
      await utilisateursApi.creerComptePrivilegie(form);
      setCreateModal(false);
      fetch();
    } catch (e: any) {
      const data = e.response?.data;
      if (data?.erreurs) setFieldErrors(data.erreurs);
      else setError(data?.message ?? 'Erreur lors de la création');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="admin-page">
      <div className="admin-page-header">
        <h1>Utilisateurs</h1>
        {isSuperAdmin && (
          <button className="btn btn-primary" onClick={() => setCreateModal(true)} type="button">
            + Créer un compte privilégié
          </button>
        )}
      </div>

      <div className="filters-bar">
        <input
          type="search" className="form-input" placeholder="Rechercher par nom ou email…"
          value={search} onChange={(e) => { setSearch(e.target.value); setPage(0); }}
          style={{ maxWidth: 320 }}
        />
      </div>

      {loading ? <LoadingSpinner /> : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr><th>Nom</th><th>Email</th><th>Rôle</th><th>Vérifié</th><th>Actif</th><th>Inscription</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.id}>
                  <td><strong>{u.nomComplet}</strong></td>
                  <td>{u.email}</td>
                  <td><Badge role={u.role} /></td>
                  <td>{u.estVerifie ? '✓' : '✗'}</td>
                  <td>
                    <span className={`badge badge-${u.estActif ? 'success' : 'danger'}`}>
                      {u.estActif ? 'Actif' : 'Inactif'}
                    </span>
                  </td>
                  <td>{new Date(u.dateInscription).toLocaleDateString('fr-FR')}</td>
                  <td>
                    <button
                      type="button"
                      className={`btn btn-xs ${u.estActif ? 'btn-danger' : 'btn-outline'}`}
                      onClick={() => toggle(u)}
                    >
                      {u.estActif ? 'Désactiver' : 'Activer'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <Pagination page={page} totalPages={totalPages} onChange={setPage} />
        </div>
      )}

      <Modal
        open={createModal}
        title="Créer un compte privilégié"
        onClose={() => { setCreateModal(false); setError(''); setFieldErrors({}); }}
        actions={
          <>
            <button className="btn btn-primary" onClick={handleCreate} disabled={saving} type="button">
              {saving ? 'Création…' : 'Créer'}
            </button>
            <button className="btn btn-outline" onClick={() => setCreateModal(false)} type="button">Annuler</button>
          </>
        }
      >
        <div className="form-group">
          <label>Nom complet</label>
          <input type="text" className="form-input" value={form.nomComplet} onChange={(e) => setForm(p => ({ ...p, nomComplet: e.target.value }))} />
          {fieldErrors.nomComplet && <p className="form-error">{fieldErrors.nomComplet}</p>}
        </div>
        <div className="form-group">
          <label>Email</label>
          <input type="email" className="form-input" value={form.email} onChange={(e) => setForm(p => ({ ...p, email: e.target.value }))} />
          {fieldErrors.email && <p className="form-error">{fieldErrors.email}</p>}
        </div>
        <div className="form-group">
          <label>Mot de passe <span style={{ color: 'var(--color-text-muted)', fontWeight: 400, fontSize: '0.8em' }}>(8 caractères min.)</span></label>
          <input type="password" className="form-input" value={form.motDePasse} onChange={(e) => setForm(p => ({ ...p, motDePasse: e.target.value }))} />
          {fieldErrors.motDePasse && <p className="form-error">{fieldErrors.motDePasse}</p>}
        </div>
        <div className="form-group">
          <label>Rôle</label>
          <select className="form-select" value={form.role} onChange={(e) => setForm(p => ({ ...p, role: e.target.value as Role }))}>
            <option value="MODERATEUR">Modérateur</option>
            <option value="ADMIN">Administrateur</option>
            <option value="SUPER_ADMIN">Super-Administrateur</option>
          </select>
        </div>
        {error && <div className="form-error-box">{error}</div>}
      </Modal>
    </div>
  );
}
