import { Link } from 'react-router-dom';
import { useEffect, useState } from 'react';
import * as ressourcesApi from '../../api/ressources';
import * as categoriesApi from '../../api/categories';
import type { Categorie, RessourceSummary } from '../../types';
import RessourceCard from '../../components/common/RessourceCard';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import './HomePage.css';

export default function HomePage() {
  const [recentes, setRecentes] = useState<RessourceSummary[]>([]);
  const [categories, setCategories] = useState<Categorie[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      ressourcesApi.listerPubliques({ size: 6 }),
      categoriesApi.lister(),
    ]).then(([r, c]) => {
      setRecentes(r.content);
      setCategories(c.slice(0, 6));
    }).finally(() => setLoading(false));
  }, []);

  return (
    <>
      {/* ── Hero ── */}
      <section className="hero-section" aria-labelledby="hero-title">
        <div className="container hero-content">
          <div className="hero-text">
            <div className="hero-eyebrow" aria-hidden="true">
              <span>♻</span>
              <span>Plateforme nationale</span>
            </div>
            <h1 id="hero-title">
              Enrichissez<br />vos <em>relations</em>
            </h1>
            <p className="hero-desc">
              Accédez à des centaines de ressources pour créer, renforcer et
              enrichir vos liens — famille, couple, amis, collègues…
            </p>
            <div className="hero-actions">
              <Link to="/ressources" className="btn btn-primary btn-lg">
                Découvrir les ressources
              </Link>
              <Link to="/inscription" className="btn btn-secondary btn-lg">
                Créer un compte gratuit
              </Link>
            </div>
            <div className="hero-trust">
              <span>🔒 Données protégées RGPD</span>
              <span className="trust-divider" />
              <span>♿ Conforme RGAA</span>
              <span className="trust-divider" />
              <span>🇫🇷 Service public</span>
            </div>
          </div>

          <div className="hero-stats" aria-label="Ce que vous trouverez">
            <div className="stat-card">
              <div className="stat-icon-wrap" aria-hidden="true">📚</div>
              <div className="stat-body">
                <strong>Catalogue de ressources</strong>
                <span>Articles, guides, vidéos, podcasts…</span>
              </div>
            </div>
            <div className="stat-card">
              <div className="stat-icon-wrap" aria-hidden="true">💬</div>
              <div className="stat-body">
                <strong>Espace d'échange modéré</strong>
                <span>Commentez et partagez vos avis</span>
              </div>
            </div>
            <div className="stat-card">
              <div className="stat-icon-wrap" aria-hidden="true">📊</div>
              <div className="stat-body">
                <strong>Suivi de progression</strong>
                <span>Favoris, exploitées, pour plus tard</span>
              </div>
            </div>
            <div className="stat-card">
              <div className="stat-icon-wrap" aria-hidden="true">✏️</div>
              <div className="stat-body">
                <strong>Créez vos ressources</strong>
                <span>Partagez votre expertise</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ── Categories ── */}
      <section className="home-section container" aria-labelledby="categories-title">
        <p className="section-label" aria-hidden="true">🗂 Catalogue</p>
        <div className="section-title-row">
          <h2 id="categories-title">Explorer par catégorie</h2>
          <Link to="/ressources" className="see-all">Tout voir →</Link>
        </div>
        {loading ? <LoadingSpinner /> : (
          <div className="categories-grid">
            {categories.map((cat) => (
              <Link
                key={cat.id}
                to={`/ressources?categorieId=${cat.id}`}
                className="category-card"
              >
                <strong>{cat.nom}</strong>
                {cat.description && <span>{cat.description}</span>}
                {cat.nombreRessources !== undefined && (
                  <span className="cat-count">{cat.nombreRessources} ressource{cat.nombreRessources !== 1 ? 's' : ''}</span>
                )}
              </Link>
            ))}
            <Link to="/ressources" className="category-card category-card-all">
              <strong>Toutes les catégories →</strong>
            </Link>
          </div>
        )}
      </section>

      {/* ── Recent resources ── */}
      <section className="home-section container" aria-labelledby="recentes-title">
        <p className="section-label" aria-hidden="true">🆕 Dernières publications</p>
        <div className="section-title-row">
          <h2 id="recentes-title">Ressources récentes</h2>
          <Link to="/ressources" className="see-all">Voir tout →</Link>
        </div>
        {loading ? <LoadingSpinner /> : recentes.length === 0 ? (
          <div className="empty-state">
            <p>Aucune ressource publiée pour l'instant.</p>
            <Link to="/inscription" className="btn btn-primary">Créer la première</Link>
          </div>
        ) : (
          <div className="ressources-grid">
            {recentes.map((r) => <RessourceCard key={r.id} ressource={r} />)}
          </div>
        )}
      </section>

      {/* ── CTA ── */}
      <section className="cta-section" aria-labelledby="cta-title">
        <div className="cta-content">
          <h2 id="cta-title">Rejoignez la communauté</h2>
          <p>
            Créez un compte gratuit pour accéder à toutes les ressources,
            créer les vôtres et suivre votre progression personnelle.
          </p>
          <Link to="/inscription" className="btn btn-primary btn-lg">
            S'inscrire gratuitement
          </Link>
        </div>
      </section>
    </>
  );
}
