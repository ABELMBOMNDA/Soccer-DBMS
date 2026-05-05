import { useEffect, useState } from 'react';
import { officialSquadsApi, clubsApi, lookupsApi } from '../api/api';
import { formatDate } from '../utils/dateFormat';

export default function OfficialSquads() {
  const [view, setView] = useState('squads');

  // Official Squad (live) state
  const [allClubs, setAllClubs] = useState([]);
  const [selectedClubId, setSelectedClubId] = useState('');
  const [playerSearch, setPlayerSearch] = useState('');
  const [liveSquad, setLiveSquad] = useState([]);
  const [liveMsg, setLiveMsg] = useState('');
  const [liveLoading, setLiveLoading] = useState(false);

  // Snapshot views state
  const [seasons, setSeasons] = useState([]);
  const [snapshotClubs, setSnapshotClubs] = useState([]);
  const [season, setSeason] = useState('');
  const [club, setClub] = useState('');
  const [data, setData] = useState([]);
  const [msg, setMsg] = useState('');
  const [loading, setLoading] = useState(false);
  const [snapshot, setSnapshot] = useState('');

  useEffect(() => {
    lookupsApi.getClubs()
      .then(r => setAllClubs(r.data || []))
      .catch(() => {});

    officialSquadsApi.getSeasons()
      .then(r => {
        const list = r.data || [];
        setSeasons(list);
        if (list.length > 0) setSeason(list[0]);
      })
      .catch(() => {});

    officialSquadsApi.getSnapshot()
      .then(r => setSnapshot(r.data.latest_snapshot || ''))
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (!season) return;
    officialSquadsApi.getClubs(season)
      .then(r => setSnapshotClubs(r.data || []))
      .catch(() => setSnapshotClubs([]));
    setClub('');
    setData([]);
  }, [season]);

  const loadLiveSquad = async () => {
    if (!selectedClubId) { setLiveMsg('Please select a club'); return; }
    setLiveLoading(true);
    setLiveMsg('');
    try {
      const r = await clubsApi.getSquad(selectedClubId);
      setLiveSquad(r.data || []);
      if ((r.data || []).length === 0) setLiveMsg('No players currently registered to this club');
    } catch (e) {
      setLiveMsg(e.response?.data?.error || 'Error loading squad');
    } finally {
      setLiveLoading(false);
    }
  };

  const loadSnapshotData = async () => {
    if (!season) { setMsg('Please select a season first'); return; }
    setLoading(true);
    setMsg('');
    try {
      let r;
      if (view === 'summary') {
        r = await officialSquadsApi.getSummary(season);
      } else {
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

  const filteredSquad = playerSearch.trim()
    ? liveSquad.filter(p => p.player_name.toLowerCase().includes(playerSearch.toLowerCase()))
    : liveSquad;

  const snapshotColumns = {
    summary: ['club_name', 'registered_senior_players', 'home_grown_players', 'non_home_grown_players'],
    homegrown: ['club_name', 'player_name'],
  };
  const snapshotHeaders = {
    summary: ['Club', 'Total Registered', 'Home Grown', 'Non Home Grown'],
    homegrown: ['Club', 'Player'],
  };

  return (
    <div>
      <div className="page-header">
        <h1>Official Squads</h1>
        <p>Live squad data and registered squad reports{snapshot ? ` — Latest snapshot: ${formatDate(snapshot)}` : ''}</p>
      </div>

      <div className="card">
        <div className="btn-row">
          <button className={`btn-${view === 'squads' ? 'primary' : 'outline'}`} onClick={() => { setView('squads'); setLiveMsg(''); }}>Official Squad</button>
          <button className={`btn-${view === 'summary' ? 'primary' : 'outline'}`} onClick={() => { setView('summary'); setData([]); setMsg(''); }}>Club Summary</button>
          <button className={`btn-${view === 'homegrown' ? 'primary' : 'outline'}`} onClick={() => { setView('homegrown'); setData([]); setMsg(''); }}>Home-Grown Report</button>
        </div>

        {view === 'squads' && (
          <div className="filter-bar" style={{ marginTop: 16 }}>
            <div className="form-group">
              <label>Club</label>
              <select value={selectedClubId} onChange={e => { setSelectedClubId(e.target.value); setLiveSquad([]); setLiveMsg(''); }}>
                <option value="">Select a club</option>
                {allClubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
              </select>
            </div>
            <div className="form-group">
              <label>Player Search</label>
              <input value={playerSearch} onChange={e => setPlayerSearch(e.target.value)} placeholder="Search by player name..." />
            </div>
            <div className="form-group" style={{ justifyContent: 'flex-end', display: 'flex', alignItems: 'flex-end', gap: 8 }}>
              <button className="btn-secondary" onClick={loadLiveSquad}>Load Squad</button>
              <button className="btn-outline" onClick={() => { setSelectedClubId(''); setPlayerSearch(''); setLiveSquad([]); setLiveMsg(''); }}>Clear</button>
            </div>
          </div>
        )}

        {(view === 'summary' || view === 'homegrown') && (
          <div className="filter-bar" style={{ marginTop: 16 }}>
            <div className="form-group">
              <label>Season</label>
              <select value={season} onChange={e => setSeason(e.target.value)}>
                <option value="">Select season</option>
                {seasons.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            {view === 'homegrown' && (
              <div className="form-group">
                <label>Club</label>
                <select value={club} onChange={e => setClub(e.target.value)}>
                  <option value="">All Clubs</option>
                  {snapshotClubs.map(c => <option key={c} value={c}>{c}</option>)}
                </select>
              </div>
            )}
            <div className="form-group" style={{ justifyContent: 'flex-end', display: 'flex', alignItems: 'flex-end', gap: 8 }}>
              <button className="btn-secondary" onClick={loadSnapshotData}>Load Data</button>
              <button className="btn-outline" onClick={() => { setClub(''); setData([]); setMsg(''); }}>Clear</button>
            </div>
          </div>
        )}
      </div>

      {/* Official Squad results (live) */}
      {view === 'squads' && (
        <>
          {liveMsg && <div className="alert" style={{ background: '#fff3cd', color: '#856404' }}>{liveMsg}</div>}
          {liveLoading && <div className="loading">Loading...</div>}
          {!liveLoading && filteredSquad.length > 0 && (
            <div className="card">
              <div style={{ marginBottom: 10, color: '#6c757d', fontSize: '0.85rem' }}>{filteredSquad.length} players</div>
              <div className="table-wrapper">
                <table>
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Player</th>
                      <th>Position</th>
                      <th>Nationality</th>
                      <th>Foot</th>
                      <th>Market Value</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredSquad.map(p => (
                      <tr key={p.player_id}>
                        <td>{p.squad_number ?? '—'}</td>
                        <td>{p.player_name}</td>
                        <td><span className="badge badge-gray">{p.position_code}</span></td>
                        <td>{p.nationality}</td>
                        <td>{p.preferred_foot}</td>
                        <td>{p.market_value != null ? `€${Number(p.market_value).toLocaleString()}` : '—'}</td>
                        <td><span className={`badge ${p.player_status === 'ACTIVE' ? 'badge-green' : 'badge-gray'}`}>{p.player_status}</span></td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </>
      )}

      {/* Snapshot views results */}
      {(view === 'summary' || view === 'homegrown') && (
        <>
          {msg && <div className="alert" style={{ background: msg.startsWith('No') ? '#fff3cd' : '#f8d7da', color: msg.startsWith('No') ? '#856404' : '#721c24' }}>{msg}</div>}
          {loading && <div className="loading">Loading...</div>}
          {!loading && data.length > 0 && (
            <div className="card">
              <div style={{ marginBottom: 10, color: '#6c757d', fontSize: '0.85rem' }}>{data.length} records</div>
              <div className="table-wrapper">
                <table>
                  <thead>
                    <tr>{snapshotHeaders[view].map(h => <th key={h}>{h}</th>)}</tr>
                  </thead>
                  <tbody>
                    {data.map((row, i) => (
                      <tr key={i}>
                        {snapshotColumns[view].map(col => (
                          <td key={col}>{row[col] ?? '—'}</td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}
