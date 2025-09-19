import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Users, TrendingUp, FileText, Database, Settings, Award } from 'lucide-react';
import toast from 'react-hot-toast';

const AdminPanel = () => {
  const [stats, setStats] = useState(null);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview');

  const researcherLevels = [
    { value: 'student', label: 'Student', color: 'text-gray-600' },
    { value: 'bronze', label: 'Bronze', color: 'text-yellow-600' },
    { value: 'silver', label: 'Silver', color: 'text-gray-500' },
    { value: 'gold', label: 'Gold', color: 'text-yellow-500' },
    { value: 'platinum', label: 'Platinum', color: 'text-purple-600' },
    { value: 'diamond', label: 'Diamond', color: 'text-blue-600' }
  ];

  useEffect(() => {
    fetchAdminData();
  }, []);

  const fetchAdminData = async () => {
    try {
      setLoading(true);
      const [statsRes, usersRes] = await Promise.all([
        axios.get('/api/admin/stats'),
        axios.get('/api/admin/users')
      ]);
      
      setStats(statsRes.data);
      setUsers(usersRes.data);
    } catch (error) {
      toast.error('Failed to fetch admin data');
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateUser = async (userId, updates) => {
    try {
      await axios.put(`/api/admin/users/${userId}`, updates);
      toast.success('User updated successfully');
      fetchAdminData();
    } catch (error) {
      toast.error('Failed to update user');
      console.error(error);
    }
  };

  const handlePromoteUser = async (userId) => {
    try {
      const response = await axios.post(`/api/admin/users/${userId}/promote`);
      toast.success(`User promoted to ${response.data.newLevel} level`);
      fetchAdminData();
    } catch (error) {
      toast.error('Failed to promote user');
      console.error(error);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Admin Panel</h1>
        <p className="text-gray-600">Manage users and system settings</p>
      </div>

      {/* Tabs */}
      <div className="border-b border-gray-200">
        <nav className="-mb-px flex space-x-8">
          {[
            { id: 'overview', label: 'Overview', icon: TrendingUp },
            { id: 'users', label: 'Users', icon: Users },
            { id: 'settings', label: 'Settings', icon: Settings }
          ].map(tab => {
            const Icon = tab.icon;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`py-2 px-1 border-b-2 font-medium text-sm flex items-center ${
                  activeTab === tab.id
                    ? 'border-primary-500 text-primary-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700'
                }`}
              >
                <Icon className="w-4 h-4 mr-2" />
                {tab.label}
              </button>
            );
          })}
        </nav>
      </div>

      {/* Overview Tab */}
      {activeTab === 'overview' && stats && (
        <div className="space-y-6">
          {/* Statistics Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Total Users</p>
                  <p className="text-3xl font-bold text-gray-900">{stats.overview.totalUsers}</p>
                </div>
                <Users className="w-8 h-8 text-primary-600" />
              </div>
            </div>
            
            <div className="card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Active Users</p>
                  <p className="text-3xl font-bold text-gray-900">{stats.overview.activeUsers}</p>
                </div>
                <TrendingUp className="w-8 h-8 text-green-600" />
              </div>
            </div>
            
            <div className="card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Total Projects</p>
                  <p className="text-3xl font-bold text-gray-900">{stats.overview.totalProjects}</p>
                </div>
                <FileText className="w-8 h-8 text-purple-600" />
              </div>
            </div>
            
            <div className="card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Total Papers</p>
                  <p className="text-3xl font-bold text-gray-900">{stats.overview.totalPapers}</p>
                </div>
                <Database className="w-8 h-8 text-yellow-600" />
              </div>
            </div>
          </div>

          {/* Researcher Level Distribution */}
          <div className="card">
            <h3 className="text-lg font-semibold mb-4">Researcher Level Distribution</h3>
            <div className="space-y-3">
              {stats.levelDistribution.map(level => (
                <div key={level.researcher_level} className="flex items-center justify-between">
                  <div className="flex items-center">
                    <Award className={`w-5 h-5 mr-2 ${researcherLevels.find(l => l.value === level.researcher_level)?.color}`} />
                    <span className="font-medium capitalize">{level.researcher_level}</span>
                  </div>
                  <span className="text-gray-600">{level.count} users</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Users Tab */}
      {activeTab === 'users' && (
        <div className="space-y-6">
          <div className="card overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      User
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Role
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Level
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Stats
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {users.map(user => (
                    <tr key={user.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div>
                          <div className="text-sm font-medium text-gray-900">{user.name}</div>
                          <div className="text-sm text-gray-500">{user.email}</div>
                          <div className="text-xs text-gray-500">{user.institution}</div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <select
                          value={user.role}
                          onChange={(e) => handleUpdateUser(user.id, { ...user, role: e.target.value })}
                          className="text-sm border rounded px-2 py-1"
                        >
                          <option value="researcher">Researcher</option>
                          <option value="admin">Admin</option>
                        </select>
                      </td>
                      <td className="px-6 py-4">
                        <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium researcher-badge researcher-${user.researcher_level}`}>
                          {user.researcher_level}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-600">
                        <div>Projects: {user.projects_count}</div>
                        <div>Papers: {user.papers_count}</div>
                        <div>Citations: {user.citations_count}</div>
                      </td>
                      <td className="px-6 py-4">
                        <select
                          value={user.status}
                          onChange={(e) => handleUpdateUser(user.id, { ...user, status: e.target.value })}
                          className="text-sm border rounded px-2 py-1"
                        >
                          <option value="active">Active</option>
                          <option value="inactive">Inactive</option>
                          <option value="suspended">Suspended</option>
                        </select>
                      </td>
                      <td className="px-6 py-4">
                        <button
                          onClick={() => handlePromoteUser(user.id)}
                          className="text-sm text-primary-600 hover:text-primary-900"
                        >
                          Auto-promote
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Settings Tab */}
      {activeTab === 'settings' && (
        <div className="card">
          <h3 className="text-lg font-semibold mb-4">System Settings</h3>
          <p className="text-gray-600">Settings panel under development...</p>
        </div>
      )}
    </div>
  );
};

export default AdminPanel;
