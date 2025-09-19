import React, { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';
import { Plus, Search, FileText, ExternalLink, Calendar, User } from 'lucide-react';
import toast from 'react-hot-toast';

const Papers = () => {
  const { user } = useAuth();
  const [papers, setPapers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [filters, setFilters] = useState({
    status: 'all',
    search: ''
  });

  const paperStatuses = [
    { value: 'draft', label: 'Draft', color: 'bg-gray-100 text-gray-800' },
    { value: 'submitted', label: 'Submitted', color: 'bg-yellow-100 text-yellow-800' },
    { value: 'under-review', label: 'Under Review', color: 'bg-orange-100 text-orange-800' },
    { value: 'published', label: 'Published', color: 'bg-green-100 text-green-800' },
    { value: 'rejected', label: 'Rejected', color: 'bg-red-100 text-red-800' }
  ];

  useEffect(() => {
    fetchPapers();
  }, [filters]);

  const fetchPapers = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (filters.status !== 'all') params.append('status', filters.status);
      if (filters.search) params.append('search', filters.search);

      const response = await axios.get(`/api/papers?${params}`);
      setPapers(response.data);
    } catch (error) {
      toast.error('Failed to fetch papers');
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusColor = (status) => {
    const statusObj = paperStatuses.find(s => s.value === status);
    return statusObj?.color || 'bg-gray-100 text-gray-800';
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Papers</h1>
          <p className="text-gray-600">Track your research publications</p>
        </div>
        <button
          onClick={() => setShowCreateModal(true)}
          className="btn-primary flex items-center"
        >
          <Plus className="w-4 h-4 mr-2" />
          New Paper
        </button>
      </div>

      {/* Filters */}
      <div className="card">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="relative">
            <Search className="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search papers..."
              className="form-input pl-10"
              value={filters.search}
              onChange={(e) => setFilters({...filters, search: e.target.value})}
            />
          </div>
          
          <select
            className="form-input"
            value={filters.status}
            onChange={(e) => setFilters({...filters, status: e.target.value})}
          >
            <option value="all">All Statuses</option>
            {paperStatuses.map(status => (
              <option key={status.value} value={status.value}>{status.label}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Papers List */}
      <div className="space-y-4">
        {papers.map(paper => (
          <div key={paper.id} className="card hover:shadow-md transition-shadow">
            <div className="flex justify-between items-start mb-4">
              <div className="flex-1">
                <h3 className="font-semibold text-lg mb-2">{paper.title}</h3>
                <div className="flex items-center gap-4 text-sm text-gray-600">
                  <div className="flex items-center">
                    <User className="w-4 h-4 mr-1" />
                    {JSON.parse(paper.authors || '[]').join(', ')}
                  </div>
                  <div className="flex items-center">
                    <FileText className="w-4 h-4 mr-1" />
                    {paper.journal}
                  </div>
                  {paper.publication_date && (
                    <div className="flex items-center">
                      <Calendar className="w-4 h-4 mr-1" />
                      {new Date(paper.publication_date).toLocaleDateString()}
                    </div>
                  )}
                </div>
              </div>
              <div className="flex items-center gap-3">
                <span className={`px-2 py-1 text-xs rounded-full ${getStatusColor(paper.status)}`}>
                  {paperStatuses.find(s => s.value === paper.status)?.label}
                </span>
                {paper.citations > 0 && (
                  <span className="text-sm font-medium text-blue-600">
                    {paper.citations} citations
                  </span>
                )}
              </div>
            </div>
            
            {paper.abstract && (
              <p className="text-gray-600 text-sm mb-3 line-clamp-3">{paper.abstract}</p>
            )}
            
            <div className="flex justify-between items-center">
              <div className="text-sm text-gray-500">
                {paper.project_title && (
                  <span>Project: {paper.project_title}</span>
                )}
              </div>
              <div className="flex space-x-2">
                {paper.doi && (
                  <a
                    href={`https://doi.org/${paper.doi}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="btn-secondary text-sm flex items-center"
                  >
                    <ExternalLink className="w-3 h-3 mr-1" />
                    DOI
                  </a>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>

      {papers.length === 0 && (
        <div className="text-center py-12">
          <div className="text-gray-400 mb-4">
            <FileText className="w-16 h-16 mx-auto" />
          </div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">No papers found</h3>
          <p className="text-gray-600 mb-4">Start tracking your research publications.</p>
          <button
            onClick={() => setShowCreateModal(true)}
            className="btn-primary"
          >
            Add Paper
          </button>
        </div>
      )}
    </div>
  );
};

export default Papers;
