import { useEffect, useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import * as commentairesApi from '../../api/commentaires';
import type { Commentaire, RessourceSummary } from '../../types';
import Badge from '../../components/common/Badge';
import Pagination from '../../components/common/Pagination';
import LoadingSpinner from '../../components/common/LoadingSpinner';

export default function AdminModerationPage() {
  const [tab, setTab] = useState<'ressources' | 'commentaires'>('ressources');
  const [ressources, setRessources] = useState<RessourceSummary[]>([]);
  const [commentaires, setCommentaires] = useState<Commentaire[]>([]);
  const [rPages, setRPages] = useState(0);
  const [cPages, setCPages] = useState(0);
  const [rPage, setRPage] = useState(0);
  const [cPage, setCPage] = useState(0);
  const [loading, setLoading] = useState(true);

  const fetchRessources = useCallback(() => {
    setLoading(true);
    ressourcesApi.listerAdmin({ statut: 'EN_ATTENTE', page: rPage })
      .then((r) => { setRessources(r.content); setRPages(r.totalPages); })
      .finally(() => setLoading(false));
  }, [rPage]);

  const fetchCommentaires = useCallback(() => {
    setLoading(true);
    commentairesApi.listerAdmin({ statut: 'EN_ATTENTE', page: cPage })
      .then((r) => { setCommentaires(r.content); setCPages(r.totalPages); })
      .finally(() => setLoading(false));
  }, [cPage]);

  useEffect(() => { if (tab === 'ressources') fetchRessources(); else fetchCommentaires(); }, [tab, fetchRessources, fetchCommentaires]);

  const moderateRessource = async (id: number, statut: 'PUBLIE' | 'SUSPENDU') => {
    await ressourcesApi.changerStatut(id, { statut });
    fetchRessources();
  };

  const moderateComment = async (id: number, statut: 'APPROUVE' | 'REJETE') => {
    await commentairesApi.moderer(id, { statut });
    fetchCommentaires();
  };

  return (
    <div className="admin-page">
      <div className="admin-page-header">
        <h1>Modération</h1>
      </div>

      <div className="tab-bar" style={{ marginBottom: '1.5rem' }}>
        <button className={`tab-btn${tab === 'ressources' ? ' active' : ''}`} onClick={() => setTab('ressources')} type="button">
          📚 Ressources en attente
          {ressources.length > 0 && <span className="tab-count">{ressources.length}</span>}
        </button>
        <button className={`tab-btn${tab === 'commentaires' ? ' active' : ''}`} onClick={() => setTab('commentaires')} type="button">
          💬 Commentaires en attente
          {commentaires.length > 0 && <span className="tab-count">{commentaires.length}</span>}
        </button>
      </div>

      {loading ? <LoadingSpinner /> : tab === 'ressources' ? (
        ressources.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '2rem', color: 'var(--color-text-muted)' }}>
            Aucune ressource en attente de modération.
          </div>
        ) : (
          <>
            <div className="table-wrap">
              <table className="data-table">
                <thead>
                  <tr><th>Titre</th><th>Auteur</th><th>Type</th><th>Date</th><th>Actions</th></tr>
                </thead>
                <tbody>
                  {ressources.map((r) => (
                    <tr key={r.id}>
                      <td><Link to={`/ressources/${r.id}`} target="_blank">{r.titre}</Link></td>
                      <td>{r.auteurNom}</td>
                      <td><Badge type={r.type} /></td>
                      <td>{new Date(r.dateCreation).toLocaleDateString('fr-FR')}</td>
                      <td>
                        <div style={{ display: 'flex', gap: '0.5rem' }}>
                          <button className="btn btn-xs btn-success" onClick={() => moderateRessource(r.id, 'PUBLIE')} type="button">✓ Publier</button>
                          <button className="btn btn-xs btn-danger" onClick={() => moderateRessource(r.id, 'SUSPENDU')} type="button">✗ Rejeter</button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <Pagination page={rPage} totalPages={rPages} onChange={setRPage} />
          </>
        )
      ) : (
        commentaires.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '2rem', color: 'var(--color-text-muted)' }}>
            Aucun commentaire en attente de modération.
          </div>
        ) : (
          <>
            <div className="table-wrap">
              <table className="data-table">
                <thead>
                  <tr><th>Auteur</th><th>Contenu</th><th>Date</th><th>Actions</th></tr>
                </thead>
                <tbody>
                  {commentaires.map((c) => (
                    <tr key={c.id}>
                      <td>{c.auteurNom}</td>
                      <td style={{ maxWidth: 400 }}>{c.contenu}</td>
                      <td>{new Date(c.dateCreation).toLocaleDateString('fr-FR')}</td>
                      <td>
                        <div style={{ display: 'flex', gap: '0.5rem' }}>
                          <button className="btn btn-xs btn-success" onClick={() => moderateComment(c.id, 'APPROUVE')} type="button">✓ Approuver</button>
                          <button className="btn btn-xs btn-danger" onClick={() => moderateComment(c.id, 'REJETE')} type="button">✗ Rejeter</button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <Pagination page={cPage} totalPages={cPages} onChange={setCPage} />
          </>
        )
      )}
    </div>
  );
}
