import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import Layout from './components/layout/Layout';
import AdminLayout from './components/layout/AdminLayout';

import HomePage from './pages/public/HomePage';
import RessourcesPage from './pages/public/RessourcesPage';
import RessourceDetailPage from './pages/public/RessourceDetailPage';
import HelpPage from './pages/public/HelpPage';

import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';

import DashboardPage from './pages/citizen/DashboardPage';
import MyRessourcesPage from './pages/citizen/MyRessourcesPage';
import RessourceFormPage from './pages/citizen/RessourceFormPage';

import AdminDashboardPage from './pages/admin/AdminDashboardPage';
import AdminRessourcesPage from './pages/admin/AdminRessourcesPage';
import AdminCategoriesPage from './pages/admin/AdminCategoriesPage';
import AdminUsersPage from './pages/admin/AdminUsersPage';
import AdminModerationPage from './pages/admin/AdminModerationPage';
import AdminStatistiquesPage from './pages/admin/AdminStatistiquesPage';

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<HomePage />} />
            <Route path="/ressources" element={<RessourcesPage />} />
            <Route path="/ressources/:id" element={<RessourceDetailPage />} />
            <Route path="/aide" element={<HelpPage />} />
            <Route path="/connexion" element={<LoginPage />} />
            <Route path="/inscription" element={<RegisterPage />} />
            <Route path="/mon-espace" element={<DashboardPage />} />
            <Route path="/mon-espace/mes-ressources" element={<MyRessourcesPage />} />
            <Route path="/mon-espace/creer" element={<RessourceFormPage />} />
            <Route path="/mon-espace/modifier/:id" element={<RessourceFormPage />} />
          </Route>
          <Route path="/admin" element={<AdminLayout />}>
            <Route index element={<AdminDashboardPage />} />
            <Route path="ressources" element={<AdminRessourcesPage />} />
            <Route path="moderation" element={<AdminModerationPage />} />
            <Route path="categories" element={<AdminCategoriesPage />} />
            <Route path="utilisateurs" element={<AdminUsersPage />} />
            <Route path="statistiques" element={<AdminStatistiquesPage />} />
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}
