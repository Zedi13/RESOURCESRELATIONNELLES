import { useEffect, useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import type { RessourceSummary, StatutRessource } from '../../types';
import Badge from '../../components/common/Badge';
import Pagination from '../../components/common/Pagination';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import Modal from '../../components/common/Modal';

const STATUTS: StatutRessource[] = ['BROUILLON', 'EN_ATTENTE', 'PUBLIE', 'SUSPENDU', 'ARCHIVE'];

export default function AdminRessourcesPage() {
  const [ressources, setRessources] = useState<RessourceSummary[]>([]);
  const [totalPages, setTotalPages] = useState(0);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState('');
  const [statut, setStatut] = useState<StatutRessource | ''>('');
  const [loading, setLoading] = useState(true);
  const [moderating, setModerating] = useState<{ id: number; titre: string } | null>(null);
  const [newStatut, setNewStatut] = useState<StatutRessource>('PUBLIE');

  const fetch = useCallback(() => {
    setLoading(true);
    ressourcesApi.listerAdmin({ page, search: search || undefined, statut: statut || undefined, size: 20 })
      .then((r) => { setRessources(r.content); setTotalPages(r.totalPages); })
      .finally(() => setLoading(false));
  }, [page, search, statut]);

  useEffect(() => { fetch(); }, [fetch]);

  const handleModerate = async () => {
    if (!moderating) return;
    await ressourcesApi.changerStatut(moderating.id, { statut: newStatut });
    setModerating(null);
    fetch();
  };

  return (
    <div className="admin-page">
      <div className="admin-page-header">
        <h1>Gestion des ressources</h1>
      </div>

      <div className="filters-bar">
        <input
          type="search" className="form-input" placeholder="Rechercher…"
          value={search} onChange={(e) => { setSearch(e.target.value); setPage(0); }}
          style={{ maxWidth: 280 }}
        />
        <select className="form-select" value={statut}
          onChange={(e) => { setStatut(e.target.value as StatutRessource | ''); setPage(0); }}>
          <option value="">Tous les statuts</option>
          {STATUTS.map(s => <option key={s} value={s}>{s}</option>)}
        </select>
      </div>

      {loading ? <LoadingSpinner /> : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th>Titre</th><th>Type</th><th>Auteur</th><th>Statut</th>
                <th>Visibilité</th><th>Vues</th><th>Date</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {ressources.map((r) => (
                <tr key={r.id}>
                  <td><Link to={`/ressources/${r.id}`} target="_blank">{r.titre}</Link></td>
                  <td><Badge type={r.type} /></td>
                  <td>{r.auteurNom}</td>
                  <td><Badge statut={r.statut} /></td>
                  <td><Badge visibilite={r.visibilite} /></td>
                  <td>{r.vues}</td>
                  <td>{new Date(r.dateCreation).toLocaleDateString('fr-FR')}</td>
                  <td>
                    <button
                      type="button" className="btn btn-outline btn-xs"
                      onClick={() => { setModerating({ id: r.id, titre: r.titre }); setNewStatut(r.statut === 'PUBLIE' ? 'SUSPENDU' : 'PUBLIE'); }}
                    >
                      Modérer
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
        open={moderating !== null}
        title={`Modérer : ${moderating?.titre}`}
        onClose={() => setModerating(null)}
        actions={
          <>
            <button className="btn btn-primary" onClick={handleModerate} type="button">Confirmer</button>
            <button className="btn btn-outline" onClick={() => setModerating(null)} type="button">Annuler</button>
          </>
        }
      >
        <div className="form-group">
          <label htmlFor="new-statut">Nouveau statut</label>
          <select id="new-statut" className="form-select" value={newStatut}
            onChange={(e) => setNewStatut(e.target.value as StatutRessource)}>
            {STATUTS.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>
      </Modal>
    </div>
  );
}
