import { useEffect, useState } from 'react';
import { officialSquadsApi } from '../api/api';
import { formatDate } from '../utils/dateFormat';

export default function OfficialSquads() {
  const [seasons, setSeasons] = useState([]);
  const [clubs, setClubs] = useState([]);
  const [season, setSeason] = useState('');
  const [club, setClub] = useState('');
  const [search, setSearch] = useState('');
  const [view, setView] = useState('squads');
  const [data, setData] = useState([]);
  const [snapshot, setSnapshot] = useState('');
  const [msg, setMsg] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    officialSquadsApi.getSeasons()
      .then(r => {
        const list = r.data || [];
        setSeasons(list);
        if (list.length > 0) setSeason(list[0]);
      })
      .catch(() => setMsg('Failed to load seasons'));

    officialSquadsApi.getSnapshot()
      .then(r => setSnapshot(r.data.latest_snapshot || ''))
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (!season) return;
    officialSquadsApi.getClubs(season)
      .then(r => setClubs(r.data || []))
      .catch(() => setClubs([]));
    setClub('');
    setData([]);
  }, [season]);

  const load = async () => {
    if (!season) { setMsg('Please select a season first'); return; }
    setLoading(true);
    setMsg('');
    try {
      let r;
      if (view === 'squads') {
        const params = { season };
        if (club) params.club = club;
        if (search) params.search = search;
        r = await officialSquadsApi.getSquads(params);
      } else if (view === 'summary') {
        r = await officialSquadsApi.getSummary(season);
      } else {
        const params = { season };
        if (club) params.club = club;
        r = await officialSquadsApi.getHomeGrown(season, club || undefined);
      }
      setData(r.data || []);
      if ((r.data || []).length === 0) setMsg('No records found for the selected filters');
    } catch (e) {
      setMsg(e.response?.data?.error || 'Error loading data');
    } finally {
      setLoading(false);
    }
  };

  const columns = {
    squads: ['season_name', 'source_snapshot_date', 'club_name', 'player_name', 'home_grown', 'squad_scope'],
    summary: ['club_name', 'registered_senior_players', 'home_grown_players', 'non_home_grown_players'],
    homegrown: ['club_name', 'player_name'],
  };

  const headers = {
    squads: ['Season', 'Snapshot Date', 'Club', 'Player', 'Home Grown', 'Squad Scope'],
    summary: ['Club', 'Total Registered', 'Home Grown', 'Non Home Grown'],
    homegrown: ['Club', 'Player'],
  };

  return (
    <div>
      <div className="page-header">
        <h1>Official Squads</h1>
        <p>Official registered squads{snapshot ? ` — Latest snapshot: ${formatDate(snapshot)}` : ''}</p>
      </div>

      {msg && <div className={`alert ${data.length === 0 && msg.startsWith('No') ? 'alert-success' : 'alert-error'}`} style={{ background: msg.startsWith('No') ? '#fff3cd' : undefined, color: msg.startsWith('No') ? '#856404' : undefined }}>{msg}</div>}

      <div className="card">
        <div className="filter-bar">
          <div className="form-group">
            <label>Season</label>
            <select value={season} onChange={e => setSeason(e.target.value)}>
              <option value="">Select season</option>
              {seasons.map(s => <option key={s} value={s}>{s}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>Club</label>
            <select value={club} onChange={e => setClub(e.target.value)}>
              <option value="">All Clubs</option>
              {clubs.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>
          {view === 'squads' && (
            <div className="form-group">
              <label>Player Search</label>
              <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search player name..." />
            </div>
          )}
        </div>
        <div className="btn-row">
          <button className={`btn-${view === 'squads' ? 'primary' : 'outline'}`} onClick={() => { setView('squads'); setData([]); }}>Official Squad</button>
          <button className={`btn-${view === 'summary' ? 'primary' : 'outline'}`} onClick={() => { setView('summary'); setData([]); }}>Club Summary</button>
          <button className={`btn-${view === 'homegrown' ? 'primary' : 'outline'}`} onClick={() => { setView('homegrown'); setData([]); }}>Home-Grown Report</button>
          <button className="btn-secondary" onClick={load}>Load Data</button>
          <button className="btn-outline" onClick={() => { setSearch(''); setClub(''); setData([]); setMsg(''); }}>Clear</button>
        </div>
      </div>

      {loading && <div className="loading">Loading...</div>}

      {!loading && data.length > 0 && (
        <div className="card">
          <div style={{ marginBottom: 10, color: '#6c757d', fontSize: '0.85rem' }}>{data.length} records</div>
          <div className="table-wrapper">
            <table>
              <thead>
                <tr>{headers[view].map(h => <th key={h}>{h}</th>)}</tr>
              </thead>
              <tbody>
                {data.map((row, i) => (
                  <tr key={i}>
                    {columns[view].map(col => (
                      <td key={col}>
                        {col === 'home_grown'
                          ? <span className={`badge ${row[col] === 'Yes' ? 'badge-green' : 'badge-gray'}`}>{row[col]}</span>
                          : col === 'source_snapshot_date'
                          ? formatDate(row[col])
                          : row[col] ?? '—'}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
