import { useEffect, useState } from 'react';
import { playersApi, lookupsApi } from '../api/api';
import { formatDate, toInputDate, fromInputDate } from '../utils/dateFormat';

const empty = { player_id: '', first_name: '', last_name: '', date_of_birth: '', nationality: '', position_id: '', squad_number: '', preferred_foot: 'Right', current_club_id: '', market_value: '', player_status: 'ACTIVE' };

export default function Players() {
  const [players, setPlayers] = useState([]);
  const [positions, setPositions] = useState([]);
  const [clubs, setClubs] = useState([]);
  const [form, setForm] = useState(empty);
  const [selected, setSelected] = useState(null);
  const [msg, setMsg] = useState({ text: '', type: '' });
  const [loading, setLoading] = useState(false);

  const load = async () => {
    setLoading(true);
    try {
      const [p, pos, c] = await Promise.all([playersApi.getAll(), lookupsApi.getPositions(), lookupsApi.getClubs()]);
      setPlayers(p.data); setPositions(pos.data); setClubs(c.data);
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
    if (!form.first_name.trim()) return notify('First Name is required', 'error');
    if (!form.last_name.trim()) return notify('Last Name is required', 'error');
    if (!form.date_of_birth) return notify('Date of Birth is required (DD-MM-YYYY)', 'error');
    if (!/^\d{2}-\d{2}-\d{4}$/.test(form.date_of_birth)) return notify('Date of Birth must be DD-MM-YYYY', 'error');
    if (!form.nationality.trim()) return notify('Nationality is required', 'error');
    if (!form.position_id) return notify('Position is required', 'error');
    if (!form.market_value && form.market_value !== 0) return notify('Market Value is required', 'error');
    return true;
  };

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }));

  const handleSelect = (p) => {
    setSelected(p.player_id);
    const status = p.player_status || 'ACTIVE';
    setForm({
      ...p,
      current_club_id: p.current_club_id != null
        ? String(p.current_club_id)
        : (status === 'RETIRED' ? 'RETIRED' : ''),
      squad_number: p.squad_number != null ? String(p.squad_number) : '',
      position_id: String(p.position_id),
      date_of_birth: p.date_of_birth ? toInputDate(p.date_of_birth.slice(0, 10)) : '',
      player_status: status,
    });
  };

  const handleClear = () => { setSelected(null); setForm(empty); };

  const payload = () => {
    const isRetired = form.current_club_id === 'RETIRED';
    return {
      ...form,
      date_of_birth: fromInputDate(form.date_of_birth),
      position_id: Number(form.position_id),
      current_club_id: (isRetired || !form.current_club_id) ? null : Number(form.current_club_id),
      squad_number: form.squad_number ? Number(form.squad_number) : null,
      market_value: Number(form.market_value),
      player_status: isRetired ? 'RETIRED' : 'ACTIVE',
    };
  };

  const handleAdd = async () => {
    if (!validate()) return;
    try {
      await playersApi.create(payload());
      notify('Player added successfully');
      handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error adding player', 'error'); }
  };

  const handleUpdate = async () => {
    if (!selected) return notify('Select a player to update', 'error');
    if (!validate()) return;
    try {
      await playersApi.update(selected, payload());
      notify('Player updated');
      handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error updating player', 'error'); }
  };

  const handleDelete = async () => {
    if (!selected) return notify('Select a player to delete', 'error');
    if (!confirm('Delete this player?')) return;
    try {
      await playersApi.delete(selected);
      notify('Player deleted');
      handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error deleting player', 'error'); }
  };

  return (
    <div>
      <div className="page-header"><h1>Players</h1><p>Manage player records</p></div>
      {msg.text && <div className={`alert alert-${msg.type}`}>{msg.text}</div>}

      <div className="card">
        <div className="form-grid">
          <div className="form-group"><label>ID</label><input readOnly value={form.player_id} /></div>
          <div className="form-group"><label>First Name *</label><input value={form.first_name} onChange={e => set('first_name', e.target.value)} /></div>
          <div className="form-group"><label>Last Name *</label><input value={form.last_name} onChange={e => set('last_name', e.target.value)} /></div>
          <div className="form-group"><label>Date of Birth * (DD-MM-YYYY)</label><input value={form.date_of_birth} onChange={e => set('date_of_birth', e.target.value)} placeholder="15-01-1990" /></div>
          <div className="form-group"><label>Nationality *</label><input value={form.nationality} onChange={e => set('nationality', e.target.value)} /></div>
          <div className="form-group">
            <label>Position *</label>
            <select value={form.position_id} onChange={e => set('position_id', e.target.value)}>
              <option value="">Select position</option>
              {positions.map(p => <option key={p.position_id} value={p.position_id}>{p.label}</option>)}
            </select>
          </div>
          <div className="form-group"><label>Squad Number</label><input type="number" min="1" max="99" value={form.squad_number} onChange={e => set('squad_number', e.target.value)} /></div>
          <div className="form-group">
            <label>Preferred Foot *</label>
            <select value={form.preferred_foot} onChange={e => set('preferred_foot', e.target.value)}>
              <option>Right</option><option>Left</option><option>Both</option>
            </select>
          </div>
          <div className="form-group">
            <label>Current Club</label>
            <select value={form.current_club_id} onChange={e => set('current_club_id', e.target.value)}>
              <option value="">Free Agent / None</option>
              <option value="RETIRED">Retired</option>
              {clubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
            </select>
          </div>
          <div className="form-group"><label>Market Value (£) *</label><input type="number" min="0" step="0.01" value={form.market_value} onChange={e => set('market_value', e.target.value)} /></div>
        </div>
        <div className="btn-row">
          <button className="btn-primary" onClick={handleAdd}>Add Player</button>
          <button className="btn-success" onClick={handleUpdate}>Update Player</button>
          <button className="btn-danger" onClick={handleDelete}>Delete Player</button>
          <button className="btn-outline" onClick={handleClear}>Clear Form</button>
          <button className="btn-secondary" onClick={load}>Reload</button>
        </div>
      </div>

      <div className="card">
        {loading ? <div className="loading">Loading...</div> : (
          <div className="table-wrapper">
            <table>
              <thead><tr>
                <th>ID</th><th>Name</th><th>DOB</th><th>Nationality</th>
                <th>Pos</th><th>#</th><th>Foot</th><th>Club</th><th>Value (£)</th>
              </tr></thead>
              <tbody>
                {players.length === 0 && <tr><td colSpan={9} style={{ textAlign: 'center', color: '#6c757d' }}>No players found</td></tr>}
                {players.map(p => (
                  <tr key={p.player_id} className={selected === p.player_id ? 'selected' : ''} onClick={() => handleSelect(p)}>
                    <td>{p.player_id}</td><td>{p.player_name}</td><td>{formatDate(p.date_of_birth)}</td>
                    <td>{p.nationality}</td><td>{p.position_code}</td><td>{p.squad_number ?? '—'}</td>
                    <td>{p.preferred_foot}</td><td>{p.club_name ?? (p.player_status === 'RETIRED' ? '— Retired' : 'Free Agent')}</td>
                    <td>{p.market_value != null ? Number(p.market_value).toLocaleString() : '—'}</td>
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
