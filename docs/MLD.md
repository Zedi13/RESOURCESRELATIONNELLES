# MLD — (RE)Sources Relationnelles
> Modèle Logique de Données — Dérivé du MCD Merise

---

## Tables et clés

```
utilisateurs (#id, nom_complet, email, mot_de_passe, role, est_verifie, est_actif, derniere_connexion, date_inscription)

categories (#id, nom, description, couleur, icone, ordre, est_active, date_creation)

types_relation (#id, libelle, description, ordre)

ressources (#id, titre, description, contenu, type, visibilite, statut,
            auteur_id→utilisateurs, categorie_id→categories,
            url_externe, duree_estimee_min, vues, partages,
            date_creation, date_modification, date_publication)

ressource_type_relation (#ressource_id→ressources, #type_relation_id→types_relation)

commentaires (#id, ressource_id→ressources, auteur_id→utilisateurs,
              parent_id→commentaires, contenu, statut,
              moderateur_id→utilisateurs, date_moderation, date_creation)

favoris (#utilisateur_id→utilisateurs, #ressource_id→ressources, date_ajout)

exploitations (#utilisateur_id→utilisateurs, #ressource_id→ressources, date_exploitation)

sauvegardes (#utilisateur_id→utilisateurs, #ressource_id→ressources, date_sauvegarde)
```

---

## Diagramme relationnel

```
┌─────────────────────┐
│    utilisateurs     │
├─────────────────────┤
│ PK id               │◄──────────────────────────────────────────┐
│    nom_complet      │◄────────────────────────────────────┐     │
│    email (UQ)       │◄──────────────────────────────┐     │     │
│    mot_de_passe     │                               │     │     │
│    role             │                               │     │     │
│    est_verifie      │                               │     │     │
│    est_actif        │                               │     │     │
│    date_inscription │                               │     │     │
└─────────────────────┘                               │     │     │
         │ (auteur)                                   │     │     │
         │ 1,1                                        │     │     │
         ▼ 0,n                                        │     │     │
┌─────────────────────┐         ┌──────────────────┐  │     │     │
│      ressources     │         │    categories    │  │     │     │
├─────────────────────┤         ├──────────────────┤  │     │     │
│ PK id               │  0,n    │ PK id            │  │     │     │
│ FK auteur_id        │─────────│    nom (UQ)      │  │     │     │
│ FK categorie_id ────┼────1,1──│    description   │  │     │     │
│    titre            │         │    couleur       │  │     │     │
│    description      │         │    icone         │  │     │     │
│    contenu          │         │    ordre         │  │     │     │
│    type             │         └──────────────────┘  │     │     │
│    visibilite       │                               │     │     │
│    statut           │         ┌──────────────────┐  │     │     │
│    vues             │  0,n    │  types_relation  │  │     │     │
│    partages         │─────────│ PK id            │  │     │     │
│    duree_min        │  1,n    │    libelle (UQ)  │  │     │     │
│    date_creation    │    (via │    description   │  │     │     │
└─────────────────────┘  table  └──────────────────┘  │     │     │
         │           ressource_type_relation)          │     │     │
         │ 0,n                                         │     │     │
         ▼ 1,1                                         │     │     │
┌─────────────────────┐                               │     │     │
│    commentaires     │                               │     │     │
├─────────────────────┤                               │     │     │
│ PK id               │   0,n (réponse)               │     │     │
│ FK ressource_id     │──┐                            │     │     │
│ FK auteur_id ───────┼──┼────────────────────────────┘     │     │
│ FK parent_id ───────┼──┘ (réflexive, nullable)            │     │
│ FK moderateur_id ───┼──────────────────────────────────────┘     │
│    contenu          │                                            │
│    statut           │                                            │
│    date_creation    │                                            │
└─────────────────────┘                                            │
                                                                   │
┌─────────────────────┐         ┌──────────────────────────┐       │
│       favoris       │         │      exploitations        │       │
├─────────────────────┤         ├──────────────────────────┤       │
│ PK utilisateur_id ──┼─────────┼─ PK utilisateur_id       │       │
│ PK ressource_id     │         │  PK ressource_id          │       │
│    date_ajout       │         │     date_exploitation     │       │
└─────────────────────┘         └──────────────────────────┘       │
                                                                   │
┌─────────────────────┐                                            │
│     sauvegardes     │                                            │
├─────────────────────┤                                            │
│ PK utilisateur_id ──┼───────────────────────────────────────────┘
│ PK ressource_id     │
│    date_sauvegarde  │
└─────────────────────┘
```

---

## Règles de transformation MCD → MLD

| Règle | Application |
|-------|-------------|
| Association (1,1)/(0,n) → FK côté (1,1) | `ressources.auteur_id`, `ressources.categorie_id`, `commentaires.ressource_id`, `commentaires.auteur_id` |
| Association (0,n)/(0,n) → table de jonction | `ressource_type_relation`, `favoris`, `exploitations`, `sauvegardes` |
| Association réflexive (0,1)/(0,n) → FK nullable dans la même table | `commentaires.parent_id` (nullable) |
| Association (0,n)/(0,1) → FK nullable côté (0,1) | `commentaires.moderateur_id` (nullable) |

---

## Index créés

| Table | Index | Type | Justification |
|-------|-------|------|---------------|
| utilisateurs | email | UNIQUE | Connexion, unicité |
| utilisateurs | role | INDEX | Filtrer par rôle |
| ressources | auteur_id | INDEX | Ressources d'un utilisateur |
| ressources | categorie_id | INDEX | Filtrer par catégorie |
| ressources | statut | INDEX | Ressources publiées / en attente |
| ressources | visibilite | INDEX | Ressources publiques |
| ressources | (titre, description) | FULLTEXT | Recherche textuelle |
| commentaires | ressource_id | INDEX | Commentaires d'une ressource |
| commentaires | parent_id | INDEX | Réponses à un commentaire |
| favoris | ressource_id | INDEX | Compter les favoris d'une ressource |
| exploitations | ressource_id | INDEX | Compter les exploitations |
| sauvegardes | ressource_id | INDEX | Compter les sauvegardes |

---

## Vues créées

| Vue | Description |
|-----|-------------|
| `v_ressources_publiques` | Ressources publiées + catégorie + auteur |
| `v_statistiques` | KPIs globaux (vues totales, utilisateurs, etc.) |
| `v_progression_utilisateur` | Favoris / exploités / sauvegardés par utilisateur |
| `v_top_ressources` | Classement des ressources par vues |
