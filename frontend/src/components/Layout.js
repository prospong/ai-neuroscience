import React, { useState } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { 
  Brain, Menu, X, User, Bell, Search, LogOut,
  TrendingUp, FileText, BookOpen, Database, 
  Users, BarChart3, Settings, Shield
} from 'lucide-react';

const Layout = ({ children }) => {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const navItems = [
    { to: '/dashboard', label: 'Dashboard', icon: TrendingUp },
    { to: '/projects', label: 'Projects', icon: FileText },
    { to: '/papers', label: 'Papers', icon: BookOpen },
    { to: '/experiments', label: 'Experiments', icon: Database },
    { to: '/collaboration', label: 'Collaboration', icon: Users },
    { to: '/analytics', label: 'Analytics', icon: BarChart3 },
  ];

  if (user?.role === 'admin') {
    navItems.push({ to: '/admin', label: 'Admin Panel', icon: Shield });
  }

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const getResearcherBadge = (level) => {
    const badges = {
      student: 'researcher-student',
      bronze: 'researcher-bronze',
      silver: 'researcher-silver',
      gold: 'researcher-gold',
      platinum: 'researcher-platinum',
      diamond: 'researcher-diamond'
    };
    return badges[level] || 'researcher-student';
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top Navigation */}
      <header className="bg-white shadow-sm border-b sticky top-0 z-40">
        <div className="flex items-center justify-between px-6 py-4">
          <div className="flex items-center">
            <button 
              onClick={() => setIsSidebarOpen(!isSidebarOpen)}
              className="lg:hidden mr-4 p-2 hover:bg-gray-100 rounded-lg"
            >
              {isSidebarOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
            <div className="flex items-center">
              <Brain className="w-8 h-8 text-primary-600 mr-3" />
              <h1 className="text-xl font-bold text-gray-900">AI Neuroscience Research</h1>
            </div>
          </div>
          
          <div className="flex items-center space-x-4">
            <div className="relative hidden md:block">
              <Search className="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
              <input 
                type="text" 
                placeholder="Search..." 
                className="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 w-64"
              />
            </div>
            <button className="relative p-2 hover:bg-gray-100 rounded-lg">
              <Bell className="w-5 h-5" />
              <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
            </button>
            <div className="flex items-center space-x-3">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">{user?.name}</p>
                <p className={`text-xs px-2 py-1 rounded-full researcher-badge ${getResearcherBadge(user?.researcher_level)}`}>
                  {user?.researcher_level?.charAt(0).toUpperCase() + user?.researcher_level?.slice(1)} Researcher
                </p>
              </div>
              <button 
                onClick={() => navigate('/profile')}
                className="flex items-center space-x-2 p-2 hover:bg-gray-100 rounded-lg"
              >
                <User className="w-5 h-5" />
              </button>
              <button 
                onClick={handleLogout}
                className="p-2 hover:bg-gray-100 rounded-lg text-red-600"
              >
                <LogOut className="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* Sidebar */}
        <aside className={`${isSidebarOpen ? 'translate-x-0' : '-translate-x-full'} fixed lg:relative lg:translate-x-0 z-30 w-64 bg-white shadow-sm h-screen transition-transform duration-300 ease-in-out`}>
          <nav className="p-6">
            <ul className="space-y-2">
              {navItems.map(item => {
                const Icon = item.icon;
                return (
                  <li key={item.to}>
                    <NavLink
                      to={item.to}
                      className={({ isActive }) =>
                        `w-full flex items-center px-3 py-2 rounded-lg text-left transition-colors ${
                          isActive 
                            ? 'bg-primary-50 text-primary-700 border-r-2 border-primary-700' 
                            : 'text-gray-700 hover:bg-gray-50'
                        }`
                      }
                    >
                      <Icon className="w-5 h-5 mr-3" />
                      {item.label}
                    </NavLink>
                  </li>
                );
              })}
            </ul>
          </nav>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-6 lg:ml-0 overflow-auto">
          {children}
        </main>
      </div>

      {/* Mobile overlay */}
      {isSidebarOpen && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 z-20 lg:hidden"
          onClick={() => setIsSidebarOpen(false)}
        />
      )}
    </div>
  );
};

export default Layout;
