import axios from 'axios';

// In dev, Vite proxies /api → localhost:3002. In production, use the Railway backend URL.
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL ? `${import.meta.env.VITE_API_URL}/api` : '/api',
});

export const clubsApi = {
  getAll: () => api.get('/clubs'),
  getById: (id) => api.get(`/clubs/${id}`),
  getSquad: (id) => api.get(`/clubs/${id}/squad`),
  create: (data) => api.post('/clubs', data),
  update: (id, data) => api.put(`/clubs/${id}`, data),
  delete: (id) => api.delete(`/clubs/${id}`),
};

export const playersApi = {
  getAll: () => api.get('/players'),
  getById: (id) => api.get(`/players/${id}`),
  create: (data) => api.post('/players', data),
  update: (id, data) => api.put(`/players/${id}`, data),
  delete: (id) => api.delete(`/players/${id}`),
};

export const fixturesApi = {
  getAll: () => api.get('/fixtures'),
  getById: (id) => api.get(`/fixtures/${id}`),
  create: (data) => api.post('/fixtures', data),
  update: (id, data) => api.put(`/fixtures/${id}`, data),
  delete: (id) => api.delete(`/fixtures/${id}`),
};

export const transfersApi = {
  getAll: () => api.get('/transfers'),
  getById: (id) => api.get(`/transfers/${id}`),
  create: (data) => api.post('/transfers', data),
  update: (id, data) => api.put(`/transfers/${id}`, data),
  delete: (id) => api.delete(`/transfers/${id}`),
};

export const officialSquadsApi = {
  getSeasons: () => api.get('/official-squads/seasons'),
  getClubs: (season) => api.get('/official-squads/clubs', { params: { season } }),
  getSquads: (params) => api.get('/official-squads', { params }),
  getSummary: (season) => api.get('/official-squads/summary', { params: { season } }),
  getHomeGrown: (season, club) => api.get('/official-squads/home-grown', { params: { season, club } }),
  getSnapshot: () => api.get('/official-squads/snapshot'),
};

export const reportsApi = {
  getStandings: (season_id) => api.get('/reports/standings', { params: { season_id } }),
  getTopScorers: (season_id) => api.get('/reports/top-scorers', { params: { season_id } }),
  getFixturesByMatchweek: (season_id, matchweek) => api.get('/reports/fixtures-by-matchweek', { params: { season_id, matchweek } }),
  getTransfersByClub: (club_id) => api.get('/reports/transfers-by-club', { params: { club_id } }),
  getDashboard: () => api.get('/reports/dashboard'),
};

export const lookupsApi = {
  getClubs: () => api.get('/lookups/clubs'),
  getSeasons: () => api.get('/lookups/seasons'),
  getStadiums: () => api.get('/lookups/stadiums'),
  getPositions: () => api.get('/lookups/positions'),
  getPlayers: () => api.get('/lookups/players'),
};
