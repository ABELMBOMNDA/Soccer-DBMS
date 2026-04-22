/**
 * Format a date string as DD-MM-YYYY
 * Works with: "2026-02-05", "2026-02-05T15:00:00Z", "2026-02-05 15:00:00"
 */
export function formatDate(value) {
  if (!value) return '—';
  const str = String(value).trim();
  // Extract YYYY-MM-DD from start of string
  const match = str.match(/^(\d{4})-(\d{2})-(\d{2})/);
  if (!match) return str;
  return `${match[3]}-${match[2]}-${match[1]}`;
}

/**
 * Format a datetime string as DD-MM-YYYY HH:MM
 */
export function formatDateTime(value) {
  if (!value) return '—';
  const str = String(value).trim();
  // Extract YYYY-MM-DD and HH:MM
  const match = str.match(/^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})/);
  if (!match) return str;
  return `${match[3]}-${match[2]}-${match[1]} ${match[4]}:${match[5]}`;
}

/** Convert YYYY-MM-DD → DD-MM-YYYY for form inputs */
export function toInputDate(value) {
  if (!value) return '';
  const match = String(value).match(/^(\d{4})-(\d{2})-(\d{2})/);
  if (!match) return value;
  return `${match[3]}-${match[2]}-${match[1]}`;
}

/** Convert DD-MM-YYYY → YYYY-MM-DD for backend storage */
export function fromInputDate(value) {
  if (!value) return '';
  const match = String(value).match(/^(\d{2})-(\d{2})-(\d{4})/);
  if (!match) return value;
  return `${match[3]}-${match[2]}-${match[1]}`;
}

/** Convert YYYY-MM-DD HH:MM:SS → DD-MM-YYYY HH:MM:SS for form inputs */
export function toInputDateTime(value) {
  if (!value) return '';
  const match = String(value).match(/^(\d{4})-(\d{2})-(\d{2})([T ](\d{2}:\d{2}(:\d{2})?))?/);
  if (!match) return value;
  const time = match[5] ? ` ${match[5]}` : '';
  return `${match[3]}-${match[2]}-${match[1]}${time}`;
}

/** Convert DD-MM-YYYY HH:MM:SS → YYYY-MM-DD HH:MM:SS for backend storage */
export function fromInputDateTime(value) {
  if (!value) return '';
  const match = String(value).match(/^(\d{2})-(\d{2})-(\d{4})([T ](\d{2}:\d{2}(:\d{2})?))?/);
  if (!match) return value;
  const time = match[5] ? ` ${match[5]}` : '';
  return `${match[3]}-${match[2]}-${match[1]}${time}`;
}
