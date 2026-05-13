-- ============================================================
--  (RE)Sources Relationnelles — Données de test
--  Exécuter APRÈS schema.sql
--  Tous les mots de passe sont : password123
-- ============================================================

SET NAMES utf8mb4;
SET foreign_key_checks = 0;

-- ============================================================
-- UTILISATEURS
-- Mot de passe de tous les comptes ci-dessous : password123
-- (Hash BCrypt compatible Spring Security)
-- ============================================================

INSERT INTO utilisateurs (nom_complet, email, mot_de_passe, role, est_verifie, est_actif, date_inscription) VALUES
-- Modérateur
('Marie Dupont',    'moderateur@ressources-relationnelles.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'moderateur', 1, 1, NOW()),

-- Administrateur
('Jean Martin',     'admin2@ressources-relationnelles.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'admin', 1, 1, NOW()),

-- Citoyens
('Sophie Bernard',  'sophie.bernard@email.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'citoyen', 1, 1, NOW()),

('Lucas Petit',     'lucas.petit@email.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'citoyen', 1, 1, NOW()),

('Emma Leroy',      'emma.leroy@email.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'citoyen', 1, 1, NOW()),

('Thomas Moreau',   'thomas.moreau@email.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'citoyen', 0, 1, NOW()),

('Clara Simon',     'clara.simon@email.fr',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'citoyen', 1, 1, NOW());

-- ============================================================
-- RESSOURCES
-- auteur_id 1 = super admin | 2 = moderateur | 3 = admin2
-- categorie_id : 1=Communication 2=Conflits 3=Dev perso 4=Parentalité 5=Couple 6=Amitié 7=Pro
-- ============================================================

INSERT INTO ressources (titre, description, contenu, type, visibilite, statut, auteur_id, categorie_id, duree_estimee_min, vues, partages, date_creation, date_publication) VALUES

-- === COMMUNICATION ===
('L\'écoute active : la clé d\'une communication réussie',
 'Découvrez comment l\'écoute active transforme vos relations en vous permettant de vraiment comprendre l\'autre.',
 '<h2>Qu\'est-ce que l\'écoute active ?</h2>
<p>L\'écoute active est une technique de communication développée par le psychologue Carl Rogers. Elle consiste à écouter son interlocuteur non seulement avec ses oreilles, mais avec toute son attention, son corps et son empathie.</p>
<h2>Les 5 principes fondamentaux</h2>
<ul>
  <li><strong>Être présent</strong> : éteindre son téléphone, regarder la personne dans les yeux</li>
  <li><strong>Ne pas interrompre</strong> : laisser l\'autre finir avant de répondre</li>
  <li><strong>Reformuler</strong> : « Si je comprends bien, tu dis que... »</li>
  <li><strong>Valider les émotions</strong> : « Je comprends que tu te sentes... »</li>
  <li><strong>Poser des questions ouvertes</strong> : « Comment as-tu vécu cette situation ? »</li>
</ul>
<h2>Exercice pratique</h2>
<p>Lors de votre prochaine conversation, imposez-vous 30 secondes de silence après que l\'autre a fini de parler. Ce simple exercice change tout.</p>',
 'article', 'publique', 'publie', 1, 1, 8, 245, 32, NOW() - INTERVAL 30 DAY, NOW() - INTERVAL 30 DAY),

('La Communication Non Violente (CNV) en pratique',
 'La CNV de Marshall Rosenberg : un outil puissant pour exprimer vos besoins sans blesser l\'autre.',
 '<h2>Les 4 étapes de la CNV</h2>
<p>La Communication Non Violente repose sur un processus en 4 étapes :</p>
<ol>
  <li><strong>Observation</strong> : décrire les faits sans jugement. « Quand tu rentres sans me prévenir... »</li>
  <li><strong>Sentiment</strong> : exprimer ce que vous ressentez. « Je me sens inquiet(e)... »</li>
  <li><strong>Besoin</strong> : identifier le besoin sous-jacent. « Parce que j\'ai besoin de sécurité... »</li>
  <li><strong>Demande</strong> : formuler une demande concrète et négociable. « Pourrais-tu me prévenir quand tu vas rentrer tard ? »</li>
</ol>
<h2>Exemple concret</h2>
<p>Au lieu de dire : « Tu ne penses jamais à moi ! »<br>
Dites : « Quand tu n\'as pas appelé hier soir (observation), je me suis sentie seule (sentiment), parce que j\'ai besoin de connexion avec toi (besoin). Pourrais-tu m\'envoyer un message quand tu es occupé ? (demande) »</p>',
 'article', 'publique', 'publie', 1, 1, 12, 189, 41, NOW() - INTERVAL 25 DAY, NOW() - INTERVAL 25 DAY),

('Méditation guidée : Ouvrir son cœur à l\'autre',
 'Une séance audio de 15 minutes pour développer l\'empathie et la bienveillance envers vos proches.',
 '<p>Installez-vous confortablement, fermez les yeux et écoutez cette méditation guidée conçue pour cultiver l\'amour bienveillant (metta) envers vos relations.</p>
<p>Cette pratique est issue de la tradition bouddhiste et a été validée scientifiquement pour améliorer la qualité des relations interpersonnelles.</p>
<p>Pratiquez 5 minutes par jour pendant 21 jours pour des résultats durables.</p>',
 'audio', 'publique', 'publie', 2, 1, 15, 312, 58, NOW() - INTERVAL 20 DAY, NOW() - INTERVAL 20 DAY),

-- === GESTION DES CONFLITS ===
('Désamorcer un conflit en 5 étapes',
 'Techniques éprouvées pour gérer les désaccords sans escalade émotionnelle.',
 '<h2>Pourquoi les conflits s\'enflamment-ils ?</h2>
<p>Les conflits s\'intensifient souvent à cause de l\'amygdale, cette partie du cerveau qui déclenche la réaction "combat ou fuite". Comprendre ce mécanisme est la première étape.</p>
<h2>Les 5 étapes pour désamorcer</h2>
<ol>
  <li><strong>Pause</strong> : si les émotions sont trop fortes, proposez une pause de 20 minutes</li>
  <li><strong>Respiration</strong> : 4 secondes inspiration, 4 secondes expiration, 3 fois</li>
  <li><strong>Identification</strong> : qu\'est-ce qui m\'a vraiment blessé ?</li>
  <li><strong>Expression</strong> : parler en "je" plutôt qu\'en "tu"</li>
  <li><strong>Solution</strong> : chercher ensemble, pas l\'un contre l\'autre</li>
</ol>',
 'article', 'publique', 'publie', 1, 2, 10, 421, 67, NOW() - INTERVAL 18 DAY, NOW() - INTERVAL 18 DAY),

('Jeu de rôle : Gérer le désaccord avec bienveillance',
 'Une activité interactive pour deux personnes, parfaite pour s\'entraîner à la résolution de conflits.',
 '<h2>Comment jouer ?</h2>
<p>Ce jeu de rôle se pratique à deux. Chacun reçoit un scénario et doit gérer le conflit en appliquant les règles de communication bienveillante.</p>
<h2>Scénarios proposés</h2>
<p><strong>Scénario 1 - Le couple :</strong> L\'un rentre tard sans prévenir, l\'autre était inquiet.</p>
<p><strong>Scénario 2 - Les amis :</strong> Un ami a annulé des plans importants au dernier moment.</p>
<p><strong>Scénario 3 - La famille :</strong> Désaccord sur l\'organisation des vacances.</p>
<h2>Règles du jeu</h2>
<ul>
  <li>Parler uniquement en "je"</li>
  <li>Écouter sans interrompre</li>
  <li>Chercher un compromis en 10 minutes</li>
</ul>',
 'jeu', 'publique', 'publie', 1, 2, 20, 156, 29, NOW() - INTERVAL 15 DAY, NOW() - INTERVAL 15 DAY),

-- === DÉVELOPPEMENT PERSONNEL ===
('Développer son intelligence émotionnelle',
 'Comprendre et maîtriser ses émotions pour des relations plus épanouissantes.',
 '<h2>Les 4 composantes de l\'intelligence émotionnelle</h2>
<p>Daniel Goleman a identifié 4 dimensions clés :</p>
<ul>
  <li><strong>Conscience de soi</strong> : reconnaître ses propres émotions</li>
  <li><strong>Maîtrise de soi</strong> : gérer ses réactions</li>
  <li><strong>Empathie</strong> : comprendre les émotions des autres</li>
  <li><strong>Compétences sociales</strong> : gérer les relations</li>
</ul>
<h2>3 exercices quotidiens</h2>
<p>1. <strong>Journal émotionnel</strong> : noter 3 émotions ressenties chaque soir et leur cause.</p>
<p>2. <strong>Scan corporel</strong> : 2 fois par jour, identifier où vous ressentez vos émotions dans votre corps.</p>
<p>3. <strong>Le recadrage</strong> : face à une émotion négative, chercher une interprétation alternative.</p>',
 'article', 'publique', 'publie', 3, 3, 15, 534, 89, NOW() - INTERVAL 22 DAY, NOW() - INTERVAL 22 DAY),

('TED Talk : L\'art de la vulnérabilité par Brené Brown',
 'Ce TED Talk révolutionnaire sur la vulnérabilité comme force dans les relations humaines.',
 '<p>Brené Brown, chercheuse en sciences sociales, a passé des années à étudier la connexion humaine. Sa conclusion surprenante : la vulnérabilité est la condition nécessaire à toute relation authentique.</p>
<p>Dans cette conférence vue plus de 60 millions de fois, elle explique pourquoi nous avons honte de notre besoin de connexion et comment l\'accepter change tout.</p>
<p><strong>Citation clé :</strong> « La vulnérabilité est le berceau de l\'innovation, de la créativité et du changement. »</p>',
 'video', 'publique', 'publie', 2, 3, 20, 678, 134, NOW() - INTERVAL 28 DAY, NOW() - INTERVAL 28 DAY),

-- === PARENTALITÉ ===
('La parentalité positive : punir ou éduquer ?',
 'Comprendre les bases de la parentalité bienveillante pour une relation épanouissante avec vos enfants.',
 '<h2>Punition vs Conséquence naturelle</h2>
<p>La punition crée de la peur et de la rébellion. Les conséquences naturelles et logiques, elles, apprennent la responsabilité.</p>
<h2>Les 3 piliers de la parentalité positive</h2>
<ol>
  <li><strong>Connexion avant correction</strong> : s\'assurer que l\'enfant se sent aimé avant de corriger</li>
  <li><strong>Ferme ET bienveillant</strong> : des limites claires avec empathie</li>
  <li><strong>Encouragement plutôt que louange</strong> : « Tu as travaillé dur » plutôt que « Tu es intelligent »</li>
</ol>
<h2>Pour aller plus loin</h2>
<p>Livre recommandé : « Discipline positive » de Jane Nelsen</p>',
 'article', 'publique', 'publie', 1, 4, 12, 289, 45, NOW() - INTERVAL 12 DAY, NOW() - INTERVAL 12 DAY),

-- === VIE DE COUPLE ===
('Les 5 langages de l\'amour selon Gary Chapman',
 'Découvrez votre langage de l\'amour et celui de votre partenaire pour mieux vous comprendre.',
 '<h2>Les 5 langages de l\'amour</h2>
<p>Gary Chapman a identifié 5 façons principales dont les gens expriment et reçoivent l\'amour :</p>
<ol>
  <li><strong>Les paroles valorisantes</strong> : compliments, encouragements, mots d\'affection</li>
  <li><strong>Les moments de qualité</strong> : attention exclusive, activités partagées</li>
  <li><strong>Les cadeaux</strong> : symboles tangibles d\'amour</li>
  <li><strong>Les services rendus</strong> : faire des choses pour l\'autre</li>
  <li><strong>Le toucher physique</strong> : câlins, caresses, tendresse</li>
</ol>
<h2>Quel est votre langage ?</h2>
<p>Faites le quiz avec votre partenaire et comparez vos résultats. Vous découvrirez peut-être pourquoi certains gestes vous touchent plus que d\'autres.</p>',
 'article', 'publique', 'publie', 3, 5, 10, 892, 201, NOW() - INTERVAL 35 DAY, NOW() - INTERVAL 35 DAY),

('Activité couple : Le jeu des 36 questions',
 'L\'expérience scientifique qui rapproche deux personnes en 45 minutes. Parfait pour raviver la connexion.',
 '<h2>L\'origine</h2>
<p>Le psychologue Arthur Aron a démontré que répondre à 36 questions spécifiques avec un inconnu — ou son partenaire — crée une intimité profonde en moins d\'une heure.</p>
<h2>Comment jouer ?</h2>
<p>Asseyez-vous face à face, sans téléphone. Répondez chacun à chaque question honnêtement. Graduellement, les questions deviennent plus intimes.</p>
<h2>Exemples de questions</h2>
<p><strong>Niveau 1 :</strong> « Si tu pouvais inviter quelqu\'un à dîner, qui serait-ce et pourquoi ? »</p>
<p><strong>Niveau 2 :</strong> « Quel est ton souvenir le plus heureux ? »</p>
<p><strong>Niveau 3 :</strong> « Quand as-tu pleuré pour la dernière fois devant quelqu\'un ? »</p>',
 'activite', 'publique', 'publie', 1, 5, 45, 445, 98, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 10 DAY),

-- === AMITIÉ ===
('Cultiver des amitiés profondes à l\'âge adulte',
 'Pourquoi est-il plus difficile de se faire des amis adulte ? Et comment y remédier.',
 '<h2>Le paradoxe de l\'amitié adulte</h2>
<p>Selon une étude de 2021, 36% des Français se sentent seuls régulièrement. Pourtant, la solitude est l\'un des facteurs de risque de santé les plus importants.</p>
<h2>Les 3 conditions de l\'amitié</h2>
<p>Le sociologue Robert Weiss identifie 3 ingrédients nécessaires : la <strong>proximité</strong>, les <strong>interactions répétées</strong>, et le <strong>cadre propice à la confiance</strong>.</p>
<h2>Stratégies concrètes</h2>
<ul>
  <li>Rejoindre un club ou une association (sport, lecture, bénévolat)</li>
  <li>Être le premier à inviter, sans attendre la réciprocité</li>
  <li>Transformer les connaissances en amis : inviter pour un café</li>
  <li>La règle des « 3 fois » : proposer 3 fois avant de conclure que la personne n\'est pas intéressée</li>
</ul>',
 'article', 'publique', 'publie', 2, 6, 8, 267, 53, NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 8 DAY),

-- === VIE PROFESSIONNELLE ===
('Gérer les relations toxiques au travail',
 'Identifier et se protéger des dynamiques relationnelles négatives en milieu professionnel.',
 '<h2>Les 4 profils toxiques courants</h2>
<ol>
  <li><strong>Le saboteur</strong> : prend le crédit de votre travail</li>
  <li><strong>Le manipulateur</strong> : crée des conflits entre collègues</li>
  <li><strong>Le narcissique</strong> : monopolise l\'attention et dévalorise les autres</li>
  <li><strong>Le négatif chronique</strong> : étouffe toute initiative</li>
</ol>
<h2>Stratégies de protection</h2>
<ul>
  <li><strong>La distance émotionnelle</strong> : limiter les informations personnelles partagées</li>
  <li><strong>La documentation</strong> : garder des traces écrites des échanges importants</li>
  <li><strong>Les alliés</strong> : construire un réseau de soutien positif</li>
  <li><strong>Les limites claires</strong> : dire non de façon professionnelle et ferme</li>
</ul>',
 'article', 'publique', 'publie', 3, 7, 10, 389, 72, NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 5 DAY),

-- Ressource en attente (créée par un citoyen)
('Mon expérience avec la méditation de pleine conscience',
 'Comment 10 minutes de méditation par jour ont transformé mes relations familiales.',
 '<p>Il y a six mois, je vivais dans un état de stress permanent. Mes enfants me reprochaient d\'être toujours absent(e), même quand j\'étais là physiquement. J\'ai commencé la méditation par hasard et tout a changé.</p>
<p>Je partage ici mon expérience et les ressources qui m\'ont aidé.</p>',
 'article', 'partagee', 'en_attente', 4, 3, 5, 0, 0, NOW() - INTERVAL 2 DAY, NULL),

-- Ressource privée
('Mes notes de lecture : Les 4 accords toltèques',
 'Résumé personnel du livre de Don Miguel Ruiz pour mes relations personnelles.',
 '<p>Notes personnelles sur le livre. Les 4 accords : 1) Que ta parole soit impeccable. 2) N\'en fais pas une affaire personnelle. 3) Ne fais pas de suppositions. 4) Fais toujours de ton mieux.</p>',
 'document', 'privee', 'brouillon', 4, 3, 3, 0, 0, NOW() - INTERVAL 1 DAY, NULL);

-- ============================================================
-- ASSOCIATION RESSOURCES ↔ TYPES DE RELATION
-- type_relation_id : 1=Couple 2=Famille 3=Amis 4=Pro 5=Social 6=Soi
-- ============================================================

INSERT INTO ressource_type_relation (ressource_id, type_relation_id) VALUES
-- Écoute active → Couple, Famille, Amis, Pro
(1, 1), (1, 2), (1, 3), (1, 4),
-- CNV → Couple, Famille, Amis, Pro
(2, 1), (2, 2), (2, 3), (2, 4),
-- Méditation → Soi, Famille, Couple
(3, 6), (3, 2), (3, 1),
-- Désamorcer conflit → Couple, Famille, Amis, Pro
(4, 1), (4, 2), (4, 3), (4, 4),
-- Jeu de rôle → Couple, Amis, Famille
(5, 1), (5, 3), (5, 2),
-- Intelligence émotionnelle → Soi, Couple, Pro
(6, 6), (6, 1), (6, 4),
-- TED Talk vulnérabilité → Soi, Couple, Amis
(7, 6), (7, 1), (7, 3),
-- Parentalité → Famille
(8, 2),
-- Langages de l'amour → Couple
(9, 1),
-- 36 questions → Couple, Amis
(10, 1), (10, 3),
-- Amitié adulte → Amis, Social
(11, 3), (11, 5),
-- Relations toxiques au travail → Pro
(12, 4),
-- Ressource citoyen → Soi, Famille
(13, 6), (13, 2),
-- Ressource privée → Soi
(14, 6);

-- ============================================================
-- COMMENTAIRES
-- ============================================================

INSERT INTO commentaires (ressource_id, auteur_id, contenu, statut, moderateur_id, date_moderation, date_creation) VALUES
-- Sur l'écoute active
(1, 4, 'Article vraiment utile ! J\'ai essayé la technique des 30 secondes de silence et c\'est bluffant. Mon mari était surpris mais la conversation a été beaucoup plus profonde.', 'approuve', 2, NOW() - INTERVAL 28 DAY, NOW() - INTERVAL 29 DAY),
(1, 5, 'Je travaille en tant qu\'infirmière et j\'utilise ces techniques tous les jours. Je confirme que ça fonctionne vraiment bien.', 'approuve', 2, NOW() - INTERVAL 27 DAY, NOW() - INTERVAL 28 DAY),
(1, 6, 'Merci pour cet article. Une question : comment faire quand l\'autre personne ne veut pas appliquer l\'écoute active ?', 'approuve', 2, NOW() - INTERVAL 26 DAY, NOW() - INTERVAL 27 DAY),
(1, 7, 'Super contenu ! Un peu théorique peut-être, des exemples vidéo seraient bienvenus.', 'approuve', 2, NOW() - INTERVAL 25 DAY, NOW() - INTERVAL 26 DAY),

-- Sur la CNV
(2, 4, 'La CNV a changé ma relation avec mes enfants. Avant je criais, maintenant j\'exprime mes besoins. C\'est magique.', 'approuve', 2, NOW() - INTERVAL 23 DAY, NOW() - INTERVAL 24 DAY),
(2, 5, 'Article excellent ! Je recommande le livre de Rosenberg pour aller plus loin : "Les mots sont des fenêtres".', 'approuve', 2, NOW() - INTERVAL 22 DAY, NOW() - INTERVAL 23 DAY),

-- Sur les langages de l'amour
(9, 4, 'On a fait le quiz avec mon mari et on a découvert qu\'on avait des langages complètement différents. Ça explique TELLEMENT de choses !', 'approuve', 2, NOW() - INTERVAL 33 DAY, NOW() - INTERVAL 34 DAY),
(9, 6, 'Mon langage c\'est les moments de qualité mais mon copain c\'est les services rendus. On se comprend mieux maintenant !', 'approuve', 2, NOW() - INTERVAL 32 DAY, NOW() - INTERVAL 33 DAY),
(9, 7, 'Contenu très intéressant mais j\'aimerais un quiz directement sur la plateforme pour identifier son langage.', 'en_attente', NULL, NULL, NOW() - INTERVAL 3 DAY),

-- Sur le jeu des 36 questions
(10, 5, 'On a fait ça avec mon partenaire après 5 ans de relation et on a appris des choses nouvelles l\'un sur l\'autre. Incroyable !', 'approuve', 2, NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 9 DAY),
(10, 7, 'Je l\'ai fait avec une amie proche et ça a renforcé notre amitié. Ces questions vont vraiment en profondeur.', 'approuve', 2, NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 8 DAY);

-- Réponses à des commentaires
INSERT INTO commentaires (ressource_id, auteur_id, parent_id, contenu, statut, moderateur_id, date_moderation, date_creation) VALUES
-- Réponse au commentaire 3 (la question sur l'autre qui ne veut pas)
(1, 1, 3, 'Excellente question ! Quand l\'autre ne pratique pas l\'écoute active, le plus important est de rester vous-même dans cette posture. Votre calme et votre écoute sincère peuvent progressivement inviter l\'autre à ralentir aussi.', 'approuve', 2, NOW() - INTERVAL 25 DAY, NOW() - INTERVAL 26 DAY),
-- Réponse au commentaire 5 (CNV enfants)
(2, 2, 5, 'Merci pour ce témoignage ! Le livre de Faber et Mazlish "Parler pour que les enfants écoutent" est aussi excellent en complément.', 'approuve', 2, NOW() - INTERVAL 21 DAY, NOW() - INTERVAL 22 DAY);

-- ============================================================
-- FAVORIS
-- ============================================================

INSERT INTO favoris (utilisateur_id, ressource_id, date_ajout) VALUES
(4, 1, NOW() - INTERVAL 20 DAY),
(4, 2, NOW() - INTERVAL 18 DAY),
(4, 9, NOW() - INTERVAL 15 DAY),
(4, 10, NOW() - INTERVAL 5 DAY),
(5, 1, NOW() - INTERVAL 25 DAY),
(5, 6, NOW() - INTERVAL 20 DAY),
(5, 7, NOW() - INTERVAL 18 DAY),
(5, 9, NOW() - INTERVAL 10 DAY),
(6, 4, NOW() - INTERVAL 12 DAY),
(6, 9, NOW() - INTERVAL 8 DAY),
(7, 2, NOW() - INTERVAL 22 DAY),
(7, 11, NOW() - INTERVAL 6 DAY);

-- ============================================================
-- EXPLOITATIONS (ressources terminées)
-- ============================================================

INSERT INTO exploitations (utilisateur_id, ressource_id, date_exploitation) VALUES
(4, 1, NOW() - INTERVAL 19 DAY),
(4, 9, NOW() - INTERVAL 14 DAY),
(5, 1, NOW() - INTERVAL 24 DAY),
(5, 7, NOW() - INTERVAL 17 DAY),
(5, 6, NOW() - INTERVAL 12 DAY),
(6, 4, NOW() - INTERVAL 11 DAY),
(7, 2, NOW() - INTERVAL 21 DAY),
(7, 11, NOW() - INTERVAL 5 DAY);

-- ============================================================
-- SAUVEGARDES (pour plus tard)
-- ============================================================

INSERT INTO sauvegardes (utilisateur_id, ressource_id, date_sauvegarde) VALUES
(4, 3, NOW() - INTERVAL 10 DAY),
(4, 6, NOW() - INTERVAL 8 DAY),
(4, 11, NOW() - INTERVAL 3 DAY),
(5, 4, NOW() - INTERVAL 15 DAY),
(5, 8, NOW() - INTERVAL 10 DAY),
(6, 1, NOW() - INTERVAL 11 DAY),
(6, 6, NOW() - INTERVAL 7 DAY),
(7, 9, NOW() - INTERVAL 20 DAY),
(7, 3, NOW() - INTERVAL 9 DAY);

-- ============================================================
SET foreign_key_checks = 1;

-- ============================================================
-- RÉCAPITULATIF DES COMPTES
-- ============================================================
-- | Email                                          | Rôle         | Mot de passe |
-- |------------------------------------------------|--------------|--------------|
-- | admin@ressources-relationnelles.fr             | super_admin  | Admin@2025   |
-- | moderateur@ressources-relationnelles.fr        | moderateur   | password123  |
-- | admin2@ressources-relationnelles.fr            | admin        | password123  |
-- | sophie.bernard@email.fr                        | citoyen      | password123  |
-- | lucas.petit@email.fr                           | citoyen      | password123  |
-- | emma.leroy@email.fr                            | citoyen      | password123  |
-- | thomas.moreau@email.fr (non vérifié)           | citoyen      | password123  |
-- | clara.simon@email.fr                           | citoyen      | password123  |
-- ============================================================
