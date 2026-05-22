import { useEffect, useState } from 'react';
import { Link, Navigate } from 'react-router-dom';
import * as progressionApi from '../../api/progression';
import type { ProgressionResponse, RessourceSummary } from '../../types';
import RessourceCard from '../../components/common/RessourceCard';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import './DashboardPage.css';

type TabKey = 'favoris' | 'exploitations' | 'sauvegardes';

function getList(p: ProgressionResponse, tab: TabKey): RessourceSummary[] {
  if (tab === 'favoris') return p.favoris;
  if (tab === 'exploitations') return p.ressourcesExploitees;
  return p.ressourcesSauvegardees;
}

export default function DashboardPage() {
  const { user, loading: authLoading } = useAuth();
  const [progression, setProgression] = useState<ProgressionResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [tab, setTab] = useState<TabKey>('favoris');

  if (!authLoading && !user) return <Navigate to="/connexion" state={{ from: '/mon-espace' }} replace />;

  useEffect(() => {
    progressionApi.getDashboard()
      .then(setProgression)
      .finally(() => setLoading(false));
  }, []);

  const tabs: { key: TabKey; label: string; count: number }[] = [
    { key: 'favoris',       label: '♥ Favoris',        count: progression?.totalFavoris ?? 0 },
    { key: 'exploitations', label: '✓ Exploitées',      count: progression?.totalExploitees ?? 0 },
    { key: 'sauvegardes',   label: '🔖 Pour plus tard', count: progression?.totalSauvegardees ?? 0 },
  ];

  const currentList = progression ? getList(progression, tab) : [];

  return (
    <div className="dashboard-page container">
      <div className="dashboard-header">
        <div>
          <h1>Mon espace</h1>
          <p>Bienvenue, <strong>{user?.nomComplet}</strong></p>
        </div>
        <Link to="/mon-espace/creer" className="btn btn-primary">+ Créer une ressource</Link>
      </div>

      <div className="stats-bar">
        {tabs.map((t) => (
          <div key={t.key} className="stat-pill">
            <strong>{t.count}</strong>
            <span>{t.label}</span>
          </div>
        ))}
      </div>

      <div className="dashboard-section">
        <div className="tab-bar" role="tablist">
          {tabs.map((t) => (
            <button
              key={t.key}
              role="tab"
              aria-selected={tab === t.key}
              className={`tab-btn${tab === t.key ? ' active' : ''}`}
              onClick={() => setTab(t.key)}
            >
              {t.label} <span className="tab-count">{t.count}</span>
            </button>
          ))}
        </div>

        <div role="tabpanel" aria-label={tabs.find(t => t.key === tab)?.label}>
          {loading ? <LoadingSpinner /> : currentList.length === 0 ? (
            <div className="empty-state">
              <p>Aucune ressource dans cette section.</p>
              <Link to="/ressources" className="btn btn-outline">Découvrir les ressources</Link>
            </div>
          ) : (
            <div className="ressources-grid">
              {currentList.map((r) => <RessourceCard key={r.id} ressource={r} />)}
            </div>
          )}
        </div>
      </div>

      <div className="dashboard-section">
        <div className="section-header-flex">
          <h2>Mes ressources</h2>
          <Link to="/mon-espace/mes-ressources" className="see-all">Voir tout →</Link>
        </div>
        <p className="hint">Gérez les ressources que vous avez créées.</p>
        <Link to="/mon-espace/mes-ressources" className="btn btn-outline">Voir mes ressources</Link>
      </div>
    </div>
  );
}
