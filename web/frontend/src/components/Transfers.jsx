import { useEffect, useState } from 'react';
import { transfersApi, lookupsApi } from '../api/api';
import { formatDate, toInputDate, fromInputDate } from '../utils/dateFormat';

const empty = { transfer_id: '', player_id: '', season_id: '', from_club_id: '', to_club_id: '', transfer_date: '', transfer_fee: '', transfer_type: 'PERMANENT', status: 'COMPLETED' };
const statusColors = { COMPLETED: 'badge-green', PENDING: 'badge-yellow', CANCELLED: 'badge-red' };

export default function Transfers() {
  const [transfers, setTransfers] = useState([]);
  const [players, setPlayers] = useState([]);
  const [seasons, setSeasons] = useState([]);
  const [clubs, setClubs] = useState([]);
  const [form, setForm] = useState(empty);
  const [selected, setSelected] = useState(null);
  const [msg, setMsg] = useState({ text: '', type: '' });
  const [loading, setLoading] = useState(false);

  const load = async () => {
    setLoading(true);
    try {
      const [t, p, s, c] = await Promise.all([transfersApi.getAll(), lookupsApi.getPlayers(), lookupsApi.getSeasons(), lookupsApi.getClubs()]);
      setTransfers(t.data); setPlayers(p.data); setSeasons(s.data); setClubs(c.data);
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
    if (!form.player_id) return notify('Player is required', 'error');
    if (!form.season_id) return notify('Season is required', 'error');
    if (!form.to_club_id) return notify('To Club is required', 'error');
    if (form.from_club_id && String(form.from_club_id) === String(form.to_club_id)) return notify('From and To clubs must be different', 'error');
    if (!form.transfer_date) return notify('Transfer Date is required (DD-MM-YYYY)', 'error');
    if (!/^\d{2}-\d{2}-\d{4}$/.test(form.transfer_date)) return notify('Transfer Date must be DD-MM-YYYY', 'error');
    if (form.transfer_fee === '' || form.transfer_fee === null) return notify('Transfer Fee is required', 'error');
    return true;
  };

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }));

  const handleSelect = (t) => {
    setSelected(t.transfer_id);
    setForm({
      ...t,
      player_id: String(t.player_id),
      season_id: String(t.season_id),
      from_club_id: t.from_club_id != null ? String(t.from_club_id) : '',
      to_club_id: String(t.to_club_id),
      transfer_date: t.transfer_date ? toInputDate(t.transfer_date.slice(0, 10)) : '',
    });
  };

  const handleClear = () => { setSelected(null); setForm(empty); };

  const payload = () => ({
    ...form,
    transfer_date: fromInputDate(form.transfer_date),
    player_id: Number(form.player_id),
    season_id: Number(form.season_id),
    from_club_id: form.from_club_id ? Number(form.from_club_id) : null,
    to_club_id: Number(form.to_club_id),
    transfer_fee: Number(form.transfer_fee),
  });

  const handleAdd = async () => {
    if (!validate()) return;
    try {
      await transfersApi.create(payload());
      notify('Transfer added'); handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error adding transfer', 'error'); }
  };

  const handleUpdate = async () => {
    if (!selected) return notify('Select a transfer to update', 'error');
    if (!validate()) return;
    try {
      await transfersApi.update(selected, payload());
      notify('Transfer updated'); handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error updating transfer', 'error'); }
  };

  const handleDelete = async () => {
    if (!selected) return notify('Select a transfer to delete', 'error');
    if (!confirm('Delete this transfer?')) return;
    try {
      await transfersApi.delete(selected);
      notify('Transfer deleted'); handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error deleting transfer', 'error'); }
  };

  return (
    <div>
      <div className="page-header"><h1>Transfers</h1><p>Manage player transfers</p></div>
      {msg.text && <div className={`alert alert-${msg.type}`}>{msg.text}</div>}

      <div className="card">
        <div className="form-grid">
          <div className="form-group"><label>ID</label><input readOnly value={form.transfer_id} /></div>
          <div className="form-group">
            <label>Player *</label>
            <select value={form.player_id} onChange={e => set('player_id', e.target.value)}>
              <option value="">Select player</option>
              {players.map(p => <option key={p.player_id} value={p.player_id}>{p.player_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>Season *</label>
            <select value={form.season_id} onChange={e => set('season_id', e.target.value)}>
              <option value="">Select season</option>
              {seasons.map(s => <option key={s.season_id} value={s.season_id}>{s.season_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>From Club</label>
            <select value={form.from_club_id} onChange={e => set('from_club_id', e.target.value)}>
              <option value="">Free Agent / None</option>
              {clubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>To Club *</label>
            <select value={form.to_club_id} onChange={e => set('to_club_id', e.target.value)}>
              <option value="">Select club</option>
              {clubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
            </select>
          </div>
          <div className="form-group"><label>Transfer Date * (DD-MM-YYYY)</label><input value={form.transfer_date} onChange={e => set('transfer_date', e.target.value)} placeholder="01-07-2025" /></div>
          <div className="form-group"><label>Transfer Fee (£) *</label><input type="number" min="0" step="0.01" value={form.transfer_fee} onChange={e => set('transfer_fee', e.target.value)} /></div>
          <div className="form-group">
            <label>Transfer Type *</label>
            <select value={form.transfer_type} onChange={e => set('transfer_type', e.target.value)}>
              <option>PERMANENT</option><option>LOAN</option><option>FREE_AGENT</option>
            </select>
          </div>
          <div className="form-group">
            <label>Status *</label>
            <select value={form.status} onChange={e => set('status', e.target.value)}>
              <option>COMPLETED</option><option>PENDING</option><option>CANCELLED</option>
            </select>
          </div>
        </div>
        <div className="btn-row">
          <button className="btn-primary" onClick={handleAdd}>Add Transfer</button>
          <button className="btn-success" onClick={handleUpdate}>Update Transfer</button>
          <button className="btn-danger" onClick={handleDelete}>Delete Transfer</button>
          <button className="btn-outline" onClick={handleClear}>Clear Form</button>
          <button className="btn-secondary" onClick={load}>Reload</button>
        </div>
      </div>

      <div className="card">
        {loading ? <div className="loading">Loading...</div> : (
          <div className="table-wrapper">
            <table>
              <thead><tr>
                <th>ID</th><th>Player</th><th>Season</th><th>From</th><th>To</th>
                <th>Date</th><th>Fee (£)</th><th>Type</th><th>Status</th>
              </tr></thead>
              <tbody>
                {transfers.length === 0 && <tr><td colSpan={9} style={{ textAlign: 'center', color: '#6c757d' }}>No transfers found</td></tr>}
                {transfers.map(t => (
                  <tr key={t.transfer_id} className={selected === t.transfer_id ? 'selected' : ''} onClick={() => handleSelect(t)}>
                    <td>{t.transfer_id}</td><td>{t.player_name}</td><td>{t.season_name}</td>
                    <td>{t.from_club}</td><td>{t.to_club}</td>
                    <td>{formatDate(t.transfer_date)}</td>
                    <td>{t.transfer_fee != null ? Number(t.transfer_fee).toLocaleString() : '—'}</td>
                    <td>{t.transfer_type}</td>
                    <td><span className={`badge ${statusColors[t.status] || 'badge-gray'}`}>{t.status}</span></td>
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
