import { Link, NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import './Header.css';

export default function Header() {
  const { user, logout, isModerator } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <header className="site-header" role="banner">
      <div className="header-inner container">
        <Link to="/" className="brand" aria-label="(RE)Sources Relationnelles - Accueil">
          <span className="brand-icon" aria-hidden="true">♻</span>
          <span className="brand-name">
            <span>(RE)Sources</span>
            <strong>Relationnelles</strong>
          </span>
        </Link>

        <nav aria-label="Navigation principale">
          <ul className="nav-list">
            <li><NavLink to="/ressources" className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}>Ressources</NavLink></li>
            <li><NavLink to="/aide" className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}>Aide</NavLink></li>
            {user && (
              <li><NavLink to="/mon-espace" className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}>Mon espace</NavLink></li>
            )}
            {isModerator && (
              <li><NavLink to="/admin" className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}>Administration</NavLink></li>
            )}
          </ul>
        </nav>

        <div className="header-actions">
          {user ? (
            <div className="user-menu">
              <div className="user-avatar" aria-hidden="true">
                {user.nomComplet.split(' ').map(n => n[0]).join('').slice(0,2).toUpperCase()}
              </div>
              <span className="user-name" aria-label={`Connecté en tant que ${user.nomComplet}`}>
                {user.nomComplet}
              </span>
              <button onClick={handleLogout} className="btn btn-outline btn-sm" type="button">
                Déconnexion
              </button>
            </div>
          ) : (
            <div className="auth-links">
              <Link to="/connexion" className="btn btn-outline btn-sm">Connexion</Link>
              <Link to="/inscription" className="btn btn-primary btn-sm">Inscription</Link>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
