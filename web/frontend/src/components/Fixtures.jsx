import { useEffect, useState } from 'react';
import { fixturesApi, lookupsApi } from '../api/api';
import { formatDateTime, toInputDateTime, fromInputDateTime } from '../utils/dateFormat';

const LEAGUES = [
  'Premier League', 'Serie A', 'La Liga', 'Bundesliga', 'Ligue 1',
  'Liga Portugal', 'Eredivisie', 'Pro League', 'Süper Lig',
];

const empty = { fixture_id: '', season_id: '', competition: 'Premier League', matchweek: '', match_date: '', stadium_id: '', home_club_id: '', away_club_id: '', home_score: '', away_score: '', status: 'SCHEDULED', attendance: '' };

const statusColors = { SCHEDULED: 'badge-blue', COMPLETED: 'badge-green', POSTPONED: 'badge-yellow', CANCELLED: 'badge-red' };

export default function Fixtures() {
  const [fixtures, setFixtures] = useState([]);
  const [seasons, setSeasons] = useState([]);
  const [stadiums, setStadiums] = useState([]);
  const [clubs, setClubs] = useState([]);
  const [form, setForm] = useState(empty);
  const [selected, setSelected] = useState(null);
  const [msg, setMsg] = useState({ text: '', type: '' });
  const [loading, setLoading] = useState(false);

  const load = async () => {
    setLoading(true);
    try {
      const [f, s, st, c] = await Promise.all([fixturesApi.getAll(), lookupsApi.getSeasons(), lookupsApi.getStadiums(), lookupsApi.getClubs()]);
      setFixtures(f.data); setSeasons(s.data); setStadiums(st.data); setClubs(c.data);
    } catch (e) {
      notify(e.response?.data?.error || 'Failed to load data', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, []);

  const notify = (text, type = 'success') => {
    setMsg({ text, type });
    setTimeout(() => setMsg({ text: '', type: '' }), 3500);
  };

  const validate = () => {
    if (!form.season_id) return notify('Season is required', 'error');
    if (!form.matchweek) return notify('Matchweek is required (1-38)', 'error');
    if (!form.match_date) return notify('Match Date is required', 'error');
    if (!form.stadium_id) return notify('Stadium is required', 'error');
    if (!form.home_club_id) return notify('Home Club is required', 'error');
    if (!form.away_club_id) return notify('Away Club is required', 'error');
    if (String(form.home_club_id) === String(form.away_club_id)) return notify('Home and Away clubs must be different', 'error');
    return true;
  };

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }));

  const handleSelect = (f) => {
    setSelected(f.fixture_id);
    setForm({
      ...f,
      season_id: String(f.season_id),
      stadium_id: String(f.stadium_id),
      home_club_id: String(f.home_club_id),
      away_club_id: String(f.away_club_id),
      match_date: f.match_date ? toInputDateTime(f.match_date) : '',
      home_score: f.home_score != null ? String(f.home_score) : '',
      away_score: f.away_score != null ? String(f.away_score) : '',
      attendance: f.attendance != null ? String(f.attendance) : '',
      competition: f.competition || 'Premier League',
    });
  };

  const handleClear = () => { setSelected(null); setForm(empty); };

  const payload = () => ({
    ...form,
    match_date: fromInputDateTime(form.match_date),
    season_id: Number(form.season_id),
    matchweek: Number(form.matchweek),
    stadium_id: Number(form.stadium_id),
    home_club_id: Number(form.home_club_id),
    away_club_id: Number(form.away_club_id),
    home_score: form.home_score !== '' ? Number(form.home_score) : null,
    away_score: form.away_score !== '' ? Number(form.away_score) : null,
    attendance: form.attendance !== '' ? Number(form.attendance) : null,
    competition: form.competition || 'Premier League',
  });

  const handleAdd = async () => {
    if (!validate()) return;
    try {
      await fixturesApi.create(payload());
      notify('Fixture added'); handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error adding fixture', 'error'); }
  };

  const handleUpdate = async () => {
    if (!selected) return notify('Select a fixture to update', 'error');
    if (!validate()) return;
    try {
      await fixturesApi.update(selected, payload());
      notify('Fixture updated'); handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error updating fixture', 'error'); }
  };

  const handleDelete = async () => {
    if (!selected) return notify('Select a fixture to delete', 'error');
    if (!confirm('Delete this fixture?')) return;
    try {
      await fixturesApi.delete(selected);
      notify('Fixture deleted'); handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error deleting fixture', 'error'); }
  };

  return (
    <div>
      <div className="page-header"><h1>Fixtures</h1><p>Manage match fixtures</p></div>
      {msg.text && <div className={`alert alert-${msg.type}`}>{msg.text}</div>}

      <div className="card">
        <div className="form-grid">
          <div className="form-group"><label>ID</label><input readOnly value={form.fixture_id} /></div>
          <div className="form-group">
            <label>Season *</label>
            <select value={form.season_id} onChange={e => set('season_id', e.target.value)}>
              <option value="">Select season</option>
              {seasons.map(s => <option key={s.season_id} value={s.season_id}>{s.season_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>League / Competition *</label>
            <select value={form.competition} onChange={e => set('competition', e.target.value)}>
              {LEAGUES.map(l => <option key={l} value={l}>{l}</option>)}
            </select>
          </div>
          <div className="form-group"><label>Matchweek *</label><input type="number" min="1" max="38" value={form.matchweek} onChange={e => set('matchweek', e.target.value)} /></div>
          <div className="form-group"><label>Match Date * (DD-MM-YYYY HH:MM:SS)</label><input value={form.match_date} onChange={e => set('match_date', e.target.value)} placeholder="16-08-2025 15:00:00" /></div>
          <div className="form-group">
            <label>Stadium *</label>
            <select value={form.stadium_id} onChange={e => set('stadium_id', e.target.value)}>
              <option value="">Select stadium</option>
              {stadiums.map(s => <option key={s.stadium_id} value={s.stadium_id}>{s.stadium_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>Home Club *</label>
            <select value={form.home_club_id} onChange={e => set('home_club_id', e.target.value)}>
              <option value="">Select club</option>
              {clubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>Away Club *</label>
            <select value={form.away_club_id} onChange={e => set('away_club_id', e.target.value)}>
              <option value="">Select club</option>
              {clubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
            </select>
          </div>
          <div className="form-group"><label>Home Score</label><input type="number" min="0" value={form.home_score} onChange={e => set('home_score', e.target.value)} /></div>
          <div className="form-group"><label>Away Score</label><input type="number" min="0" value={form.away_score} onChange={e => set('away_score', e.target.value)} /></div>
          <div className="form-group">
            <label>Status *</label>
            <select value={form.status} onChange={e => set('status', e.target.value)}>
              <option>SCHEDULED</option><option>COMPLETED</option><option>POSTPONED</option><option>CANCELLED</option>
            </select>
          </div>
          <div className="form-group"><label>Attendance</label><input type="number" min="0" value={form.attendance} onChange={e => set('attendance', e.target.value)} /></div>
        </div>
        <div className="btn-row">
          <button className="btn-primary" onClick={handleAdd}>Add Fixture</button>
          <button className="btn-success" onClick={handleUpdate}>Update Fixture</button>
          <button className="btn-danger" onClick={handleDelete}>Delete Fixture</button>
          <button className="btn-outline" onClick={handleClear}>Clear Form</button>
          <button className="btn-secondary" onClick={load}>Reload</button>
        </div>
      </div>

      <div className="card">
        {loading ? <div className="loading">Loading...</div> : (
          <div className="table-wrapper">
            <table>
              <thead><tr>
                <th>ID</th><th>Season</th><th>League</th><th>GW</th><th>Date</th>
                <th>Home</th><th>Score</th><th>Away</th><th>Stadium</th><th>Status</th><th>Attendance</th>
              </tr></thead>
              <tbody>
                {fixtures.length === 0 && <tr><td colSpan={11} style={{ textAlign: 'center', color: '#6c757d' }}>No fixtures found</td></tr>}
                {fixtures.map(f => (
                  <tr key={f.fixture_id} className={selected === f.fixture_id ? 'selected' : ''} onClick={() => handleSelect(f)}>
                    <td>{f.fixture_id}</td><td>{f.season_name}</td>
                    <td style={{ fontSize: '0.78rem', color: '#6c757d' }}>{f.competition || 'Premier League'}</td>
                    <td>{f.matchweek}</td>
                    <td>{formatDateTime(f.match_date)}</td><td>{f.home_club}</td>
                    <td><strong>{f.score}</strong></td><td>{f.away_club}</td>
                    <td>{f.stadium_name}</td>
                    <td><span className={`badge ${statusColors[f.status] || 'badge-gray'}`}>{f.status}</span></td>
                    <td>{f.attendance ? Number(f.attendance).toLocaleString() : '—'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
