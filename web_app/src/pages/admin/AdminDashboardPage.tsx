import { useEffect, useState } from 'react';
import * as statsApi from '../../api/statistiques';
import type { StatistiquesResponse } from '../../types';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { TYPE_LABELS } from '../../components/common/Badge';
import './AdminDashboardPage.css';

export default function AdminDashboardPage() {
  const [stats, setStats] = useState<StatistiquesResponse | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    statsApi.getDashboard().then(setStats).catch(() => {}).finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="admin-page"><LoadingSpinner /></div>;
  if (!stats) return <div className="admin-page"><p>Données non disponibles.</p></div>;

  const statutData: Record<string, number> = {
    PUBLIE:     stats.ressourcesPubliees,
    EN_ATTENTE: stats.ressourcesEnAttente,
    SUSPENDU:   stats.ressourcesSuspendues,
    BROUILLON:  stats.ressourcesBrouillon,
  };

  const STATUT_LABELS: Record<string, string> = {
    PUBLIE: 'Publiées', EN_ATTENTE: 'En attente',
    SUSPENDU: 'Suspendues', BROUILLON: 'Brouillons',
  };

  return (
    <div className="admin-page">
      <div className="admin-page-header">
        <h1>Tableau de bord</h1>
      </div>

      <div className="kpi-grid">
        <div className="kpi-card">
          <span className="kpi-icon" aria-hidden="true">📚</span>
          <strong className="kpi-value">{stats.totalRessources}</strong>
          <span className="kpi-label">Ressources</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon" aria-hidden="true">✅</span>
          <strong className="kpi-value">{stats.ressourcesPubliees}</strong>
          <span className="kpi-label">Publiées</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon" aria-hidden="true">⏳</span>
          <strong className="kpi-value">{stats.ressourcesEnAttente}</strong>
          <span className="kpi-label">En attente</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon" aria-hidden="true">👥</span>
          <strong className="kpi-value">{stats.totalUtilisateurs}</strong>
          <span className="kpi-label">Utilisateurs</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon" aria-hidden="true">💬</span>
          <strong className="kpi-value">{stats.totalCommentaires}</strong>
          <span className="kpi-label">Commentaires</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon" aria-hidden="true">👁</span>
          <strong className="kpi-value">{stats.totalVues}</strong>
          <span className="kpi-label">Vues totales</span>
        </div>
      </div>

      <div className="stats-row">
        <div className="stats-card">
          <h2>Ressources par type</h2>
          <div className="bar-list">
            {Object.entries(stats.ressourcesParType).map(([key, count]) => {
              const max = Math.max(...Object.values(stats.ressourcesParType), 1);
              return (
                <div key={key} className="bar-item">
                  <span className="bar-label">{(TYPE_LABELS as Record<string, string>)[key] ?? key}</span>
                  <div className="bar-track">
                    <div className="bar-fill" style={{ width: `${(count / max) * 100}%` }} />
                  </div>
                  <span className="bar-value">{count}</span>
                </div>
              );
            })}
          </div>
        </div>

        <div className="stats-card">
          <h2>Ressources par statut</h2>
          <div className="bar-list">
            {Object.entries(statutData).map(([key, count]) => {
              const max = Math.max(...Object.values(statutData), 1);
              return (
                <div key={key} className="bar-item">
                  <span className="bar-label">{STATUT_LABELS[key] ?? key}</span>
                  <div className="bar-track">
                    <div className="bar-fill" style={{ width: `${(count / max) * 100}%` }} />
                  </div>
                  <span className="bar-value">{count}</span>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
