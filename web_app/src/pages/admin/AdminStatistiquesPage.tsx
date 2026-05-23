import { useEffect, useState, useMemo } from 'react';
import * as statsApi from '../../api/statistiques';
import type { StatistiquesResponse } from '../../types';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { TYPE_LABELS } from '../../components/common/Badge';
import './AdminDashboardPage.css';
import './AdminStatistiquesPage.css';

const MOIS_LABELS = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];

const STATUT_LABELS: Record<string, string> = {
  PUBLIE: 'Publiées', EN_ATTENTE: 'En attente',
  SUSPENDU: 'Suspendues', BROUILLON: 'Brouillons',
};

export default function AdminStatistiquesPage() {
  const [stats, setStats] = useState<StatistiquesResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [exporting, setExporting] = useState(false);
  const [selectedYear, setSelectedYear] = useState<number | null>(null);
  const [metricKey, setMetricKey] = useState<'ressourcesCrees' | 'vues'>('vues');
  const [typeFilter, setTypeFilter] = useState<string>('');
  const [categorieFilter, setCategorieFilter] = useState<string>('');

  useEffect(() => {
    statsApi.getDashboard().then((data) => {
      setStats(data);
      if (data.statsParMois.length > 0) {
        const maxYear = Math.max(...data.statsParMois.map((s) => s.annee));
        setSelectedYear(maxYear);
      }
    }).catch(() => {}).finally(() => setLoading(false));
  }, []);

  const availableYears = useMemo(() => {
    if (!stats) return [];
    return [...new Set(stats.statsParMois.map((s) => s.annee))].sort((a, b) => b - a);
  }, [stats]);

  const monthlyData = useMemo(() => {
    if (!stats) return [];
    const filtered = selectedYear
      ? stats.statsParMois.filter((s) => s.annee === selectedYear)
      : stats.statsParMois;
    return Array.from({ length: 12 }, (_, i) => {
      const found = filtered.find((s) => s.mois === i + 1);
      return { mois: i + 1, ...( found ?? { ressourcesCrees: 0, vues: 0 }) };
    });
  }, [stats, selectedYear]);

  const filteredTypes = useMemo(() => {
    if (!stats) return {};
    if (!typeFilter) return stats.ressourcesParType;
    return Object.fromEntries(
      Object.entries(stats.ressourcesParType).filter(([k]) => k === typeFilter)
    );
  }, [stats, typeFilter]);

  const filteredCategories = useMemo(() => {
    if (!stats) return {};
    if (!categorieFilter) return stats.ressourcesParCategorie;
    return Object.fromEntries(
      Object.entries(stats.ressourcesParCategorie).filter(([k]) =>
        k.toLowerCase().includes(categorieFilter.toLowerCase())
      )
    );
  }, [stats, categorieFilter]);

  const handleExport = async () => {
    setExporting(true);
    try {
      const blob = await statsApi.exportCsv();
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url; a.download = 'statistiques.csv'; a.click();
      URL.revokeObjectURL(url);
    } finally {
      setExporting(false);
    }
  };

  if (loading) return <div className="admin-page"><LoadingSpinner /></div>;
  if (!stats) return <div className="admin-page"><p>Données non disponibles.</p></div>;

  const statutData: Record<string, number> = {
    PUBLIE:     stats.ressourcesPubliees,
    EN_ATTENTE: stats.ressourcesEnAttente,
    SUSPENDU:   stats.ressourcesSuspendues,
    BROUILLON:  stats.ressourcesBrouillon,
  };

  const maxMonthly = Math.max(...monthlyData.map((d) => d[metricKey]), 1);

  return (
    <div className="admin-page">
      <div className="admin-page-header">
        <h1>Statistiques</h1>
        <button className="btn btn-outline" onClick={handleExport} disabled={exporting} type="button">
          {exporting ? 'Export…' : '📥 Exporter CSV'}
        </button>
      </div>

      {/* ── KPI cards ── */}
      <div className="kpi-grid">
        <div className="kpi-card">
          <span className="kpi-icon">📚</span>
          <strong className="kpi-value">{stats.totalRessources}</strong>
          <span className="kpi-label">Ressources</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon">👥</span>
          <strong className="kpi-value">{stats.totalUtilisateurs}</strong>
          <span className="kpi-label">Utilisateurs</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon">🟢</span>
          <strong className="kpi-value">{stats.citoyensActifs}</strong>
          <span className="kpi-label">Citoyens actifs</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon">👁</span>
          <strong className="kpi-value">{stats.totalVues}</strong>
          <span className="kpi-label">Vues totales</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon">🔗</span>
          <strong className="kpi-value">{stats.totalPartages}</strong>
          <span className="kpi-label">Partages</span>
        </div>
        <div className="kpi-card">
          <span className="kpi-icon">⏳</span>
          <strong className="kpi-value">{stats.commentairesEnAttente}</strong>
          <span className="kpi-label">Comm. en attente</span>
        </div>
      </div>

      {/* ── Tendance mensuelle ── */}
      {stats.statsParMois.length > 0 && (
        <div className="stats-card trend-card" style={{ marginBottom: '1.25rem' }}>
          <div className="trend-header">
            <h2>Tendance mensuelle</h2>
            <div className="trend-controls">
              <div className="metric-toggle">
                <button
                  type="button"
                  className={`metric-btn${metricKey === 'vues' ? ' active' : ''}`}
                  onClick={() => setMetricKey('vues')}
                >
                  Vues
                </button>
                <button
                  type="button"
                  className={`metric-btn${metricKey === 'ressourcesCrees' ? ' active' : ''}`}
                  onClick={() => setMetricKey('ressourcesCrees')}
                >
                  Créations
                </button>
              </div>
              {availableYears.length > 1 && (
                <select
                  className="form-select year-select"
                  value={selectedYear ?? ''}
                  onChange={(e) => setSelectedYear(e.target.value ? Number(e.target.value) : null)}
                >
                  <option value="">Toutes les années</option>
                  {availableYears.map((y) => (
                    <option key={y} value={y}>{y}</option>
                  ))}
                </select>
              )}
            </div>
          </div>
          <div className="month-chart">
            {monthlyData.map((d) => {
              const pct = (d[metricKey] / maxMonthly) * 100;
              return (
                <div key={d.mois} className="month-col">
                  <span className="month-val">{d[metricKey] > 0 ? d[metricKey] : ''}</span>
                  <div className="month-bar-wrap">
                    <div className="month-bar" style={{ height: `${Math.max(pct, d[metricKey] > 0 ? 4 : 0)}%` }} />
                  </div>
                  <span className="month-label">{MOIS_LABELS[d.mois - 1]}</span>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* ── Types & Statuts ── */}
      <div className="stats-row">
        <div className="stats-card">
          <div className="stats-card-header">
            <h2>Ressources par type</h2>
            <select
              className="form-select filter-select"
              value={typeFilter}
              onChange={(e) => setTypeFilter(e.target.value)}
            >
              <option value="">Tous les types</option>
              {Object.keys(stats.ressourcesParType).map((k) => (
                <option key={k} value={k}>{(TYPE_LABELS as Record<string, string>)[k] ?? k}</option>
              ))}
            </select>
          </div>
          <div className="bar-list">
            {Object.entries(filteredTypes).map(([key, count]) => {
              const max = Math.max(...Object.values(filteredTypes), 1);
              return (
                <div key={key} className="bar-item">
                  <span className="bar-label">{(TYPE_LABELS as Record<string, string>)[key] ?? key}</span>
                  <div className="bar-track"><div className="bar-fill" style={{ width: `${(count / max) * 100}%` }} /></div>
                  <span className="bar-value">{count}</span>
                </div>
              );
            })}
            {Object.keys(filteredTypes).length === 0 && (
              <p style={{ color: 'var(--color-text-muted)', fontSize: 'var(--text-sm)' }}>Aucun résultat.</p>
            )}
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
                  <div className="bar-track"><div className="bar-fill" style={{ width: `${(count / max) * 100}%` }} /></div>
                  <span className="bar-value">{count}</span>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* ── Catégories ── */}
      <div className="stats-card" style={{ marginTop: '1.25rem' }}>
        <div className="stats-card-header">
          <h2>Ressources par catégorie</h2>
          <input
            type="search"
            className="form-input filter-select"
            placeholder="Filtrer…"
            value={categorieFilter}
            onChange={(e) => setCategorieFilter(e.target.value)}
          />
        </div>
        <div className="bar-list">
          {Object.entries(filteredCategories).map(([key, count]) => {
            const max = Math.max(...Object.values(filteredCategories), 1);
            return (
              <div key={key} className="bar-item">
                <span className="bar-label">{key}</span>
                <div className="bar-track"><div className="bar-fill" style={{ width: `${(count / max) * 100}%` }} /></div>
                <span className="bar-value">{count}</span>
              </div>
            );
          })}
          {Object.keys(filteredCategories).length === 0 && (
            <p style={{ color: 'var(--color-text-muted)', fontSize: 'var(--text-sm)' }}>Aucun résultat.</p>
          )}
        </div>
      </div>
    </div>
  );
}
