import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import '../auth/AuthPage.css';

export default function RegisterPage() {
  const { register } = useAuth();
  const navigate = useNavigate();

  const [nomComplet, setNomComplet] = useState('');
  const [email, setEmail] = useState('');
  const [motDePasse, setMotDePasse] = useState('');
  const [confirm, setConfirm] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (motDePasse !== confirm) { setError('Les mots de passe ne correspondent pas.'); return; }
    if (motDePasse.length < 8) { setError('Le mot de passe doit contenir au moins 8 caractères.'); return; }
    setLoading(true);
    try {
      await register({ nomComplet, email, motDePasse });
      navigate('/mon-espace');
    } catch (err: any) {
      setError(err.response?.data?.message ?? 'Une erreur est survenue lors de l\'inscription.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-card">
        <div className="auth-logo">
          <span className="auth-logo-icon" aria-hidden="true">♻</span>
          <span className="auth-logo-text">(RE)Sources Relationnelles</span>
        </div>
        <h1>Créer un compte</h1>
        <p className="auth-subtitle">Rejoignez la communauté gratuitement</p>

        <form onSubmit={handleSubmit} noValidate>
          <div className="form-group">
            <label htmlFor="nomComplet">Nom complet</label>
            <input
              id="nomComplet"
              type="text"
              className="form-input"
              value={nomComplet}
              onChange={(e) => setNomComplet(e.target.value)}
              required
              autoComplete="name"
              aria-required="true"
              placeholder="Jean Dupont"
            />
          </div>

          <div className="form-group">
            <label htmlFor="email">Adresse e-mail</label>
            <input
              id="email"
              type="email"
              className="form-input"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoComplete="email"
              aria-required="true"
              placeholder="votre@email.fr"
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Mot de passe <span className="field-hint">(8 caractères min.)</span></label>
            <input
              id="password"
              type="password"
              className="form-input"
              value={motDePasse}
              onChange={(e) => setMotDePasse(e.target.value)}
              required
              autoComplete="new-password"
              aria-required="true"
              minLength={8}
              placeholder="••••••••"
            />
          </div>

          <div className="form-group">
            <label htmlFor="confirm">Confirmer le mot de passe</label>
            <input
              id="confirm"
              type="password"
              className="form-input"
              value={confirm}
              onChange={(e) => setConfirm(e.target.value)}
              required
              autoComplete="new-password"
              aria-required="true"
              placeholder="••••••••"
            />
          </div>

          <p className="rgpd-notice">
            En créant un compte, vous acceptez notre <a href="/aide#rgpd">politique de confidentialité (RGPD)</a>.
            Vos données sont traitées conformément au règlement européen.
          </p>

          {error && (
            <div role="alert" className="form-error-box">{error}</div>
          )}

          <button type="submit" className="btn btn-primary btn-full" disabled={loading}>
            {loading ? 'Création…' : 'Créer mon compte'}
          </button>
        </form>

        <p className="auth-link">
          Déjà un compte ?{' '}
          <Link to="/connexion">Se connecter</Link>
        </p>
      </div>
    </div>
  );
}
