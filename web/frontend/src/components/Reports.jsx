import { useEffect, useState } from 'react';
import { reportsApi, lookupsApi } from '../api/api';
import { formatDate } from '../utils/dateFormat';

export default function Reports() {
  const [seasons, setSeasons] = useState([]);
  const [clubs, setClubs] = useState([]);
  const [seasonId, setSeasonId] = useState('');
  const [clubId, setClubId] = useState('');
  const [matchweek, setMatchweek] = useState('1');
  const [data, setData] = useState([]);
  const [columns, setColumns] = useState([]);
  const [headers, setHeaders] = useState([]);
  const [title, setTitle] = useState('');
  const [msg, setMsg] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    Promise.all([lookupsApi.getSeasons(), lookupsApi.getClubs()])
      .then(([s, c]) => {
        const sData = s.data || [];
        const cData = c.data || [];
        setSeasons(sData);
        setClubs(cData);
        if (sData.length) setSeasonId(String(sData[0].season_id));
        if (cData.length) setClubId(String(cData[0].club_id));
      })
      .catch(() => setMsg('Failed to load filter data. Make sure the backend is running.'));
  }, []);

  const run = async (fn, t, cols, hdrs) => {
    setLoading(true);
    setMsg('');
    setData([]);
    try {
      const { data: result } = await fn();
      if (!result || result.length === 0) {
        setMsg('No data found for the selected filters');
        setData([]);
      } else {
        setData(result);
        setColumns(cols);
        setHeaders(hdrs);
        setTitle(t);
      }
    } catch (e) {
      const errMsg = e.response?.data?.error || e.message || 'Error running report. Check that the backend is running.';
      setMsg(errMsg);
    } finally {
      setLoading(false);
    }
  };

  const standings = () => {
    if (!seasonId) return setMsg('Please select a season');
    run(
      () => reportsApi.getStandings(seasonId),
      'League Standings',
      ['position_no', 'club_name', 'played', 'wins', 'draws', 'losses', 'goals_for', 'goals_against', 'goal_difference', 'points'],
      ['Pos', 'Club', 'P', 'W', 'D', 'L', 'GF', 'GA', 'GD', 'Pts']
    );
  };

  const topScorers = () => {
    if (!seasonId) return setMsg('Please select a season');
    run(
      () => reportsApi.getTopScorers(seasonId),
      'Top Scorers',
      ['player_name', 'club_name', 'goals'],
      ['Player', 'Club', 'Goals']
    );
  };

  const fixturesByMatchweek = () => {
    if (!seasonId) return setMsg('Please select a season');
    if (!matchweek || matchweek < 1 || matchweek > 38) return setMsg('Matchweek must be between 1 and 38');
    run(
      () => reportsApi.getFixturesByMatchweek(seasonId, matchweek),
      `Gameweek ${matchweek} Fixtures`,
      ['match_date', 'home_club', 'score', 'away_club', 'stadium_name', 'status'],
      ['Date', 'Home', 'Score', 'Away', 'Stadium', 'Status']
    );
  };

  const transfersByClub = () => {
    if (!clubId) return setMsg('Please select a club');
    run(
      () => reportsApi.getTransfersByClub(clubId),
      'Club Transfer History',
      ['player_name', 'from_club', 'to_club', 'transfer_date', 'transfer_fee', 'transfer_type', 'status'],
      ['Player', 'From', 'To', 'Date', 'Fee (£)', 'Type', 'Status']
    );
  };

  const statusColors = { SCHEDULED: 'badge-blue', COMPLETED: 'badge-green', POSTPONED: 'badge-yellow', CANCELLED: 'badge-red' };

  return (
    <div>
      <div className="page-header"><h1>Reports</h1><p>Analytics and reporting</p></div>
      {msg && <div className="alert alert-error">{msg}</div>}

      <div className="card">
        <div className="filter-bar">
          <div className="form-group">
            <label>Season</label>
            <select value={seasonId} onChange={e => setSeasonId(e.target.value)}>
              <option value="">Select season</option>
              {seasons.map(s => <option key={s.season_id} value={s.season_id}>{s.season_name}</option>)}
            </select>
          </div>
          <div className="form-group">
            <label>Matchweek (1-38)</label>
            <input type="number" min="1" max="38" value={matchweek} onChange={e => setMatchweek(e.target.value)} style={{ width: 80 }} />
          </div>
          <div className="form-group">
            <label>Club</label>
            <select value={clubId} onChange={e => setClubId(e.target.value)}>
              <option value="">Select club</option>
              {clubs.map(c => <option key={c.club_id} value={c.club_id}>{c.club_name}</option>)}
            </select>
          </div>
        </div>
        <div className="btn-row">
          <button className="btn-primary" onClick={standings}>Standings</button>
          <button className="btn-primary" onClick={topScorers}>Top Scorers</button>
          <button className="btn-primary" onClick={fixturesByMatchweek}>Fixtures by Matchweek</button>
          <button className="btn-primary" onClick={transfersByClub}>Transfers by Club</button>
        </div>
      </div>

      {loading && <div className="loading">Loading report...</div>}

      {!loading && data.length > 0 && (
        <div className="card">
          <h3 style={{ marginBottom: 12 }}>{title}</h3>
          <div style={{ marginBottom: 10, color: '#6c757d', fontSize: '0.85rem' }}>{data.length} records</div>
          <div className="table-wrapper">
            <table>
              <thead><tr>{headers.map(h => <th key={h}>{h}</th>)}</tr></thead>
              <tbody>
                {data.map((row, i) => (
                  <tr key={i}>
                    {columns.map(col => (
                      <td key={col}>
                        {col === 'status'
                          ? <span className={`badge ${statusColors[row[col]] || 'badge-gray'}`}>{row[col]}</span>
                          : col === 'transfer_fee' && row[col] != null
                          ? `£${Number(row[col]).toLocaleString()}`
                          : (col === 'transfer_date' || col === 'match_date') && row[col]
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
