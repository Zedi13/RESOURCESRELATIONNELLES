interface Props {
  page: number;
  totalPages: number;
  onChange: (page: number) => void;
}

export default function Pagination({ page, totalPages, onChange }: Props) {
  if (totalPages <= 1) return null;
  const pages = Array.from({ length: totalPages }, (_, i) => i);

  return (
    <nav aria-label="Pagination" className="pagination">
      <button
        className="page-btn"
        onClick={() => onChange(page - 1)}
        disabled={page === 0}
        aria-label="Page précédente"
      >‹</button>

      {pages.map((p) => (
        <button
          key={p}
          className={`page-btn${p === page ? ' active' : ''}`}
          onClick={() => onChange(p)}
          aria-label={`Page ${p + 1}`}
          aria-current={p === page ? 'page' : undefined}
        >
          {p + 1}
        </button>
      ))}

      <button
        className="page-btn"
        onClick={() => onChange(page + 1)}
        disabled={page === totalPages - 1}
        aria-label="Page suivante"
      >›</button>
    </nav>
  );
}
