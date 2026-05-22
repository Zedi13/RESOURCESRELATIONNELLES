import type { StatutRessource, TypeRessource, Visibilite, Role } from '../../types';

const TYPE_LABELS: Record<TypeRessource, string> = {
  ARTICLE: 'Article', GUIDE: 'Guide', VIDEO: 'Vidéo',
  PODCAST: 'Podcast', ACTIVITE: 'Activité', JEU: 'Jeu',
  ATELIER: 'Atelier', AUTRE: 'Autre',
};

const STATUT_LABELS: Record<StatutRessource, string> = {
  BROUILLON: 'Brouillon', EN_ATTENTE: 'En attente',
  PUBLIE: 'Publié', SUSPENDU: 'Suspendu', ARCHIVE: 'Archivé',
};

const VISIBILITE_LABELS: Record<Visibilite, string> = {
  PUBLIQUE: 'Publique', PRIVEE: 'Privée', PARTAGEE: 'Partagée',
};

const ROLE_LABELS: Record<Role, string> = {
  CITOYEN: 'Citoyen', MODERATEUR: 'Modérateur',
  ADMIN: 'Administrateur', SUPER_ADMIN: 'Super-Admin',
};

interface BadgeProps {
  type?: TypeRessource;
  statut?: StatutRessource;
  visibilite?: Visibilite;
  role?: Role;
  label?: string;
  variant?: 'default' | 'success' | 'warning' | 'danger' | 'info';
}

function getVariant(props: BadgeProps): string {
  if (props.statut) {
    const map: Record<StatutRessource, string> = {
      PUBLIE: 'success', BROUILLON: 'default', EN_ATTENTE: 'warning',
      SUSPENDU: 'danger', ARCHIVE: 'default',
    };
    return map[props.statut];
  }
  if (props.visibilite) {
    const map: Record<Visibilite, string> = {
      PUBLIQUE: 'info', PRIVEE: 'default', PARTAGEE: 'warning',
    };
    return map[props.visibilite];
  }
  if (props.role) {
    const map: Record<Role, string> = {
      SUPER_ADMIN: 'danger', ADMIN: 'warning', MODERATEUR: 'info', CITOYEN: 'default',
    };
    return map[props.role];
  }
  return props.variant ?? 'default';
}

function getLabel(props: BadgeProps): string {
  if (props.type) return TYPE_LABELS[props.type];
  if (props.statut) return STATUT_LABELS[props.statut];
  if (props.visibilite) return VISIBILITE_LABELS[props.visibilite];
  if (props.role) return ROLE_LABELS[props.role];
  return props.label ?? '';
}

export default function Badge(props: BadgeProps) {
  return (
    <span className={`badge badge-${getVariant(props)}`}>
      {getLabel(props)}
    </span>
  );
}

export { TYPE_LABELS, STATUT_LABELS, VISIBILITE_LABELS, ROLE_LABELS };
