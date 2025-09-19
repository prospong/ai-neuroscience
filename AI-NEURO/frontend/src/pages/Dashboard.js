import React, { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';
import { FileText, BookOpen, Database, Star, Clock, TrendingUp, Users } from 'lucide-react';

const Dashboard = () => {
  const { user } = useAuth();
  const [stats, setStats] = useState({
    activeProjects: 0,
    publishedPapers: 0,
    runningExperiments: 0,
    totalCitations: 0
  });
  const [recentProjects, setRecentProjects] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      const [statsRes, projectsRes] = await Promise.all([
        axios.get('/api/dashboard/stats'),
        axios.get('/api/projects?limit=5')
      ]);
      
      setStats(statsRes.data);
      setRecentProjects(projectsRes.data);
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const getResearcherLevelInfo = (level) => {
    const levels = {
      student: { name: 'Student Researcher', color: 'text-gray-600', requirements: 'Complete 1 project' },
      bronze: { name: 'Bronze Researcher', color: 'text-yellow-600', requirements: '3 projects, 1 paper' },
      silver: { name: 'Silver Researcher', color: 'text-gray-500', requirements: '5 projects, 3 papers, 10 citations' },
      gold: { name: 'Gold Researcher', color: 'text-yellow-500', requirements: '10 projects, 5 papers, 50 citations' },
      platinum: { name: 'Platinum Researcher', color: 'text-purple-600', requirements: '20 projects, 10 papers, 100 citations' },
      diamond: { name: 'Diamond Researcher', color: 'text-blue-600', requirements: '50 projects, 25 papers, 500 citations' }
    };
    return levels[level] || levels.student;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  const levelInfo = getResearcherLevelInfo(user?.researcher_level);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Welcome back, {user?.name}!</h1>
          <p className="text-gray-600 mt-1">
            <span className={`font-medium ${levelInfo.color}`}>{levelInfo.name}</span>
            {' • '}
            <span className="text-sm">{user?.institution}</span>
          </p>
        </div>
        <div className="text-right">
          <p className="text-sm text-gray-500">Last login</p>
          <p className="font-medium">{new Date().toLocaleDateString()}</p>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="card">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Active Projects</p>
              <p className="text-3xl font-bold text-gray-900">{stats.activeProjects}</p>
            </div>
            <FileText className="w-8 h-8 text-primary-600" />
          </div>
        </div>
        
        <div className="card">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Published Papers</p>
              <p className="text-3xl font-bold text-gray-900">{stats.publishedPapers}</p>
            </div>
            <BookOpen className="w-8 h-8 text-green-600" />
          </div>
        </div>
        
        <div className="card">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Running Experiments</p>
              <p className="text-3xl font-bold text-gray-900">{stats.runningExperiments}</p>
            </div>
            <Database className="w-8 h-8 text-purple-600" />
          </div>
        </div>
        
        <div className="card">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Total Citations</p>
              <p className="text-3xl font-bold text-gray-900">{stats.totalCitations}</p>
            </div>
            <Star className="w-8 h-8 text-yellow-600" />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Projects */}
        <div className="card">
          <h3 className="text-lg font-semibold mb-4 flex items-center">
            <Clock className="w-5 h-5 mr-2" />
            Recent Projects
          </h3>
          <div className="space-y-3">
            {recentProjects.map((project) => (
              <div key={project.id} className="flex items-center justify-between p-3 bg-gray-50 rounded">
                <div className="flex-1">
                  <p className="font-medium text-sm">{project.title}</p>
                  <p className="text-xs text-gray-600">{project.module}</p>
                  <div className="mt-2">
                    <div className="flex justify-between text-xs mb-1">
                      <span>Progress</span>
                      <span>{project.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="bg-primary-600 h-2 rounded-full"
                        style={{ width: `${project.progress}%` }}
                      />
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Research Progress */}
        <div className="card">
          <h3 className="text-lg font-semibold mb-4 flex items-center">
            <TrendingUp className="w-5 h-5 mr-2" />
            Research Module Progress
          </h3>
          <div className="space-y-4">
            {[
              { name: 'AI Emotion Modeling & Hijacking', progress: 60 },
              { name: 'Neuroscience-Inspired AI Inhibition', progress: 40 },
              { name: 'AI Memory & Consolidation', progress: 20 },
              { name: 'AI Learning & Plasticity Dynamics', progress: 10 },
            ].map((module, index) => (
              <div key={index}>
                <div className="flex justify-between text-sm mb-1">
                  <span className="text-gray-700">{module.name}</span>
                  <span className="text-gray-500">{module.progress}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-primary-500 to-purple-600 h-2 rounded-full"
                    style={{ width: `${module.progress}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Researcher Level Progress */}
      <div className="card">
        <h3 className="text-lg font-semibold mb-4">Researcher Level Progress</h3>
        <div className="flex items-center justify-between">
          <div>
            <p className={`text-lg font-medium ${levelInfo.color}`}>{levelInfo.name}</p>
            <p className="text-sm text-gray-600">Next level requirements: {levelInfo.requirements}</p>
          </div>
          <div className="text-right">
            <p className="text-sm text-gray-600">Member since</p>
            <p className="font-medium">{new Date(user?.created_at).toLocaleDateString()}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
