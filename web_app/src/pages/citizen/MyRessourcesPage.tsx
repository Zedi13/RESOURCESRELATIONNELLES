import { useEffect, useState, useCallback } from 'react';
import { Link, Navigate } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import type { RessourceSummary } from '../../types';
import Badge from '../../components/common/Badge';
import Pagination from '../../components/common/Pagination';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import Modal from '../../components/common/Modal';
import { useAuth } from '../../contexts/AuthContext';

export default function MyRessourcesPage() {
  const { user, loading: authLoading } = useAuth();
  const [ressources, setRessources] = useState<RessourceSummary[]>([]);
  const [totalPages, setTotalPages] = useState(0);
  const [page, setPage] = useState(0);
  const [loading, setLoading] = useState(true);
  const [deleteId, setDeleteId] = useState<number | null>(null);

  if (!authLoading && !user) return <Navigate to="/connexion" replace />;

  const fetch = useCallback(() => {
    setLoading(true);
    ressourcesApi.listerMesCreations({ page, size: 15 })
      .then((r) => { setRessources(r.content); setTotalPages(r.totalPages); })
      .finally(() => setLoading(false));
  }, [page]);

  useEffect(() => { fetch(); }, [fetch]);

  const confirmDelete = async () => {
    if (!deleteId) return;
    await ressourcesApi.supprimer(deleteId);
    setDeleteId(null);
    fetch();
  };

  return (
    <div className="container" style={{ paddingBlock: '2rem' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1.5rem' }}>
        <h1 style={{ fontSize: '1.5rem', fontWeight: 700, margin: 0 }}>Mes ressources</h1>
        <Link to="/mon-espace/creer" className="btn btn-primary">+ Créer</Link>
      </div>

      {loading ? <LoadingSpinner /> : ressources.length === 0 ? (
        <div className="empty-state" style={{ textAlign: 'center', padding: '3rem', color: 'var(--color-text-muted)' }}>
          <p>Vous n'avez pas encore créé de ressource.</p>
          <Link to="/mon-espace/creer" className="btn btn-primary">Créer ma première ressource</Link>
        </div>
      ) : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th>Titre</th>
                <th>Type</th>
                <th>Statut</th>
                <th>Visibilité</th>
                <th>Vues</th>
                <th>Date</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {ressources.map((r) => (
                <tr key={r.id}>
                  <td><Link to={`/ressources/${r.id}`}>{r.titre}</Link></td>
                  <td><Badge type={r.type} /></td>
                  <td><Badge statut={r.statut} /></td>
                  <td><Badge visibilite={r.visibilite} /></td>
                  <td>{r.vues}</td>
                  <td>{new Date(r.dateCreation).toLocaleDateString('fr-FR')}</td>
                  <td>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                      <Link to={`/mon-espace/modifier/${r.id}`} className="btn btn-outline btn-xs">Modifier</Link>
                      <button className="btn btn-danger btn-xs" onClick={() => setDeleteId(r.id)} type="button">Supprimer</button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <Pagination page={page} totalPages={totalPages} onChange={setPage} />
        </div>
      )}

      <Modal
        open={deleteId !== null}
        title="Confirmer la suppression"
        onClose={() => setDeleteId(null)}
        actions={
          <>
            <button className="btn btn-danger" onClick={confirmDelete} type="button">Supprimer</button>
            <button className="btn btn-outline" onClick={() => setDeleteId(null)} type="button">Annuler</button>
          </>
        }
      >
        <p>Êtes-vous sûr de vouloir supprimer cette ressource ? Cette action est irréversible.</p>
      </Modal>
    </div>
  );
}
