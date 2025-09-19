import React, { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { User, Mail, Building, Book, Award, Calendar } from 'lucide-react';
import toast from 'react-hot-toast';

const Profile = () => {
  const { user, fetchUser } = useAuth();
  const [editing, setEditing] = useState(false);
  const [formData, setFormData] = useState({
    name: user?.name || '',
    institution: user?.institution || '',
    research_field: user?.research_field || ''
  });

  const researchFields = [
    { value: 'ai_emotion_modeling', label: 'AI Emotion Modeling & Hijacking' },
    { value: 'neuroscience_ai_inhibition', label: 'Neuroscience-Inspired AI Inhibition' },
    { value: 'ai_memory_consolidation', label: 'AI Memory & Consolidation' },
    { value: 'ai_learning_plasticity', label: 'AI Learning & Plasticity Dynamics' },
    { value: 'ai_sequence_modeling', label: 'AI Sequence Modeling & Advanced Structures' },
    { value: 'other', label: 'Other' }
  ];

  const researcherLevels = {
    student: { name: 'Student Researcher', description: 'Starting your research journey' },
    bronze: { name: 'Bronze Researcher', description: '3+ projects, 1+ paper' },
    silver: { name: 'Silver Researcher', description: '5+ projects, 3+ papers, 10+ citations' },
    gold: { name: 'Gold Researcher', description: '10+ projects, 5+ papers, 50+ citations' },
    platinum: { name: 'Platinum Researcher', description: '20+ projects, 10+ papers, 100+ citations' },
    diamond: { name: 'Diamond Researcher', description: '50+ projects, 25+ papers, 500+ citations' }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // Implementation would update user profile
      toast.success('Profile updated successfully');
      setEditing(false);
      await fetchUser();
    } catch (error) {
      toast.error('Failed to update profile');
      console.error(error);
    }
  };

  const levelInfo = researcherLevels[user?.researcher_level] || researcherLevels.student;

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Profile</h1>
        <p className="text-gray-600">Manage your account settings and research profile</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Profile Card */}
        <div className="lg:col-span-1">
          <div className="card text-center">
            <div className="w-24 h-24 bg-primary-600 rounded-full flex items-center justify-center mx-auto mb-4">
              <User className="w-12 h-12 text-white" />
            </div>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">{user?.name}</h2>
            <p className="text-gray-600 mb-4">{user?.email}</p>
            
            <div className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium researcher-badge researcher-${user?.researcher_level}`}>
              <Award className="w-4 h-4 mr-1" />
              {levelInfo.name}
            </div>
            
            <p className="text-xs text-gray-500 mt-2">{levelInfo.description}</p>
            
            <div className="mt-4 pt-4 border-t border-gray-200">
              <div className="flex items-center text-sm text-gray-600 mb-1">
                <Calendar className="w-4 h-4 mr-2" />
                Member since {new Date(user?.created_at).toLocaleDateString()}
              </div>
            </div>
          </div>

          {/* Research Statistics */}
          <div className="card mt-6">
            <h3 className="text-lg font-semibold mb-4">Research Statistics</h3>
            <div className="space-y-3">
              <div className="flex justify-between">
                <span className="text-gray-600">Projects</span>
                <span className="font-medium">{user?.projects_count || 0}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Papers</span>
                <span className="font-medium">{user?.papers_count || 0}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Citations</span>
                <span className="font-medium">{user?.citations_count || 0}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Profile Form */}
        <div className="lg:col-span-2">
          <div className="card">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-lg font-semibold">Profile Information</h3>
              {!editing && (
                <button
                  onClick={() => setEditing(true)}
                  className="btn-primary"
                >
                  Edit Profile
                </button>
              )}
            </div>

            <form onSubmit={handleSubmit}>
              <div className="space-y-4">
                <div>
                  <label className="form-label">Full Name</label>
                  <div className="relative">
                    <User className="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input
                      type="text"
                      className="form-input pl-10"
                      value={formData.name}
                      onChange={(e) => setFormData({...formData, name: e.target.value})}
                      disabled={!editing}
                    />
                  </div>
                </div>

                <div>
                  <label className="form-label">Email Address</label>
                  <div className="relative">
                    <Mail className="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input
                      type="email"
                      className="form-input pl-10 bg-gray-50"
                      value={user?.email}
                      disabled
                    />
                  </div>
                  <p className="text-xs text-gray-500 mt-1">Email cannot be changed</p>
                </div>

                <div>
                  <label className="form-label">Institution</label>
                  <div className="relative">
                    <Building className="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input
                      type="text"
                      className="form-input pl-10"
                      value={formData.institution}
                      onChange={(e) => setFormData({...formData, institution: e.target.value})}
                      disabled={!editing}
                    />
                  </div>
                </div>

                <div>
                  <label className="form-label">Research Field</label>
                  <div className="relative">
                    <Book className="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <select
                      className="form-input pl-10"
                      value={formData.research_field}
                      onChange={(e) => setFormData({...formData, research_field: e.target.value})}
                      disabled={!editing}
                    >
                      {researchFields.map(field => (
                        <option key={field.value} value={field.value}>{field.label}</option>
                      ))}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="form-label">Role</label>
                  <input
                    type="text"
                    className="form-input bg-gray-50"
                    value={user?.role?.charAt(0).toUpperCase() + user?.role?.slice(1)}
                    disabled
                  />
                </div>

                <div>
                  <label className="form-label">Account Status</label>
                  <input
                    type="text"
                    className="form-input bg-gray-50"
                    value={user?.status?.charAt(0).toUpperCase() + user?.status?.slice(1)}
                    disabled
                  />
                </div>
              </div>

              {editing && (
                <div className="flex justify-end space-x-3 mt-6 pt-4 border-t border-gray-200">
                  <button
                    type="button"
                    onClick={() => setEditing(false)}
                    className="btn-secondary"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="btn-primary"
                  >
                    Save Changes
                  </button>
                </div>
              )}
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Profile;
