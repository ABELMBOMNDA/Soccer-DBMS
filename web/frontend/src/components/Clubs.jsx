import { useEffect, useState } from 'react';
import { clubsApi, lookupsApi } from '../api/api';

const empty = { club_id: '', club_name: '', short_name: '', founded_year: '', manager_name: '', sponsor_name: '', stadium_id: '' };

export default function Clubs() {
  const [clubs, setClubs] = useState([]);
  const [stadiums, setStadiums] = useState([]);
  const [form, setForm] = useState(empty);
  const [selected, setSelected] = useState(null);
  const [msg, setMsg] = useState({ text: '', type: '' });
  const [loading, setLoading] = useState(false);

  const load = async () => {
    setLoading(true);
    try {
      const [c, s] = await Promise.all([clubsApi.getAll(), lookupsApi.getStadiums()]);
      setClubs(c.data);
      setStadiums(s.data);
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
    if (!form.club_name.trim()) return notify('Club Name is required', 'error');
    if (!form.short_name.trim()) return notify('Short Name is required', 'error');
    if (!form.founded_year) return notify('Founded Year is required', 'error');
    if (!form.manager_name.trim()) return notify('Manager Name is required', 'error');
    if (!form.stadium_id) return notify('Home Stadium is required', 'error');
    return true;
  };

  const handleSelect = (club) => {
    setSelected(club.club_id);
    setForm({ ...club, sponsor_name: club.sponsor_name ?? '', stadium_id: String(club.stadium_id) });
  };

  const handleClear = () => { setSelected(null); setForm(empty); };

  const handleAdd = async () => {
    if (!validate()) return;
    try {
      await clubsApi.create({ ...form, founded_year: Number(form.founded_year), stadium_id: Number(form.stadium_id) });
      notify('Club added successfully');
      handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error adding club', 'error'); }
  };

  const handleUpdate = async () => {
    if (!selected) return notify('Select a club to update', 'error');
    if (!validate()) return;
    try {
      await clubsApi.update(selected, { ...form, founded_year: Number(form.founded_year), stadium_id: Number(form.stadium_id) });
      notify('Club updated successfully');
      handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error updating club', 'error'); }
  };

  const handleDelete = async () => {
    if (!selected) return notify('Select a club to delete', 'error');
    if (!confirm('Delete this club?')) return;
    try {
      await clubsApi.delete(selected);
      notify('Club deleted');
      handleClear(); load();
    } catch (e) { notify(e.response?.data?.error || 'Error deleting club', 'error'); }
  };

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }));

  return (
    <div>
      <div className="page-header"><h1>Clubs</h1><p>Manage clubs across European leagues</p></div>
      {msg.text && <div className={`alert alert-${msg.type}`}>{msg.text}</div>}

      <div className="card">
        <div className="form-grid">
          <div className="form-group"><label>ID</label><input readOnly value={form.club_id} /></div>
          <div className="form-group"><label>Club Name *</label><input value={form.club_name} onChange={e => set('club_name', e.target.value)} /></div>
          <div className="form-group"><label>Short Name *</label><input value={form.short_name} onChange={e => set('short_name', e.target.value)} /></div>
          <div className="form-group"><label>Founded Year *</label><input type="number" value={form.founded_year} onChange={e => set('founded_year', e.target.value)} /></div>
          <div className="form-group"><label>Manager *</label><input value={form.manager_name} onChange={e => set('manager_name', e.target.value)} /></div>
          <div className="form-group"><label>Sponsor</label><input value={form.sponsor_name} onChange={e => set('sponsor_name', e.target.value)} /></div>
          <div className="form-group">
            <label>Home Stadium *</label>
            <select value={form.stadium_id} onChange={e => set('stadium_id', e.target.value)}>
              <option value="">Select stadium</option>
              {stadiums.map(s => <option key={s.stadium_id} value={s.stadium_id}>{s.stadium_name}</option>)}
            </select>
          </div>
        </div>
        <div className="btn-row">
          <button className="btn-primary" onClick={handleAdd}>Add Club</button>
          <button className="btn-success" onClick={handleUpdate}>Update Club</button>
          <button className="btn-danger" onClick={handleDelete}>Delete Club</button>
          <button className="btn-outline" onClick={handleClear}>Clear Form</button>
          <button className="btn-secondary" onClick={load}>Reload</button>
        </div>
      </div>

      <div className="card">
        {loading ? <div className="loading">Loading...</div> : (
          <div className="table-wrapper">
            <table>
              <thead><tr>
                <th>ID</th><th>Club Name</th><th>Short</th><th>Founded</th>
                <th>Manager</th><th>Sponsor</th><th>Stadium</th>
              </tr></thead>
              <tbody>
                {clubs.length === 0 && <tr><td colSpan={7} style={{ textAlign: 'center', color: '#6c757d' }}>No clubs found</td></tr>}
                {clubs.map(c => (
                  <tr key={c.club_id} className={selected === c.club_id ? 'selected' : ''} onClick={() => handleSelect(c)}>
                    <td>{c.club_id}</td><td>{c.club_name}</td><td>{c.short_name}</td>
                    <td>{c.founded_year}</td><td>{c.manager_name}</td>
                    <td>{c.sponsor_name ?? '—'}</td><td>{c.stadium_name}</td>
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
