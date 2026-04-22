import { Routes, Route, NavLink, useLocation } from 'react-router-dom';
import Dashboard from './components/Dashboard';
import Clubs from './components/Clubs';
import Players from './components/Players';
import Fixtures from './components/Fixtures';
import Transfers from './components/Transfers';
import OfficialSquads from './components/OfficialSquads';
import Reports from './components/Reports';

const navItems = [
  { to: '/', label: 'Dashboard',      icon: '📊' },
  { to: '/clubs', label: 'Clubs',     icon: '🏟️' },
  { to: '/players', label: 'Players', icon: '⚽' },
  { to: '/fixtures', label: 'Fixtures', icon: '📅' },
  { to: '/transfers', label: 'Transfers', icon: '🔄' },
  { to: '/official-squads', label: 'Official Squads', icon: '📋' },
  { to: '/reports', label: 'Reports', icon: '📈' },
];

function Topbar() {
  const location = useLocation();
  const current = navItems.find(n => n.to === location.pathname) || navItems[0];
  return (
    <div className="topbar">
      <div className="topbar-title">{current.icon} {current.label}</div>
      <div className="topbar-right">
        <span className="topbar-badge">Soccer DBMS</span>
        <span style={{ fontSize: '0.8rem', color: '#6c757d' }}>
          {new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })}
        </span>
      </div>
    </div>
  );
}

export default function App() {
  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="sidebar-logo">
          <img src="/logo.png" alt="Soccer DBMS" />
        </div>
        <nav>
          {navItems.map(item => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              className={({ isActive }) => `nav-link${isActive ? ' active' : ''}`}
            >
              <span>{item.icon}</span> {item.label}
            </NavLink>
          ))}
        </nav>
        <div className="sidebar-footer">
          Soccer Database<br />Management System
        </div>
      </aside>

      <main className="main-content">
        <Topbar />
        <div className="page-body">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/clubs" element={<Clubs />} />
            <Route path="/players" element={<Players />} />
            <Route path="/fixtures" element={<Fixtures />} />
            <Route path="/transfers" element={<Transfers />} />
            <Route path="/official-squads" element={<OfficialSquads />} />
            <Route path="/reports" element={<Reports />} />
          </Routes>
        </div>
      </main>
    </div>
  );
}
