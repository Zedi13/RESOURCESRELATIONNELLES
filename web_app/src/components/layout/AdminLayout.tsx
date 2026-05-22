import { NavLink, Outlet, Navigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import './AdminLayout.css';

const NAV_ITEMS = [
  { to: '/admin',              end: true,  icon: '📊', label: 'Tableau de bord' },
  { to: '/admin/ressources',   end: false, icon: '📚', label: 'Ressources' },
  { to: '/admin/moderation',   end: false, icon: '🛡',  label: 'Modération' },
  { to: '/admin/categories',   end: false, icon: '🗂',  label: 'Catégories' },
  { to: '/admin/utilisateurs', end: false, icon: '👥', label: 'Utilisateurs' },
  { to: '/admin/statistiques', end: false, icon: '📈', label: 'Statistiques' },
];

export default function AdminLayout() {
  const { isModerator, loading } = useAuth();
  if (loading) return <div className="loading-full">Chargement…</div>;
  if (!isModerator) return <Navigate to="/" replace />;

  return (
    <div className="admin-shell">
      <aside className="admin-sidebar" aria-label="Navigation administration">
        <div className="admin-brand">
          <div className="admin-brand-inner">
            <div className="admin-brand-icon" aria-hidden="true">♻</div>
            <div>
              <div className="admin-brand-text">(RE)Sources Rel.</div>
              <div className="admin-brand-sub">Administration</div>
            </div>
          </div>
        </div>

        <div className="admin-nav-section">
          <p className="admin-nav-label">Menu</p>
          <nav aria-label="Navigation back-office">
            <ul className="admin-nav">
              {NAV_ITEMS.map((item) => (
                <li key={item.to}>
                  <NavLink
                    to={item.to}
                    end={item.end}
                    className={({ isActive }) => isActive ? 'admin-link active' : 'admin-link'}
                    aria-current={undefined}
                  >
                    <span className="admin-link-icon" aria-hidden="true">{item.icon}</span>
                    {item.label}
                  </NavLink>
                </li>
              ))}
            </ul>
          </nav>
        </div>

        <div className="admin-sidebar-footer">
          <NavLink to="/" className="admin-back">
            <span aria-hidden="true">←</span>
            Retour au site public
          </NavLink>
        </div>
      </aside>

      <div className="admin-content">
        <Outlet />
      </div>
    </div>
  );
}
