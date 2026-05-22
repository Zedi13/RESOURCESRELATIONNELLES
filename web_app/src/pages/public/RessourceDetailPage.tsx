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

export default function RessourceDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { user, isModerator } = useAuth();
  const [ressource, setRessource] = useState<Ressource | null>(null);
  const [commentaires, setCommentaires] = useState<Commentaire[]>([]);
  const [loading, setLoading] = useState(true);
  const [newComment, setNewComment] = useState('');
  const [replyTo, setReplyTo] = useState<number | null>(null);
  const [replyText, setReplyText] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [fav, setFav] = useState(false);
  const [done, setDone] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!id) return;
    const rid = parseInt(id);
    Promise.all([
      ressourcesApi.getById(rid),
      commentairesApi.listerApprouves(rid),
    ]).then(([r, c]) => {
      setRessource(r);
      setCommentaires(c);
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
      setCommentaires((prev) => [...prev, c]);
      setNewComment('');
    } catch { setError('Erreur lors de l\'envoi du commentaire.'); }
    finally { setSubmitting(false); }
  };

  const submitReply = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!replyText.trim() || !id || !replyTo) return;
    setSubmitting(true);
    try {
      const c = await commentairesApi.commenter(parseInt(id), { contenu: replyText, parentId: replyTo });
      setCommentaires((prev) => prev.map(cm =>
        cm.id === replyTo ? { ...cm, reponses: [...(cm.reponses ?? []), c] } : cm
      ));
      setReplyTo(null);
      setReplyText('');
    } catch { setError('Erreur lors de l\'envoi de la réponse.'); }
    finally { setSubmitting(false); }
  };

  const handleShare = async () => {
    if (!ressource) return;
    await ressourcesApi.partager(ressource.id);
    try { await navigator.clipboard.writeText(window.location.href); } catch {}
  };

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

      <section className="comments-section" aria-labelledby="comments-title">
        <h2 id="comments-title">Commentaires ({commentaires.length})</h2>

        {user ? (
          <form className="comment-form" onSubmit={submitComment}>
            <label htmlFor="new-comment" className="sr-only">Votre commentaire</label>
            <textarea
              id="new-comment"
              className="form-textarea"
              rows={3}
              placeholder="Partagez votre avis…"
              value={newComment}
              onChange={(e) => setNewComment(e.target.value)}
              required
              aria-required="true"
            />
            {error && <p role="alert" className="form-error">{error}</p>}
            <button type="submit" className="btn btn-primary" disabled={submitting}>
              {submitting ? 'Envoi…' : 'Commenter'}
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
          {commentaires.map((c) => (
            <div key={c.id} className="comment">
              <div className="comment-header">
                <strong>{c.auteurNom}</strong>
                <time>{new Date(c.dateCreation).toLocaleDateString('fr-FR')}</time>
              </div>
              <p className="comment-text">{c.contenu}</p>
              {user && (
                <button
                  type="button"
                  className="reply-btn"
                  onClick={() => setReplyTo(replyTo === c.id ? null : c.id)}
                >
                  Répondre
                </button>
              )}
              {replyTo === c.id && (
                <form className="reply-form" onSubmit={submitReply}>
                  <textarea
                    className="form-textarea"
                    rows={2}
                    placeholder="Votre réponse…"
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
              {c.reponses && c.reponses.length > 0 && (
                <div className="replies">
                  {c.reponses.map((r) => (
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
          ))}
        </div>
      </section>
    </div>
  );
}
