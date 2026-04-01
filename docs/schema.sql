-- ============================================================
--  (RE)Sources Relationnelles — Schéma de base de données
--  Auteur  : Projet INFCDAAL2
--  Version : 1.0.0
--  SGBD    : MySQL 8 / MariaDB 10.6+
-- ============================================================

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ============================================================
-- SUPPRESSION (ordre inverse des dépendances FK)
-- ============================================================

DROP TABLE IF EXISTS sauvegardes;
DROP TABLE IF EXISTS exploitations;
DROP TABLE IF EXISTS favoris;
DROP TABLE IF EXISTS commentaires;
DROP TABLE IF EXISTS ressource_type_relation;
DROP TABLE IF EXISTS ressources;
DROP TABLE IF EXISTS types_relation;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS utilisateurs;

-- ============================================================
-- TABLE : utilisateurs
-- ============================================================

CREATE TABLE utilisateurs (
    id               INT            NOT NULL AUTO_INCREMENT,
    nom_complet      VARCHAR(100)   NOT NULL,
    email            VARCHAR(150)   NOT NULL,
    mot_de_passe     VARCHAR(255)   NOT NULL COMMENT 'Hash bcrypt',
    role             ENUM(
                         'citoyen',
                         'moderateur',
                         'admin',
                         'super_admin'
                     )              NOT NULL DEFAULT 'citoyen',
    est_verifie      TINYINT(1)     NOT NULL DEFAULT 0,
    est_actif        TINYINT(1)     NOT NULL DEFAULT 1,
    derniere_connexion DATETIME     NULL,
    date_inscription DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_utilisateurs_email (email),
    KEY idx_utilisateurs_role (role),
    KEY idx_utilisateurs_est_actif (est_actif)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Comptes citoyens, modérateurs et administrateurs';

-- ============================================================
-- TABLE : categories
-- ============================================================

CREATE TABLE categories (
    id            INT           NOT NULL AUTO_INCREMENT,
    nom           VARCHAR(100)  NOT NULL,
    description   TEXT          NULL,
    couleur       VARCHAR(7)    NOT NULL DEFAULT '#2E86AB' COMMENT 'Code hexadécimal ex: #2E86AB',
    icone         VARCHAR(50)   NOT NULL DEFAULT 'category' COMMENT 'Nom icône Material / FontAwesome',
    ordre         SMALLINT      NOT NULL DEFAULT 0         COMMENT 'Ordre d\'affichage',
    est_active    TINYINT(1)    NOT NULL DEFAULT 1,
    date_creation DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_categories_nom (nom),
    KEY idx_categories_ordre (ordre)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Catalogue des catégories de ressources';

-- ============================================================
-- TABLE : types_relation
-- ============================================================

CREATE TABLE types_relation (
    id          INT           NOT NULL AUTO_INCREMENT,
    libelle     VARCHAR(50)   NOT NULL,
    description VARCHAR(255)  NULL,
    ordre       SMALLINT      NOT NULL DEFAULT 0,

    PRIMARY KEY (id),
    UNIQUE KEY uq_types_relation_libelle (libelle)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Types de relations concernées par les ressources (couple, famille…)';

-- ============================================================
-- TABLE : ressources
-- ============================================================

CREATE TABLE ressources (
    id                 INT           NOT NULL AUTO_INCREMENT,
    titre              VARCHAR(255)  NOT NULL,
    description        TEXT          NOT NULL,
    contenu            LONGTEXT      NOT NULL,
    type               ENUM(
                           'article',
                           'video',
                           'audio',
                           'activite',
                           'jeu',
                           'podcast',
                           'document',
                           'lien'
                       )             NOT NULL DEFAULT 'article',
    visibilite         ENUM(
                           'privee',
                           'partagee',
                           'publique'
                       )             NOT NULL DEFAULT 'publique',
    statut             ENUM(
                           'brouillon',
                           'en_attente',
                           'publie',
                           'suspendu'
                       )             NOT NULL DEFAULT 'brouillon',
    auteur_id          INT           NOT NULL,
    categorie_id       INT           NOT NULL,
    url_externe        VARCHAR(500)  NULL     COMMENT 'URL pour les ressources de type lien ou vidéo',
    duree_estimee_min  SMALLINT      NOT NULL DEFAULT 0 COMMENT 'Durée de lecture estimée en minutes',
    vues               INT           NOT NULL DEFAULT 0,
    partages           INT           NOT NULL DEFAULT 0,
    date_creation      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modification  DATETIME      NULL     ON UPDATE CURRENT_TIMESTAMP,
    date_publication   DATETIME      NULL,

    PRIMARY KEY (id),
    KEY idx_ressources_auteur    (auteur_id),
    KEY idx_ressources_categorie (categorie_id),
    KEY idx_ressources_statut    (statut),
    KEY idx_ressources_visibilite(visibilite),
    KEY idx_ressources_type      (type),
    KEY idx_ressources_date      (date_creation),
    FULLTEXT KEY ft_ressources_recherche (titre, description),

    CONSTRAINT fk_ressources_auteur
        FOREIGN KEY (auteur_id)
        REFERENCES utilisateurs (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_ressources_categorie
        FOREIGN KEY (categorie_id)
        REFERENCES categories (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Ressources relationnelles (articles, vidéos, activités…)';

-- ============================================================
-- TABLE : ressource_type_relation  (association CONCERNE)
-- ============================================================

CREATE TABLE ressource_type_relation (
    ressource_id     INT NOT NULL,
    type_relation_id INT NOT NULL,

    PRIMARY KEY (ressource_id, type_relation_id),
    KEY idx_rtr_type_relation (type_relation_id),

    CONSTRAINT fk_rtr_ressource
        FOREIGN KEY (ressource_id)
        REFERENCES ressources (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_rtr_type_relation
        FOREIGN KEY (type_relation_id)
        REFERENCES types_relation (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Association N:N entre ressources et types de relation';

-- ============================================================
-- TABLE : commentaires
-- ============================================================

CREATE TABLE commentaires (
    id              INT          NOT NULL AUTO_INCREMENT,
    ressource_id    INT          NOT NULL,
    auteur_id       INT          NOT NULL,
    parent_id       INT          NULL     COMMENT 'NULL = commentaire racine, sinon = réponse',
    contenu         TEXT         NOT NULL,
    statut          ENUM(
                        'en_attente',
                        'approuve',
                        'rejete'
                    )            NOT NULL DEFAULT 'en_attente',
    moderateur_id   INT          NULL     COMMENT 'Utilisateur qui a modéré ce commentaire',
    date_moderation DATETIME     NULL,
    date_creation   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    KEY idx_commentaires_ressource   (ressource_id),
    KEY idx_commentaires_auteur      (auteur_id),
    KEY idx_commentaires_parent      (parent_id),
    KEY idx_commentaires_statut      (statut),
    KEY idx_commentaires_moderateur  (moderateur_id),

    CONSTRAINT fk_commentaires_ressource
        FOREIGN KEY (ressource_id)
        REFERENCES ressources (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_commentaires_auteur
        FOREIGN KEY (auteur_id)
        REFERENCES utilisateurs (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_commentaires_parent
        FOREIGN KEY (parent_id)
        REFERENCES commentaires (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_commentaires_moderateur
        FOREIGN KEY (moderateur_id)
        REFERENCES utilisateurs (id)
        ON DELETE SET NULL
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Commentaires et réponses sur les ressources';

-- ============================================================
-- TABLE : favoris  (association MET_EN_FAVORIS)
-- ============================================================

CREATE TABLE favoris (
    utilisateur_id INT      NOT NULL,
    ressource_id   INT      NOT NULL,
    date_ajout     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (utilisateur_id, ressource_id),
    KEY idx_favoris_ressource (ressource_id),

    CONSTRAINT fk_favoris_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_favoris_ressource
        FOREIGN KEY (ressource_id)
        REFERENCES ressources (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Ressources mises en favoris par les utilisateurs';

-- ============================================================
-- TABLE : exploitations  (association EXPLOITE)
-- ============================================================

CREATE TABLE exploitations (
    utilisateur_id   INT      NOT NULL,
    ressource_id     INT      NOT NULL,
    date_exploitation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (utilisateur_id, ressource_id),
    KEY idx_exploitations_ressource (ressource_id),

    CONSTRAINT fk_exploitations_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_exploitations_ressource
        FOREIGN KEY (ressource_id)
        REFERENCES ressources (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Ressources marquées comme exploitées par les utilisateurs';

-- ============================================================
-- TABLE : sauvegardes  (association SAUVEGARDE)
-- ============================================================

CREATE TABLE sauvegardes (
    utilisateur_id  INT      NOT NULL,
    ressource_id    INT      NOT NULL,
    date_sauvegarde DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (utilisateur_id, ressource_id),
    KEY idx_sauvegardes_ressource (ressource_id),

    CONSTRAINT fk_sauvegardes_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_sauvegardes_ressource
        FOREIGN KEY (ressource_id)
        REFERENCES ressources (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Ressources mises de côté pour plus tard';

-- ============================================================
-- RÉACTIVATION des clés étrangères
-- ============================================================

SET foreign_key_checks = 1;

-- ============================================================
-- DONNÉES INITIALES (seed)
-- ============================================================

-- Catégories
INSERT INTO categories (nom, description, couleur, icone, ordre) VALUES
('Communication',          'Améliorer votre façon d\'exprimer et d\'écouter',         '#2E86AB', 'chat_bubble_outline',  1),
('Gestion des conflits',   'Résoudre les désaccords avec bienveillance',               '#E53935', 'balance',              2),
('Développement personnel','Grandir pour mieux vous relier aux autres',                '#43A047', 'self_improvement',     3),
('Parentalité',            'Construire des liens solides avec vos enfants',            '#8E24AA', 'family_restroom',      4),
('Vie de couple',          'Nourrir et renforcer votre relation amoureuse',            '#E91E63', 'favorite_outline',     5),
('Amitié',                 'Cultiver des amitiés profondes et durables',               '#00ACC1', 'people_outline',       6),
('Vie professionnelle',    'Optimiser vos relations au travail',                       '#1565C0', 'work_outline',         7);

-- Types de relation
INSERT INTO types_relation (libelle, description, ordre) VALUES
('Couple',         'Relation amoureuse et conjugale',           1),
('Famille',        'Relations familiales (parents, enfants…)',  2),
('Amis',           'Amitiés et relations de proximité',         3),
('Professionnel',  'Relations au travail et collègues',         4),
('Social',         'Relations dans la communauté et la société',5),
('Soi-même',       'Relation à soi, développement intérieur',   6);

-- Super-administrateur (mot de passe : Admin@2025 hashé bcrypt)
INSERT INTO utilisateurs (nom_complet, email, mot_de_passe, role, est_verifie, est_actif) VALUES
('Admin Système', 'admin@ressources-relationnelles.fr',
 '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
 'super_admin', 1, 1);

