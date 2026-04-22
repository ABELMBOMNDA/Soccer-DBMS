import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { reportsApi, fixturesApi, transfersApi } from '../api/api';
import { formatDate } from '../utils/dateFormat';

const leagues = [
  { name: 'Premier League', country: '🏴󠁧󠁢󠁥󠁮󠁧󠁿 England' },
  { name: 'Serie A',        country: '🇮🇹 Italy'   },
  { name: 'La Liga',        country: '🇪🇸 Spain'   },
  { name: 'Bundesliga',     country: '🇩🇪 Germany' },
  { name: 'Ligue 1',        country: '🇫🇷 France'  },
  { name: 'Liga Portugal',  country: '🇵🇹 Portugal'},
  { name: 'Eredivisie',     country: '🇳🇱 Netherlands'},
  { name: 'Pro League',     country: '🇧🇪 Belgium' },
  { name: 'Süper Lig',      country: '🇹🇷 Turkey'  },
];

const quickLinks = [
  { label: 'Clubs',          icon: '🏟️', link: '/clubs',           desc: 'Manage all clubs',          color: '#e63946' },
  { label: 'Players',        icon: '⚽', link: '/players',         desc: 'Player records',            color: '#3a86ff' },
  { label: 'Fixtures',       icon: '📅', link: '/fixtures',        desc: 'Match schedule',            color: '#2d9d78' },
  { label: 'Transfers',      icon: '🔄', link: '/transfers',       desc: 'Transfer history',          color: '#8338ec' },
  { label: 'Official Squads',icon: '📋', link: '/official-squads', desc: 'Registered squads',         color: '#fb8500' },
  { label: 'Reports',        icon: '📈', link: '/reports',         desc: 'Standings & analytics',     color: '#d62828' },
];

export default function Dashboard() {
  const [stats, setStats]         = useState(null);
  const [standings, setStandings] = useState([]);
  const [scorers, setScorers]     = useState([]);
  const [recentFixtures, setRecentFixtures] = useState([]);
  const [recentTransfers, setRecentTransfers] = useState([]);
  const [error, setError]         = useState('');
  const [loading, setLoading]     = useState(false);
  const navigate = useNavigate();

  const load = async () => {
    setLoading(true);
    setError('');
    try {
      const [dashRes, fixtRes, tranRes] = await Promise.allSettled([
        reportsApi.getDashboard(),
        fixturesApi.getAll(),
        transfersApi.getAll(),
      ]);

      if (dashRes.status === 'fulfilled') setStats(dashRes.value.data);
      if (fixtRes.status === 'fulfilled') {
        const all = fixtRes.value.data || [];
        setRecentFixtures(all.filter(f => f.status === 'COMPLETED').slice(-5).reverse());
      }
      if (tranRes.status === 'fulfilled') {
        setRecentTransfers((tranRes.value.data || []).slice(0, 5));
      }

      try {
        const sRes = await reportsApi.getStandings(1);
        setStandings((sRes.data || []).slice(0, 8));
      } catch (_) {}
      try {
        const tRes = await reportsApi.getTopScorers(1);
        setScorers((tRes.data || []).slice(0, 5));
      } catch (_) {}
    } catch (e) {
      setError('Could not load dashboard. Check the backend is running.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, []);

  const statusColors = { SCHEDULED: '#3a86ff', COMPLETED: '#2d9d78', POSTPONED: '#fb8500', CANCELLED: '#e63946' };

  return (
    <div>
      {/* ── HERO ─────────────────────────────────────────── */}
      <div className="hero-banner" style={{ marginBottom: 20 }}>
        <div className="hero-text">
          <h2>Welcome to Soccer DBMS</h2>
          <p>Europe's top divisions — all in one place</p>
          <div style={{ display: 'flex', gap: 24, marginTop: 16, flexWrap: 'wrap' }}>
            {[
              { label: 'Clubs',    val: stats?.clubs },
              { label: 'Players',  val: stats?.players },
              { label: 'Fixtures', val: stats?.fixtures },
              { label: 'Transfers',val: stats?.transfers },
            ].map(s => (
              <div key={s.label} style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.7rem', fontWeight: 800, color: '#fff', lineHeight: 1 }}>
                  {loading ? '…' : (s.val ?? '—')}
                </div>
                <div style={{ fontSize: '0.72rem', color: 'rgba(255,255,255,0.6)', textTransform: 'uppercase', letterSpacing: '0.5px', marginTop: 3 }}>
                  {s.label}
                </div>
              </div>
            ))}
          </div>
        </div>
        <div className="hero-logo"><img src="/logo.png" alt="Soccer DBMS" /></div>
      </div>

      {error && <div className="alert alert-error">{error}</div>}

      {/* ── QUICK LINKS ───────────────────────────────────── */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(160px, 1fr))', gap: 14, marginBottom: 22 }}>
        {quickLinks.map(q => (
          <div key={q.label} onClick={() => navigate(q.link)}
            style={{ background: '#fff', borderRadius: 12, padding: '16px 18px', cursor: 'pointer',
              boxShadow: '0 2px 8px rgba(0,0,0,0.06)', borderTop: `3px solid ${q.color}`,
              transition: 'transform 0.15s, box-shadow 0.15s' }}
            onMouseEnter={e => { e.currentTarget.style.transform='translateY(-3px)'; e.currentTarget.style.boxShadow='0 8px 20px rgba(0,0,0,0.12)'; }}
            onMouseLeave={e => { e.currentTarget.style.transform=''; e.currentTarget.style.boxShadow='0 2px 8px rgba(0,0,0,0.06)'; }}
          >
            <div style={{ fontSize: '1.5rem', marginBottom: 6 }}>{q.icon}</div>
            <div style={{ fontWeight: 700, fontSize: '0.9rem', color: '#1a1a2e' }}>{q.label}</div>
            <div style={{ fontSize: '0.75rem', color: '#6c757d', marginTop: 2 }}>{q.desc}</div>
          </div>
        ))}
      </div>

      {/* ── MAIN GRID ─────────────────────────────────────── */}
      <div className="dash-grid" style={{ marginBottom: 20 }}>

        {/* League Standings */}
        <div className="card" style={{ marginBottom: 0 }}>
          <div className="card-title">League Standings — 2024/25</div>
          {standings.length === 0
            ? <p style={{ color: '#6c757d', fontSize: '0.85rem' }}>No standings data yet.</p>
            : (
            <div className="table-wrapper">
              <table>
                <thead><tr>
                  <th>Pos</th><th>Club</th><th>P</th><th>W</th><th>D</th><th>L</th><th>GF</th><th>GA</th><th>GD</th><th>Pts</th>
                </tr></thead>
                <tbody>
                  {standings.map((row, i) => (
                    <tr key={i} style={i < 4 ? { borderLeft: '3px solid #3a86ff' } : i > 17 ? { borderLeft: '3px solid #e63946' } : {}}>
                      <td><strong>{row.position_no ?? i + 1}</strong></td>
                      <td style={{ fontWeight: 500 }}>{row.club_name}</td>
                      <td>{row.played}</td><td>{row.wins}</td><td>{row.draws}</td><td>{row.losses}</td>
                      <td>{row.goals_for}</td><td>{row.goals_against}</td>
                      <td style={{ color: row.goal_difference >= 0 ? '#166534' : '#991b1b', fontWeight: 600 }}>
                        {row.goal_difference >= 0 ? '+' : ''}{row.goal_difference}
                      </td>
                      <td><strong style={{ color: '#e63946' }}>{row.points}</strong></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Right column */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>

          {/* Top Scorers */}
          <div className="card" style={{ marginBottom: 0 }}>
            <div className="card-title">Top Scorers</div>
            {scorers.length === 0
              ? <p style={{ color: '#6c757d', fontSize: '0.85rem' }}>No scorer data yet.</p>
              : (
              <ul className="mini-list">
                {scorers.map((s, i) => (
                  <li key={i}>
                    <span className="mini-rank">{i + 1}</span>
                    <span className="mini-name">{s.player_name}
                      <span style={{ display: 'block', fontSize: '0.73rem', color: '#6c757d' }}>{s.club_name}</span>
                    </span>
                    <span className="mini-val">{s.goals} ⚽</span>
                  </li>
                ))}
              </ul>
            )}
          </div>

          {/* Recent Transfers */}
          <div className="card" style={{ marginBottom: 0 }}>
            <div className="card-title">Recent Transfers</div>
            {recentTransfers.length === 0
              ? <p style={{ color: '#6c757d', fontSize: '0.85rem' }}>No transfers found.</p>
              : (
              <ul className="mini-list">
                {recentTransfers.map((t, i) => (
                  <li key={i} style={{ flexDirection: 'column', alignItems: 'flex-start', gap: 2 }}>
                    <div style={{ fontWeight: 600, fontSize: '0.85rem' }}>{t.player_name}</div>
                    <div style={{ fontSize: '0.75rem', color: '#6c757d' }}>
                      {t.from_club || 'Free Agent'} → {t.to_club}
                    </div>
                    <div style={{ fontSize: '0.73rem', color: '#e63946', fontWeight: 600 }}>
                      {t.transfer_fee ? `£${Number(t.transfer_fee).toLocaleString()}` : 'Free'} · {formatDate(t.transfer_date)}
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      </div>

      {/* ── RECENT RESULTS ────────────────────────────────── */}
      <div className="dash-grid">
        <div className="card" style={{ marginBottom: 0 }}>
          <div className="card-title">Recent Results</div>
          {recentFixtures.length === 0
            ? <p style={{ color: '#6c757d', fontSize: '0.85rem' }}>No completed fixtures yet.</p>
            : (
            <div className="table-wrapper">
              <table>
                <thead><tr><th>Date</th><th>Home</th><th>Score</th><th>Away</th><th>Stadium</th></tr></thead>
                <tbody>
                  {recentFixtures.map((f, i) => (
                    <tr key={i}>
                      <td>{formatDate(f.match_date)}</td>
                      <td style={{ fontWeight: 500 }}>{f.home_club}</td>
                      <td style={{ fontWeight: 800, color: '#1a1a2e', textAlign: 'center' }}>{f.score ?? '— : —'}</td>
                      <td style={{ fontWeight: 500 }}>{f.away_club}</td>
                      <td style={{ color: '#6c757d', fontSize: '0.8rem' }}>{f.stadium_name}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Leagues Covered */}
        <div className="card" style={{ marginBottom: 0 }}>
          <div className="card-title">Leagues Covered</div>
          <ul className="mini-list">
            {leagues.map((l, i) => (
              <li key={i}>
                <span className="mini-name" style={{ fontWeight: 500 }}>{l.name}</span>
                <span style={{ fontSize: '0.8rem', color: '#6c757d' }}>{l.country}</span>
              </li>
            ))}
          </ul>
        </div>
      </div>

      <div style={{ textAlign: 'right', marginTop: 12 }}>
        <button className="btn-outline" onClick={load} style={{ fontSize: '0.8rem' }}>↻ Refresh Dashboard</button>
      </div>
    </div>
  );
}
