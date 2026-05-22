export type Role = 'CITOYEN' | 'MODERATEUR' | 'ADMIN' | 'SUPER_ADMIN';
export type TypeRessource = 'ARTICLE' | 'GUIDE' | 'VIDEO' | 'PODCAST' | 'ACTIVITE' | 'JEU' | 'ATELIER' | 'AUTRE';
export type Visibilite = 'PUBLIQUE' | 'PRIVEE' | 'PARTAGEE';
export type StatutRessource = 'BROUILLON' | 'EN_ATTENTE' | 'PUBLIE' | 'SUSPENDU' | 'ARCHIVE';
export type StatutCommentaire = 'EN_ATTENTE' | 'APPROUVE' | 'REJETE';

export interface Utilisateur {
  id: number;
  nomComplet: string;
  email: string;
  role: Role;
  estVerifie: boolean;
  estActif: boolean;
  dateInscription: string;
  derniereConnexion?: string;
}

export interface AuthResponse {
  token: string;
  type: string;
  utilisateur: Utilisateur;
}

export interface Categorie {
  id: number;
  nom: string;
  description?: string;
  couleur?: string;
  icone?: string;
  ordre?: number;
  estActive?: boolean;
  nombreRessources?: number;
}

export interface TypeRelation {
  id: number;
  libelle: string;
  description?: string;
  ordre?: number;
}

// ── Ressource summary (list endpoint) — flat auteur & categorie ──
export interface RessourceSummary {
  id: number;
  titre: string;
  description: string;
  type: TypeRessource;
  visibilite: Visibilite;
  statut: StatutRessource;
  auteurId: number;
  auteurNom: string;
  categorieId?: number;
  categorieNom?: string;
  couleurCategorie?: string;
  typesRelation: TypeRelation[];
  vues: number;
  partages: number;
  dateCreation: string;
  datePublication?: string;
  dureeEstimeeMin?: number;
}

// ── Ressource detail (getById) — nested categorie, has progression state ──
export interface Ressource {
  id: number;
  titre: string;
  description: string;
  contenu: string;
  type: TypeRessource;
  visibilite: Visibilite;
  statut: StatutRessource;
  auteurId: number;
  auteurNom: string;
  categorie?: Categorie;
  typesRelation: TypeRelation[];
  urlExterne?: string;
  dureeEstimeeMin?: number;
  vues: number;
  partages: number;
  dateCreation: string;
  dateModification?: string;
  datePublication?: string;
  estFavori?: boolean;
  estExploite?: boolean;
  estSauvegarde?: boolean;
}

export interface Commentaire {
  id: number;
  ressourceId?: number;
  contenu: string;
  auteurId: number;
  auteurNom: string;
  statut: StatutCommentaire;
  dateCreation: string;
  parentId?: number;
  reponses?: Commentaire[];
}

export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  first: boolean;
  last: boolean;
}

export interface ProgressionResponse {
  favoris: RessourceSummary[];
  ressourcesExploitees: RessourceSummary[];
  ressourcesSauvegardees: RessourceSummary[];
  totalFavoris: number;
  totalExploitees: number;
  totalSauvegardees: number;
}

export interface StatMensuelle {
  annee: number;
  mois: number;
  ressourcesCrees: number;
  vues: number;
}

export interface StatistiquesResponse {
  totalRessources: number;
  ressourcesPubliees: number;
  ressourcesEnAttente: number;
  ressourcesSuspendues: number;
  ressourcesBrouillon: number;
  ressourcesParType: Record<string, number>;
  ressourcesParCategorie: Record<string, number>;
  totalVues: number;
  totalPartages: number;
  totalUtilisateurs: number;
  citoyensActifs: number;
  totalCommentaires: number;
  commentairesEnAttente: number;
  statsParMois: StatMensuelle[];
}

export interface RessourceRequest {
  titre: string;
  description: string;
  contenu: string;
  type: TypeRessource;
  visibilite: Visibilite;
  categorieId?: number;
  typesRelationsIds?: number[];
  urlExterne?: string;
  dureeEstimeeMin?: number;
}

export interface LoginRequest {
  email: string;
  motDePasse: string;
}

export interface RegisterRequest {
  nomComplet: string;
  email: string;
  motDePasse: string;
}

export interface CommentaireRequest {
  contenu: string;
  parentId?: number;
}

export interface ModerationRessourceRequest {
  statut: StatutRessource;
  motif?: string;
}

export interface ModerationCommentaireRequest {
  statut: StatutCommentaire;
  motif?: string;
}

export interface CreateUserRequest {
  nomComplet: string;
  email: string;
  motDePasse: string;
  role: Role;
}
