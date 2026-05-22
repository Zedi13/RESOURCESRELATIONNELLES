import { Link } from 'react-router-dom';
import type { RessourceSummary } from '../../types';
import Badge from './Badge';
import * as progressionApi from '../../api/progression';
import { useAuth } from '../../contexts/AuthContext';
import { useState } from 'react';

interface Props {
  ressource: RessourceSummary;
  onUpdate?: (r: RessourceSummary) => void;
}

export default function RessourceCard({ ressource, onUpdate }: Props) {
  const { user } = useAuth();
  const [fav, setFav] = useState(false);
  const [saved, setSaved] = useState(false);
  const [done, setDone] = useState(false);

  const toggleFav = async (e: React.MouseEvent) => {
    e.preventDefault();
    if (!user) return;
    try {
      if (fav) { await progressionApi.retirerFavori(ressource.id); setFav(false); }
      else { await progressionApi.ajouterFavori(ressource.id); setFav(true); }
      onUpdate?.({ ...ressource });
    } catch {}
  };

  const toggleSaved = async (e: React.MouseEvent) => {
    e.preventDefault();
    if (!user) return;
    try {
      if (saved) { await progressionApi.retirerSauvegarde(ressource.id); setSaved(false); }
      else { await progressionApi.sauvegarder(ressource.id); setSaved(true); }
    } catch {}
  };

  const toggleDone = async (e: React.MouseEvent) => {
    e.preventDefault();
    if (!user) return;
    try {
      if (done) { await progressionApi.demarquerExploitee(ressource.id); setDone(false); }
      else { await progressionApi.marquerExploitee(ressource.id); setDone(true); }
    } catch {}
  };

  const dureeLabel = ressource.dureeEstimeeMin
    ? ressource.dureeEstimeeMin >= 60
      ? `${Math.floor(ressource.dureeEstimeeMin / 60)}h${ressource.dureeEstimeeMin % 60 ? ressource.dureeEstimeeMin % 60 + 'min' : ''}`
      : `${ressource.dureeEstimeeMin} min`
    : null;

  return (
    <article className="ressource-card">
      <Link to={`/ressources/${ressource.id}`} className="card-link">
        <div className="card-header">
          <div className="card-badges">
            <Badge type={ressource.type} />
            {ressource.categorieNom && <Badge label={ressource.categorieNom} variant="info" />}
          </div>
          {user && (
            <div className="card-actions" onClick={(e) => e.preventDefault()}>
              <button
                type="button"
                className={`action-btn${fav ? ' active' : ''}`}
                onClick={toggleFav}
                title={fav ? 'Retirer des favoris' : 'Ajouter aux favoris'}
                aria-label={fav ? 'Retirer des favoris' : 'Ajouter aux favoris'}
              >♥</button>
              <button
                type="button"
                className={`action-btn${saved ? ' active' : ''}`}
                onClick={toggleSaved}
                title={saved ? 'Retirer des sauvegardes' : 'Mettre de côté'}
                aria-label={saved ? 'Retirer des sauvegardes' : 'Mettre de côté'}
              >🔖</button>
              <button
                type="button"
                className={`action-btn${done ? ' active' : ''}`}
                onClick={toggleDone}
                title={done ? 'Marquer comme non exploitée' : 'Marquer comme exploitée'}
                aria-label={done ? 'Marquer comme non exploitée' : 'Marquer comme exploitée'}
              >✓</button>
            </div>
          )}
        </div>

        <h3 className="card-title">{ressource.titre}</h3>
        <p className="card-desc">{ressource.description}</p>

        <div className="card-meta">
          <span title="Auteur">{ressource.auteurNom}</span>
          {dureeLabel && <span title="Durée estimée">⏱ {dureeLabel}</span>}
          <span title="Vues">👁 {ressource.vues}</span>
        </div>

        {ressource.typesRelation.length > 0 && (
          <div className="card-relations">
            {ressource.typesRelation.map((t) => (
              <span key={t.id} className="relation-tag">{t.libelle}</span>
            ))}
          </div>
        )}
      </Link>
    </article>
  );
}
