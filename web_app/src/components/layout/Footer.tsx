import { Link } from 'react-router-dom';
import './Footer.css';

export default function Footer() {
  return (
    <footer className="site-footer" role="contentinfo">
      <div className="container footer-inner">
        <div className="footer-brand">
          <div className="footer-brand-logo">
            <span className="footer-brand-icon" aria-hidden="true">♻</span>
            <span className="footer-brand-name">(RE)Sources Relationnelles</span>
          </div>
          <p className="footer-desc">
            Une plateforme du Ministère des Solidarités et de la Santé pour créer,
            renforcer et enrichir les liens relationnels des citoyens.
          </p>
        </div>
        <nav aria-label="Liens footer navigation">
          <h3>Navigation</h3>
          <ul>
            <li><Link to="/">Accueil</Link></li>
            <li><Link to="/ressources">Ressources</Link></li>
            <li><Link to="/aide">Aide</Link></li>
            <li><Link to="/connexion">Connexion</Link></li>
          </ul>
        </nav>
        <nav aria-label="Liens légaux">
          <h3>Légal</h3>
          <ul>
            <li><Link to="/aide#rgpd">Politique RGPD</Link></li>
            <li><Link to="/aide#accessibilite">Accessibilité RGAA</Link></li>
            <li><Link to="/aide#mentions">Mentions légales</Link></li>
          </ul>
        </nav>
      </div>
      <div className="footer-bottom">
        <p>© {new Date().getFullYear()} Ministère des Solidarités et de la Santé — Projet collaboratif INFCDAAL1 — CESI</p>
      </div>
    </footer>
  );
}
