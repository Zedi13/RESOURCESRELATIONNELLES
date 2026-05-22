interface Props { label?: string; }

export default function LoadingSpinner({ label = 'Chargement…' }: Props) {
  return (
    <div className="spinner-wrap" role="status" aria-live="polite">
      <div className="spinner" aria-hidden="true" />
      <span className="sr-only">{label}</span>
    </div>
  );
}
