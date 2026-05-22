import './HelpPage.css';

export default function HelpPage() {
  return (
    <div className="help-page container">
      <h1>Aide &amp; Informations</h1>

      <nav aria-label="Sections" className="help-toc">
        <ul>
          <li><a href="#presentation">Présentation</a></li>
          <li><a href="#utilisation">Comment utiliser la plateforme</a></li>
          <li><a href="#rgpd">Protection des données (RGPD)</a></li>
          <li><a href="#accessibilite">Accessibilité (RGAA)</a></li>
          <li><a href="#mentions">Mentions légales</a></li>
        </ul>
      </nav>

      <section id="presentation" className="help-section">
        <h2>Présentation</h2>
        <p>
          <strong>(RE)Sources Relationnelles</strong> est une plateforme numérique portée par le
          Ministère des Solidarités et de la Santé destinée à proposer des ressources pour créer,
          renforcer et enrichir les relations des citoyens.
        </p>
        <p>
          Basée sur les travaux de la pyramide de Maslow, la plateforme reconnaît que la qualité
          de nos relations — famille, couple, amis, collègues — est l'un des leviers essentiels
          du bien-être et de la qualité de vie.
        </p>
        <div className="info-grid">
          <div className="info-card">
            <strong>📚 Catalogue de ressources</strong>
            <p>Articles, guides, vidéos, podcasts, activités, jeux… accessibles à tous les citoyens.</p>
          </div>
          <div className="info-card">
            <strong>👤 Espace personnel</strong>
            <p>Créez un compte pour accéder à toutes les ressources, créer les vôtres et suivre votre progression.</p>
          </div>
          <div className="info-card">
            <strong>💬 Échanges</strong>
            <p>Commentez et répondez aux ressources publiques dans un espace modéré.</p>
          </div>
          <div className="info-card">
            <strong>📊 Progression</strong>
            <p>Marquez vos favoris, les ressources exploitées et celles à explorer plus tard.</p>
          </div>
        </div>
      </section>

      <section id="utilisation" className="help-section">
        <h2>Comment utiliser la plateforme</h2>

        <h3>Citoyen non connecté</h3>
        <p>Sans compte, vous pouvez parcourir et consulter les ressources publiques, les filtrer par type, catégorie et mots-clés.</p>

        <h3>Citoyen connecté</h3>
        <ol>
          <li>Créez votre compte depuis la page <a href="/inscription">Inscription</a>.</li>
          <li>Accédez à l'ensemble des ressources, y compris les ressources partagées.</li>
          <li>Créez vos propres ressources (privées, partagées ou soumises à publication).</li>
          <li>Ajoutez des favoris, marquez les ressources exploitées ou sauvegardez pour plus tard.</li>
          <li>Commentez les ressources publiques et répondez aux autres membres.</li>
          <li>Consultez votre tableau de bord de progression dans <a href="/mon-espace">Mon espace</a>.</li>
        </ol>

        <h3>Rôles disponibles</h3>
        <ul>
          <li><strong>Citoyen</strong> : compte standard, accès à toutes les fonctionnalités publiques.</li>
          <li><strong>Modérateur</strong> : valide les ressources et modère les commentaires.</li>
          <li><strong>Administrateur</strong> : gère le catalogue, les catégories et les utilisateurs.</li>
          <li><strong>Super-administrateur</strong> : accès complet, peut créer des comptes privilégiés.</li>
        </ul>
      </section>

      <section id="rgpd" className="help-section">
        <h2>Protection des données (RGPD)</h2>
        <p>
          Conformément au <strong>Règlement Général sur la Protection des Données (RGPD)</strong>
          (UE) 2016/679, nous nous engageons à protéger vos données personnelles.
        </p>
        <h3>Données collectées</h3>
        <ul>
          <li>Nom complet et adresse e-mail lors de l'inscription</li>
          <li>Données de progression (favoris, exploitations, sauvegardes)</li>
          <li>Ressources créées et commentaires publiés</li>
        </ul>
        <h3>Vos droits</h3>
        <ul>
          <li>Droit d'accès à vos données</li>
          <li>Droit de rectification</li>
          <li>Droit à l'effacement ("droit à l'oubli")</li>
          <li>Droit à la portabilité</li>
        </ul>
        <p>
          Pour exercer vos droits, contactez le délégué à la protection des données (DPO) :
          <strong> dpo@solidarites-sante.gouv.fr</strong>
        </p>
        <h3>Sécurité des données</h3>
        <p>Les mots de passe sont chiffrés (bcrypt). Les communications sont sécurisées via HTTPS. Les tokens d'authentification JWT ont une durée de validité de 24h.</p>
      </section>

      <section id="accessibilite" className="help-section">
        <h2>Accessibilité (RGAA)</h2>
        <p>
          Cette plateforme s'engage à respecter le <strong>Référentiel Général d'Amélioration
          de l'Accessibilité (RGAA)</strong> version 4.1.
        </p>
        <ul>
          <li>Navigation au clavier complète</li>
          <li>Structure HTML sémantique (landmarks ARIA, titres hiérarchiques)</li>
          <li>Contrastes de couleurs conformes WCAG AA</li>
          <li>Textes alternatifs sur les images informatives</li>
          <li>Formulaires avec labels associés</li>
          <li>Messages d'état accessibles (aria-live)</li>
        </ul>
        <p>
          <strong>Niveau de conformité :</strong> Partiellement conforme RGAA 4.1.
          Pour signaler un problème d'accessibilité, écrivez à : <strong>accessibilite@solidarites-sante.gouv.fr</strong>
        </p>
      </section>

      <section id="mentions" className="help-section">
        <h2>Mentions légales</h2>
        <p><strong>Éditeur :</strong> Ministère des Solidarités et de la Santé — Direction du Numérique</p>
        <p><strong>Directeur de la publication :</strong> Secrétaire général du Ministère</p>
        <p><strong>Hébergeur :</strong> Direction Interministérielle du Numérique (DINUM)</p>
        <p><strong>Projet :</strong> Réalisé dans le cadre du projet collaboratif INFCDAAL1 — CESI École d'ingénieurs</p>
      </section>
    </div>
  );
}
