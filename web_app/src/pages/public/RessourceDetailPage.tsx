import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import * as ressourcesApi from '../../api/ressources';
import * as commentairesApi from '../../api/commentaires';
import * as progressionApi from '../../api/progression';
import type { Ressource, Commentaire } from '../../types';
import Badge from '../../components/common/Badge';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import './RessourceDetailPage.css';

/** Build a comment tree from either a nested or flat list returned by the API. */
function buildCommentTree(raw: Commentaire[]): Commentaire[] {
  const map = new Map<number, Commentaire & { reponses: Commentaire[] }>();
  raw.forEach((c) => map.set(c.id, { ...c, reponses: [] }));

  const roots: Commentaire[] = [];
  map.forEach((c) => {
    if (c.parentId && map.has(c.parentId)) {
      map.get(c.parentId)!.reponses.push(c);
    } else if (!c.parentId) {
      roots.push(c);
    }
  });

  // Merge pre-existing nested reponses from the API response
  raw.forEach((c) => {
    if (!c.parentId && c.reponses && c.reponses.length > 0 && map.get(c.id)!.reponses.length === 0) {
      map.get(c.id)!.reponses = c.reponses;
    }
  });

  return roots;
}

const ACTIVITY_TYPES = ['ACTIVITE', 'JEU'] as const;

export default function RessourceDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { user, isModerator } = useAuth();
  const [ressource, setRessource] = useState<Ressource | null>(null);
  const [commentaires, setCommentaires] = useState<Commentaire[]>([]);
  const [loading, setLoading] = useState(true);
  const [newComment, setNewComment] = useState('');
  const [replyTo, setReplyTo] = useState<number | null>(null);
  const [replyText, setReplyText] = useState('');
  const [expandedReplies, setExpandedReplies] = useState<Set<number>>(new Set());
  const [submitting, setSubmitting] = useState(false);
  const [fav, setFav] = useState(false);
  const [done, setDone] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState('');
  const [inviteCopied, setInviteCopied] = useState(false);

  useEffect(() => {
    if (!id) return;
    const rid = parseInt(id);
    Promise.all([
      ressourcesApi.getById(rid),
      commentairesApi.listerApprouves(rid),
    ]).then(([r, rawComments]) => {
      setRessource(r);
      setCommentaires(buildCommentTree(rawComments));
      setFav(r.estFavori ?? false);
      setDone(r.estExploite ?? false);
      setSaved(r.estSauvegarde ?? false);
    }).finally(() => setLoading(false));
  }, [id]);

  const submitComment = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newComment.trim() || !id) return;
    setSubmitting(true);
    try {
      const c = await commentairesApi.commenter(parseInt(id), { contenu: newComment });
      setCommentaires((prev) => [...prev, { ...c, reponses: [] }]);
      setNewComment('');
    } catch { setError('Erreur lors de l\'envoi du commentaire.'); }
    finally { setSubmitting(false); }
  };

  const submitReply = async (e: React.FormEvent, parentId: number) => {
    e.preventDefault();
    if (!replyText.trim() || !id) return;
    setSubmitting(true);
    try {
      const c = await commentairesApi.commenter(parseInt(id), { contenu: replyText, parentId });
      setCommentaires((prev) => prev.map((cm) =>
        cm.id === parentId
          ? { ...cm, reponses: [...(cm.reponses ?? []), { ...c, reponses: [] }] }
          : cm
      ));
      setExpandedReplies((s) => new Set(s).add(parentId));
      setReplyTo(null);
      setReplyText('');
    } catch { setError('Erreur lors de l\'envoi de la réponse.'); }
    finally { setSubmitting(false); }
  };

  const toggleReplies = (id: number) => {
    setExpandedReplies((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id); else next.add(id);
      return next;
    });
  };

  const handleShare = async () => {
    if (!ressource) return;
    await ressourcesApi.partager(ressource.id);
    try { await navigator.clipboard.writeText(window.location.href); } catch {}
  };

  const handleInvite = async () => {
    if (!ressource) return;
    try {
      await navigator.clipboard.writeText(window.location.href);
      await ressourcesApi.partager(ressource.id);
    } catch {}
    setInviteCopied(true);
    setTimeout(() => setInviteCopied(false), 2500);
  };

  const isActivity = ressource && (ACTIVITY_TYPES as readonly string[]).includes(ressource.type);

  if (loading) return <div className="container" style={{ padding: '3rem 0' }}><LoadingSpinner /></div>;
  if (!ressource) return <div className="container error-page"><h1>Ressource introuvable</h1><Link to="/ressources">← Retour</Link></div>;

  return (
    <div className="detail-page container">
      <nav aria-label="Fil d'Ariane" className="breadcrumb">
        <Link to="/">Accueil</Link>
        <span aria-hidden="true"> / </span>
        <Link to="/ressources">Ressources</Link>
        <span aria-hidden="true"> / </span>
        <span aria-current="page">{ressource.titre}</span>
      </nav>

      <article className="ressource-detail">
        <header className="detail-header">
          <div className="detail-badges">
            <Badge type={ressource.type} />
            <Badge statut={ressource.statut} />
            <Badge visibilite={ressource.visibilite} />
            {ressource.categorie && <Badge label={ressource.categorie.nom} variant="info" />}
          </div>

          <h1 className="detail-title">{ressource.titre}</h1>
          <p className="detail-desc">{ressource.description}</p>

          <div className="detail-meta">
            <span>Par <strong>{ressource.auteurNom}</strong></span>
            {ressource.datePublication && (
              <span>Publié le {new Date(ressource.datePublication).toLocaleDateString('fr-FR')}</span>
            )}
            {ressource.dureeEstimeeMin && <span>⏱ {ressource.dureeEstimeeMin} min</span>}
            <span>👁 {ressource.vues} vue{ressource.vues !== 1 ? 's' : ''}</span>
            <span>🔗 {ressource.partages} partage{ressource.partages !== 1 ? 's' : ''}</span>
          </div>

          {ressource.typesRelation.length > 0 && (
            <div className="detail-relations">
              {ressource.typesRelation.map((t) => (
                <span key={t.id} className="relation-tag">{t.libelle}</span>
              ))}
            </div>
          )}

          {user && (
            <div className="detail-actions">
              <button
                type="button"
                className={`action-pill${fav ? ' active' : ''}`}
                onClick={async () => {
                  if (fav) { await progressionApi.retirerFavori(ressource.id); setFav(false); }
                  else { await progressionApi.ajouterFavori(ressource.id); setFav(true); }
                }}
              >♥ {fav ? 'Retirer des favoris' : 'Ajouter aux favoris'}</button>
              <button
                type="button"
                className={`action-pill${done ? ' active' : ''}`}
                onClick={async () => {
                  if (done) { await progressionApi.demarquerExploitee(ressource.id); setDone(false); }
                  else { await progressionApi.marquerExploitee(ressource.id); setDone(true); }
                }}
              >✓ {done ? 'Exploitée' : 'Marquer exploitée'}</button>
              <button
                type="button"
                className={`action-pill${saved ? ' active' : ''}`}
                onClick={async () => {
                  if (saved) { await progressionApi.retirerSauvegarde(ressource.id); setSaved(false); }
                  else { await progressionApi.sauvegarder(ressource.id); setSaved(true); }
                }}
              >🔖 {saved ? 'Sauvegardée' : 'Mettre de côté'}</button>
              <button type="button" className="action-pill" onClick={handleShare}>
                📤 Partager
              </button>
            </div>
          )}

          {isModerator && (
            <div className="moderator-actions">
              <span className="badge badge-warning">Vue modérateur</span>
              <Link to={`/admin/ressources`} className="btn btn-outline btn-sm">Gérer dans l'admin</Link>
            </div>
          )}
        </header>

        {/* ── Activité / Jeu panel ── */}
        {isActivity && (
          <section className="activity-panel">
            <div className="activity-panel-top">
              <div className="activity-info">
                <span className="activity-icon">{ressource.type === 'JEU' ? '🎮' : '🎯'}</span>
                <div>
                  <strong className="activity-label">
                    {ressource.type === 'JEU' ? 'Jeu interactif' : 'Activité interactive'}
                  </strong>
                  <span className="activity-participants">
                    {ressource.partages} participant{ressource.partages !== 1 ? 's' : ''}
                  </span>
                </div>
              </div>
              {user && (
                <div className="activity-cta">
                  <button
                    type="button"
                    className={`btn ${done ? 'btn-success' : 'btn-primary'}`}
                    onClick={async () => {
                      if (done) { await progressionApi.demarquerExploitee(ressource.id); setDone(false); }
                      else { await progressionApi.marquerExploitee(ressource.id); setDone(true); }
                    }}
                  >
                    {done ? '✓ Vous participez' : 'Rejoindre'}
                  </button>
                  <button type="button" className="btn btn-outline" onClick={handleInvite}>
                    📨 Inviter
                  </button>
                </div>
              )}
            </div>
            {inviteCopied && (
              <div className="invite-toast" role="status">
                ✓ Lien copié ! Partagez-le pour inviter des amis.
              </div>
            )}
          </section>
        )}

        <div className="detail-content">
          {ressource.urlExterne && (
            <div className="external-link-box">
              <strong>Ressource externe :</strong>{' '}
              <a href={ressource.urlExterne} target="_blank" rel="noopener noreferrer">{ressource.urlExterne}</a>
            </div>
          )}
          <div className="prose" dangerouslySetInnerHTML={{ __html: ressource.contenu.replace(/\n/g, '<br/>') }} />
        </div>
      </article>

      {/* ── Comments / Discussion section ── */}
      <section className="comments-section" aria-labelledby="comments-title">
        <h2 id="comments-title">
          {isActivity ? '💬 Discussion' : 'Commentaires'} ({commentaires.length})
        </h2>

        {user ? (
          <form className="comment-form" onSubmit={submitComment}>
            <label htmlFor="new-comment" className="sr-only">Votre commentaire</label>
            <textarea
              id="new-comment"
              className="form-textarea"
              rows={3}
              placeholder={isActivity ? 'Partagez votre expérience…' : 'Partagez votre avis…'}
              value={newComment}
              onChange={(e) => setNewComment(e.target.value)}
              required
              aria-required="true"
            />
            {error && <p role="alert" className="form-error">{error}</p>}
            <button type="submit" className="btn btn-primary" disabled={submitting}>
              {submitting ? 'Envoi…' : isActivity ? 'Publier' : 'Commenter'}
            </button>
          </form>
        ) : (
          <p className="login-prompt">
            <Link to="/connexion">Connectez-vous</Link> pour laisser un commentaire.
          </p>
        )}

        <div className="comments-list">
          {commentaires.length === 0 && (
            <p className="no-comments">Aucun commentaire pour l'instant. Soyez le premier !</p>
          )}
          {commentaires.map((c) => {
            const reponses = c.reponses ?? [];
            const isExpanded = expandedReplies.has(c.id);
            const isReplying = replyTo === c.id;
            return (
              <div key={c.id} className="comment">
                <div className="comment-header">
                  <strong>{c.auteurNom}</strong>
                  <time>{new Date(c.dateCreation).toLocaleDateString('fr-FR')}</time>
                </div>
                <p className="comment-text">{c.contenu}</p>

                <div className="comment-footer">
                  {reponses.length > 0 && (
                    <button
                      type="button"
                      className="replies-toggle"
                      onClick={() => toggleReplies(c.id)}
                      aria-expanded={isExpanded}
                    >
                      {isExpanded ? '▲' : '▼'} {reponses.length} réponse{reponses.length > 1 ? 's' : ''}
                    </button>
                  )}
                  {user && (
                    <button
                      type="button"
                      className="reply-btn"
                      onClick={() => { setReplyTo(isReplying ? null : c.id); setReplyText(''); }}
                    >
                      {isReplying ? 'Annuler' : 'Répondre'}
                    </button>
                  )}
                </div>

                {isReplying && (
                  <form className="reply-form" onSubmit={(e) => submitReply(e, c.id)}>
                    <textarea
                      className="form-textarea"
                      rows={2}
                      placeholder={`Répondre à ${c.auteurNom}…`}
                      value={replyText}
                      onChange={(e) => setReplyText(e.target.value)}
                      required
                      autoFocus
                    />
                    <div className="reply-actions">
                      <button type="submit" className="btn btn-primary btn-sm" disabled={submitting}>
                        {submitting ? 'Envoi…' : 'Répondre'}
                      </button>
                      <button type="button" className="btn btn-outline btn-sm" onClick={() => setReplyTo(null)}>
                        Annuler
                      </button>
                    </div>
                  </form>
                )}

                {reponses.length > 0 && isExpanded && (
                  <div className="replies">
                    {reponses.map((r) => (
                      <div key={r.id} className="comment reply">
                        <div className="comment-header">
                          <strong>{r.auteurNom}</strong>
                          <time>{new Date(r.dateCreation).toLocaleDateString('fr-FR')}</time>
                        </div>
                        <p className="comment-text">{r.contenu}</p>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </section>
    </div>
  );
}
