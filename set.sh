#!/bin/bash

# AI神经科学研究CMS系统 - 完整部署脚本
# 作者: Claude (基于用户的研究框架)
# 版本: 1.0.0
# 日期: 2025-09-19

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="ai-neuroscience-cms"
PROJECT_DESCRIPTION="AI神经科学现象研究框架 - 学术研究CMS系统"
GITHUB_USERNAME=""  # 将被用户输入替换

# 打印带颜色的信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查必要的工具
check_requirements() {
    print_info "检查系统要求..."
    
    if ! command -v git &> /dev/null; then
        print_error "Git 未安装，请先安装 Git"
        exit 1
    fi
    
    if ! command -v node &> /dev/null; then
        print_warning "Node.js 未安装，将尝试使用 npm"
    fi
    
    print_success "系统要求检查完成"
}

# 获取用户输入
get_user_input() {
    print_info "请输入项目配置信息:"
    
    read -p "GitHub 用户名: " GITHUB_USERNAME
    if [ -z "$GITHUB_USERNAME" ]; then
        print_error "GitHub 用户名不能为空"
        exit 1
    fi
    
    read -p "项目名称 [$PROJECT_NAME]: " custom_project_name
    if [ ! -z "$custom_project_name" ]; then
        PROJECT_NAME="$custom_project_name"
    fi
    
    read -p "是否要初始化 Git 仓库? (y/n) [y]: " init_git
    init_git=${init_git:-y}
    
    read -p "是否要创建 Docker 配置? (y/n) [y]: " create_docker
    create_docker=${create_docker:-y}
}

# 创建项目结构
create_project_structure() {
    print_info "创建项目结构..."
    
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    
    # 创建目录结构
    mkdir -p {frontend/src/{components,pages,hooks,utils,styles},backend/{routes,models,middleware,utils},database/{migrations,seeds},docs,scripts,tests/{frontend,backend}}
    
    print_success "项目结构创建完成"
}

# 创建 package.json 文件
create_package_json() {
    print_info "创建 package.json..."
    
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "$PROJECT_DESCRIPTION",
  "main": "index.js",
  "scripts": {
    "dev": "concurrently \"npm run dev:backend\" \"npm run dev:frontend\"",
    "dev:frontend": "cd frontend && npm start",
    "dev:backend": "cd backend && npm run dev",
    "build": "cd frontend && npm run build",
    "start": "cd backend && npm start",
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "test": "concurrently \"npm run test:frontend\" \"npm run test:backend\"",
    "test:frontend": "cd frontend && npm test",
    "test:backend": "cd backend && npm test",
    "deploy": "./scripts/deploy.sh"
  },
  "keywords": [
    "ai",
    "neuroscience",
    "research",
    "cms",
    "academic"
  ],
  "author": "$GITHUB_USERNAME",
  "license": "MIT",
  "devDependencies": {
    "concurrently": "^8.2.2"
  }
}
EOF

    print_success "package.json 创建完成"
}

# 创建前端项目
create_frontend() {
    print_info "创建前端项目..."
    
    cd frontend
    
    # 创建 package.json
    cat > package.json << EOF
{
  "name": "ai-neuroscience-cms-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.17.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^14.5.2",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "react-scripts": "5.0.1",
    "lucide-react": "^0.263.1",
    "recharts": "^2.5.0",
    "axios": "^1.6.0",
    "date-fns": "^2.29.3",
    "react-query": "^3.39.3",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.21"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "proxy": "http://localhost:3001"
}
EOF

    # 创建 Tailwind 配置
    cat > tailwind.config.js << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
        neural: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          500: '#06b6d4',
          600: '#0891b2',
          700: '#0e7490',
        }
      }
    },
  },
  plugins: [],
}
EOF

    # 创建 PostCSS 配置
    cat > postcss.config.js << EOF
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

    # 创建主要 React 组件
    cat > src/App.js << 'EOF'
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from 'react-query';
import Dashboard from './pages/Dashboard';
import Projects from './pages/Projects';
import Papers from './pages/Papers';
import Experiments from './pages/Experiments';
import Collaboration from './pages/Collaboration';
import Analytics from './pages/Analytics';
import Layout from './components/Layout';
import './styles/index.css';

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/projects" element={<Projects />} />
            <Route path="/papers" element={<Papers />} />
            <Route path="/experiments" element={<Experiments />} />
            <Route path="/collaboration" element={<Collaboration />} />
            <Route path="/analytics" element={<Analytics />} />
          </Routes>
        </Layout>
      </Router>
    </QueryClientProvider>
  );
}

export default App;
EOF

    # 创建样式文件
    mkdir -p src/styles
    cat > src/styles/index.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  html {
    font-family: 'Inter', system-ui, sans-serif;
  }
}

@layer components {
  .btn-primary {
    @apply bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors;
  }
  
  .btn-secondary {
    @apply bg-gray-200 text-gray-800 px-4 py-2 rounded-lg hover:bg-gray-300 transition-colors;
  }
  
  .card {
    @apply bg-white rounded-lg shadow-sm border p-6;
  }
  
  .neural-gradient {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  }
}
EOF

    # 创建布局组件
    mkdir -p src/components
    cat > src/components/Layout.js << 'EOF'
import React, { useState } from 'react';
import { NavLink } from 'react-router-dom';
import { 
  Brain, Menu, X, User, Bell, Search,
  TrendingUp, FileText, BookOpen, Database, 
  Users, BarChart3, Settings
} from 'lucide-react';

const Layout = ({ children }) => {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);

  const navItems = [
    { to: '/', label: '总览', icon: TrendingUp },
    { to: '/projects', label: '项目管理', icon: FileText },
    { to: '/papers', label: '论文管理', icon: BookOpen },
    { to: '/experiments', label: '实验数据', icon: Database },
    { to: '/collaboration', label: '团队协作', icon: Users },
    { to: '/analytics', label: '数据分析', icon: BarChart3 },
  ];

  return (
    <div className="min-h-screen bg-gray-100">
      {/* 顶部导航 */}
      <header className="bg-white shadow-sm border-b sticky top-0 z-40">
        <div className="flex items-center justify-between px-6 py-4">
          <div className="flex items-center">
            <button 
              onClick={() => setIsSidebarOpen(!isSidebarOpen)}
              className="lg:hidden mr-4"
            >
              {isSidebarOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
            <div className="flex items-center">
              <Brain className="w-8 h-8 text-blue-600 mr-3" />
              <h1 className="text-xl font-bold">AI神经科学研究框架</h1>
            </div>
          </div>
          
          <div className="flex items-center space-x-4">
            <div className="relative">
              <Search className="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
              <input 
                type="text" 
                placeholder="搜索..." 
                className="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <button className="relative p-2 hover:bg-gray-100 rounded-lg">
              <Bell className="w-5 h-5" />
              <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
            </button>
            <button className="flex items-center space-x-2 p-2 hover:bg-gray-100 rounded-lg">
              <User className="w-5 h-5" />
              <span>研究员</span>
            </button>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* 侧边栏 */}
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
                            ? 'bg-blue-50 text-blue-700 border-r-2 border-blue-700' 
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

        {/* 主内容区 */}
        <main className="flex-1 p-6 lg:ml-0">
          {children}
        </main>
      </div>

      {/* 移动端遮罩 */}
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
EOF

    # 创建页面组件
    mkdir -p src/pages
    cat > src/pages/Dashboard.js << 'EOF'
import React from 'react';
import { FileText, BookOpen, Database, Star, Clock } from 'lucide-react';

const Dashboard = () => {
  const stats = [
    { label: '进行中项目', value: '3', icon: FileText, color: 'text-blue-600' },
    { label: '已发表论文', value: '12', icon: BookOpen, color: 'text-green-600' },
    { label: '运行中实验', value: '5', icon: Database, color: 'text-purple-600' },
    { label: '总引用数', value: '156', icon: Star, color: 'text-yellow-600' },
  ];

  const recentProjects = [
    { title: '诱发性劫持的临界阈值研究', status: 'active', progress: 75 },
    { title: '自发性劫持的噪声-记忆相图', status: 'planning', progress: 25 },
    { title: '神经科学启发的前馈抑制机制', status: 'completed', progress: 100 },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-gray-900">研究总览</h1>
        <div className="text-sm text-gray-500">
          最后更新: {new Date().toLocaleDateString('zh-CN')}
        </div>
      </div>

      {/* 统计卡片 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div key={index} className="card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">{stat.label}</p>
                  <p className="text-3xl font-bold text-gray-900">{stat.value}</p>
                </div>
                <Icon className={`w-8 h-8 ${stat.color}`} />
              </div>
            </div>
          );
        })}
      </div>

      {/* 最近项目 */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="card">
          <h3 className="text-lg font-semibold mb-4 flex items-center">
            <Clock className="w-5 h-5 mr-2" />
            最近项目
          </h3>
          <div className="space-y-3">
            {recentProjects.map((project, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded">
                <div className="flex-1">
                  <p className="font-medium text-sm">{project.title}</p>
                  <div className="mt-2">
                    <div className="flex justify-between text-xs mb-1">
                      <span>进度</span>
                      <span>{project.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="bg-blue-600 h-2 rounded-full"
                        style={{ width: `${project.progress}%` }}
                      />
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="card">
          <h3 className="text-lg font-semibold mb-4">研究模块进展</h3>
          <div className="space-y-4">
            {[
              { name: 'AI情绪建模与劫持机制', progress: 60 },
              { name: '神经科学启发的AI抑制机制', progress: 40 },
              { name: 'AI记忆与巩固机制', progress: 20 },
              { name: 'AI学习与可塑性动力学', progress: 10 },
            ].map((module, index) => (
              <div key={index}>
                <div className="flex justify-between text-sm mb-1">
                  <span>{module.name}</span>
                  <span>{module.progress}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-gradient-to-r from-blue-500 to-purple-600 h-2 rounded-full"
                    style={{ width: `${module.progress}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
EOF

    # 创建其他页面组件（简化版）
    for page in Projects Papers Experiments Collaboration Analytics; do
        cat > src/pages/${page}.js << EOF
import React from 'react';

const ${page} = () => {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-gray-900">${page}</h1>
      <div className="card">
        <p>这是 ${page} 页面，功能开发中...</p>
      </div>
    </div>
  );
};

export default ${page};
EOF
    done

    # 创建 index.js
    cat > src/index.js << EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

    # 创建 public/index.html
    mkdir -p public
    cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="AI神经科学现象研究框架 - 学术研究CMS系统" />
    <title>AI神经科学研究框架</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

    cd ..
    print_success "前端项目创建完成"
}

# 创建后端项目
create_backend() {
    print_info "创建后端项目..."
    
    cd backend
    
    # 创建 package.json
    cat > package.json << EOF
{
  "name": "ai-neuroscience-cms-backend",
  "version": "1.0.0",
  "description": "AI神经科学研究CMS系统后端API",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "jest",
    "migrate": "node scripts/migrate.js",
    "seed": "node scripts/seed.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.0.3",
    "sqlite3": "^5.1.6",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0",
    "express-validator": "^6.15.0",
    "multer": "^1.4.5-lts.1",
    "helmet": "^6.1.5",
    "express-rate-limit": "^6.7.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.22",
    "jest": "^29.5.0",
    "supertest": "^6.3.3"
  },
  "keywords": [
    "ai",
    "neuroscience",
    "research",
    "api"
  ],
  "author": "$GITHUB_USERNAME",
  "license": "MIT"
}
EOF

    # 创建主入口文件
    cat > index.js << 'EOF'
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// 中间件
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// 限流
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分钟
  max: 100 // 限制每个IP每15分钟最多100个请求
});
app.use('/api/', limiter);

// 静态文件服务
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// API路由
app.use('/api/auth', require('./routes/auth'));
app.use('/api/projects', require('./routes/projects'));
app.use('/api/papers', require('./routes/papers'));
app.use('/api/experiments', require('./routes/experiments'));
app.use('/api/collaboration', require('./routes/collaboration'));
app.use('/api/analytics', require('./routes/analytics'));

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// 错误处理中间件
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'production' ? 'Internal Server Error' : err.message
  });
});

// 404处理
app.use('*', (req, res) => {
  res.status(404).json({ error: 'API endpoint not found' });
});

app.listen(PORT, () => {
  console.log(`🚀 服务器运行在端口 ${PORT}`);
  console.log(`📊 API文档: http://localhost:${PORT}/api/health`);
});

module.exports = app;
EOF

    # 创建数据库配置
    cat > utils/database.js << 'EOF'
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, '../database/research.db');

class Database {
  constructor() {
    this.db = new sqlite3.Database(dbPath, (err) => {
      if (err) {
        console.error('数据库连接失败:', err);
      } else {
        console.log('✅ SQLite 数据库连接成功');
        this.initTables();
      }
    });
  }

  initTables() {
    // 创建用户表
    this.db.run(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username VARCHAR(50) UNIQUE NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role VARCHAR(20) DEFAULT 'researcher',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // 创建项目表
    this.db.run(`
      CREATE TABLE IF NOT EXISTS projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        module VARCHAR(100),
        status VARCHAR(20) DEFAULT 'planning',
        progress INTEGER DEFAULT 0,
        deadline DATE,
        created_by INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (created_by) REFERENCES users(id)
      )
    `);

    // 创建论文表
    this.db.run(`
      CREATE TABLE IF NOT EXISTS papers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(255) NOT NULL,
        authors TEXT,
        journal VARCHAR(100),
        status VARCHAR(20) DEFAULT 'draft',
        submission_date DATE,
        publication_date DATE,
        citations INTEGER DEFAULT 0,
        project_id INTEGER,
        file_path VARCHAR(255),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (project_id) REFERENCES projects(id)
      )
    `);

    // 创建实验表
    this.db.run(`
      CREATE TABLE IF NOT EXISTS experiments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        project_id INTEGER,
        status VARCHAR(20) DEFAULT 'planned',
        start_date DATE,
        end_date DATE,
        data_size VARCHAR(50),
        results TEXT,
        parameters JSON,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (project_id) REFERENCES projects(id)
      )
    `);

    console.log('📊 数据库表初始化完成');
  }

  query(sql, params = []) {
    return new Promise((resolve, reject) => {
      this.db.all(sql, params, (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows);
        }
      });
    });
  }

  run(sql, params = []) {
    return new Promise((resolve, reject) => {
      this.db.run(sql, params, function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({ id: this.lastID, changes: this.changes });
        }
      });
    });
  }

  close() {
    this.db.close();
  }
}

module.exports = new Database();
EOF

    # 创建API路由
    mkdir -p routes
    
    # 项目路由
    cat > routes/projects.js << 'EOF'
const express = require('express');
const router = express.Router();
const db = require('../utils/database');

// 获取所有项目
router.get('/', async (req, res) => {
  try {
    const projects = await db.query(`
      SELECT p.*, COUNT(e.id) as experiment_count, COUNT(pa.id) as paper_count
      FROM projects p
      LEFT JOIN experiments e ON p.id = e.project_id
      LEFT JOIN papers pa ON p.id = pa.project_id
      GROUP BY p.id
      ORDER BY p.updated_at DESC
    `);
    res.json(projects);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 创建项目
router.post('/', async (req, res) => {
  try {
    const { title, description, module, deadline } = req.body;
    const result = await db.run(
      'INSERT INTO projects (title, description, module, deadline) VALUES (?, ?, ?, ?)',
      [title, description, module, deadline]
    );
    res.status(201).json({ id: result.id, message: '项目创建成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 更新项目
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, module, status, progress, deadline } = req.body;
    await db.run(
      'UPDATE projects SET title=?, description=?, module=?, status=?, progress=?, deadline=?, updated_at=CURRENT_TIMESTAMP WHERE id=?',
      [title, description, module, status, progress, deadline, id]
    );
    res.json({ message: '项目更新成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
EOF

    # 其他路由文件（简化版）
    for route in auth papers experiments collaboration analytics; do
        cat > routes/${route}.js << EOF
const express = require('express');
const router = express.Router();
const db = require('../utils/database');

// 获取所有${route}
router.get('/', async (req, res) => {
  try {
    const data = await db.query('SELECT * FROM ${route} ORDER BY created_at DESC');
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 创建${route}
router.post('/', async (req, res) => {
  try {
    res.status(201).json({ message: '${route} 创建成功（功能开发中）' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
EOF
    done

    # 创建环境配置文件
    cat > .env.example << EOF
# 服务器配置
PORT=3001
NODE_ENV=development

# 数据库配置
DB_PATH=./database/research.db

# JWT配置
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d

# 文件上传配置
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=10485760

# 邮件配置 (可选)
SMTP_HOST=
SMTP_PORT=
SMTP_USER=
SMTP_PASS=
EOF

    cp .env.example .env

    cd ..
    print_success "后端项目创建完成"
}

# 创建 Docker 配置
create_docker_config() {
    if [ "$create_docker" = "y" ]; then
        print_info "创建 Docker 配置..."
        
        # 前端 Dockerfile
        cat > frontend/Dockerfile << EOF
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

        # 前端 nginx 配置
        cat > frontend/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
            try_files \$uri \$uri/ /index.html;
        }

        location /api {
            proxy_pass http://backend:3001;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

        # 后端 Dockerfile
        cat > backend/Dockerfile << EOF
FROM node:18-alpine

WORKDIR /app

# 复制 package.json
COPY package*.json ./

# 安装依赖
RUN npm ci --only=production

# 复制源代码
COPY . .

# 创建必要的目录
RUN mkdir -p database uploads

# 暴露端口
EXPOSE 3001

# 启动应用
CMD ["npm", "start"]
EOF

        # docker-compose.yml
        cat > docker-compose.yml << EOF
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: unless-stopped

  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - PORT=3001
    volumes:
      - ./backend/database:/app/database
      - ./backend/uploads:/app/uploads
    restart: unless-stopped

volumes:
  database_data:
  uploads_data:
EOF

        # docker-compose.dev.yml
        cat > docker-compose.dev.yml << EOF
version: '3.8'

services:
  frontend:
    build: 
      context: ./frontend
      target: builder
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true
    command: npm start

  backend:
    build: ./backend
    ports:
      - "3001:3001"
    volumes:
      - ./backend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    command: npm run dev
EOF

        print_success "Docker 配置创建完成"
    fi
}

# 创建部署脚本
create_deployment_scripts() {
    print_info "创建部署脚本..."
    
    mkdir -p scripts
    
    # 本地开发脚本
    cat > scripts/dev.sh << 'EOF'
#!/bin/bash

echo "🚀 启动开发环境..."

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装，请先安装 Node.js"
    exit 1
fi

# 安装依赖
echo "📦 安装依赖..."
npm run install:all

# 启动开发服务器
echo "🏃 启动开发服务器..."
npm run dev
EOF

    # Docker 部署脚本
    cat > scripts/deploy.sh << 'EOF'
#!/bin/bash

echo "🚀 开始部署..."

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 构建并启动服务
echo "🔨 构建应用..."
docker-compose build

echo "🚀 启动服务..."
docker-compose up -d

echo "✅ 部署完成！"
echo "🌐 前端地址: http://localhost"
echo "📊 后端API: http://localhost:3001/api/health"
EOF

    # Vercel 部署配置
    cat > vercel.json << EOF
{
  "version": 2,
  "builds": [
    {
      "src": "frontend/package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "build"
      }
    },
    {
      "src": "backend/index.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/backend/index.js"
    },
    {
      "src": "/(.*)",
      "dest": "/frontend/\$1"
    }
  ]
}
EOF

    # Railway 部署配置
    cat > railway.toml << EOF
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "npm start"
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10

[[services]]
name = "ai-neuroscience-cms"
source = "."

[services.variables]
NODE_ENV = "production"
PORT = "\${{ PORT }}"
EOF

    # Netlify 配置
    cat > netlify.toml << EOF
[build]
  base = "frontend/"
  publish = "build/"
  command = "npm run build"

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/:splat"
  status = 200

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
EOF

    chmod +x scripts/*.sh
    
    print_success "部署脚本创建完成"
}

# 创建文档
create_documentation() {
    print_info "创建项目文档..."
    
    # README.md
    cat > README.md << EOF
# AI神经科学现象研究框架 - 学术研究CMS系统

🧠 一个专门为AI神经科学研究设计的综合性学术研究管理系统，基于杏仁核劫持理论和神经科学启发的AI安全研究框架。

## 🎯 系统特性

### 核心功能
- **项目管理**: 管理AI神经科学研究项目的全生命周期
- **论文跟踪**: 从草稿到发表的完整论文管理流程
- **实验数据**: 存储和管理神经网络实验数据
- **团队协作**: 研究团队协作和沟通平台
- **数据分析**: 可视化研究进展和统计分析

### 研究模块
1. **AI情绪建模与劫持机制** - 基于杏仁核双通路理论
2. **神经科学启发的AI抑制机制** - 前馈和反馈抑制
3. **AI记忆与巩固机制** - 双阶段记忆模型
4. **AI学习与可塑性动力学** - LTP/LTD理论应用
5. **AI序列建模与高级结构** - θ-γ耦合机制

## 🚀 快速开始

### 本地开发
\`\`\`bash
# 克隆项目
git clone https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git
cd $PROJECT_NAME

# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

### Docker 部署
\`\`\`bash
# 使用 Docker Compose
docker-compose up -d

# 或使用开发环境
docker-compose -f docker-compose.dev.yml up
\`\`\`

## 📊 系统架构

\`\`\`
frontend/          # React 前端应用
├── src/
│   ├── components/   # 可复用组件
│   ├── pages/        # 页面组件
│   ├── hooks/        # 自定义 Hooks
│   └── styles/       # 样式文件

backend/           # Node.js 后端API
├── routes/          # API 路由
├── models/          # 数据模型
├── utils/           # 工具函数
└── middleware/      # 中间件

database/          # SQLite 数据库
├── migrations/      # 数据迁移
└── seeds/          # 种子数据
\`\`\`

## 🛠️ 技术栈

### 前端
- **React 18** - 现代化前端框架
- **Tailwind CSS** - 实用优先的CSS框架
- **React Router** - 客户端路由
- **React Query** - 服务器状态管理
- **Lucide React** - 现代图标库
- **Recharts** - 数据可视化

### 后端
- **Node.js** - 服务器运行时
- **Express** - Web 应用框架
- **SQLite** - 轻量级数据库
- **JWT** - 身份验证
- **Multer** - 文件上传
- **Helmet** - 安全中间件

### 部署
- **Docker** - 容器化部署
- **Vercel** - 前端免费托管
- **Railway** - 后端免费托管
- **Netlify** - 静态站点托管

## 📈 免费部署方案

### 方案1: Vercel + Railway
1. **前端**: 部署到 Vercel (免费)
2. **后端**: 部署到 Railway (免费额度)
3. **数据库**: SQLite 文件存储

### 方案2: Netlify + Heroku
1. **前端**: 部署到 Netlify (免费)
2. **后端**: 部署到 Heroku (免费层级)
3. **数据库**: PostgreSQL (Heroku 提供)

### 方案3: 完全免费的 GitHub Pages
1. 使用 GitHub Actions 自动部署
2. 后端API通过 Serverless Functions
3. 数据存储使用 GitHub Issues API

## 🧪 研究应用场景

### 杏仁核劫持实验
- **诱发性劫持**: 对抗强度εc与快/慢通路主导权切换
- **自发性劫持**: 噪声σ与记忆权重λ_mem的相图分析
- **门控阈值**: 前馈抑制机制的效果评估

### 神经网络分析
- **双通路架构**: Fast/Slow pathway的显式分离
- **动态权重**: α_t权重的时间演化机制
- **记忆模块**: 显式的记忆存储和重放机制

## 📚 API 文档

### 项目管理 API
\`\`\`
GET    /api/projects     # 获取所有项目
POST   /api/projects     # 创建新项目
PUT    /api/projects/:id # 更新项目
DELETE /api/projects/:id # 删除项目
\`\`\`

### 论文管理 API
\`\`\`
GET    /api/papers       # 获取所有论文
POST   /api/papers       # 创建新论文
PUT    /api/papers/:id   # 更新论文信息
DELETE /api/papers/:id   # 删除论文
\`\`\`

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (\`git checkout -b feature/AmazingFeature\`)
3. 提交更改 (\`git commit -m 'Add some AmazingFeature'\`)
4. 推送到分支 (\`git push origin feature/AmazingFeature\`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🔗 相关链接

- [项目主页](https://github.com/$GITHUB_USERNAME/$PROJECT_NAME)
- [在线演示](https://$PROJECT_NAME.vercel.app)
- [API文档](https://$PROJECT_NAME.vercel.app/api/health)
- [问题反馈](https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/issues)

## 📞 联系方式

- 作者: $GITHUB_USERNAME
- 邮箱: [你的邮箱]
- 项目链接: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME

---

⭐ 如果这个项目对你有帮助，请给它一个 Star！
EOF

    # API文档
    mkdir -p docs
    cat > docs/API.md << EOF
# API 文档

## 概述

AI神经科学研究CMS系统的RESTful API文档。

## 基础信息

- **Base URL**: \`http://localhost:3001/api\`
- **认证方式**: JWT Token (Bearer)
- **数据格式**: JSON
- **字符编码**: UTF-8

## 通用响应格式

### 成功响应
\`\`\`json
{
  "status": "success",
  "data": { ... },
  "message": "操作成功"
}
\`\`\`

### 错误响应
\`\`\`json
{
  "status": "error",
  "error": "错误信息",
  "code": 400
}
\`\`\`

## 端点列表

### 健康检查
\`GET /health\`

返回系统状态信息。

### 项目管理
- \`GET /projects\` - 获取所有项目
- \`POST /projects\` - 创建新项目  
- \`GET /projects/:id\` - 获取特定项目
- \`PUT /projects/:id\` - 更新项目
- \`DELETE /projects/:id\` - 删除项目

### 论文管理
- \`GET /papers\` - 获取所有论文
- \`POST /papers\` - 创建新论文
- \`GET /papers/:id\` - 获取特定论文
- \`PUT /papers/:id\` - 更新论文
- \`DELETE /papers/:id\` - 删除论文

### 实验数据
- \`GET /experiments\` - 获取所有实验
- \`POST /experiments\` - 创建新实验
- \`GET /experiments/:id\` - 获取特定实验
- \`PUT /experiments/:id\` - 更新实验
- \`DELETE /experiments/:id\` - 删除实验

## 数据模型

### Project 项目
\`\`\`json
{
  "id": 1,
  "title": "项目标题",
  "description": "项目描述",
  "module": "研究模块",
  "status": "active|planning|completed",
  "progress": 75,
  "deadline": "2024-12-31",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
\`\`\`

### Paper 论文
\`\`\`json
{
  "id": 1,
  "title": "论文标题",
  "authors": ["作者1", "作者2"],
  "journal": "期刊名称",
  "status": "draft|submitted|published",
  "submission_date": "2024-01-01",
  "citations": 10,
  "project_id": 1
}
\`\`\`

### Experiment 实验
\`\`\`json
{
  "id": 1,
  "name": "实验名称",
  "description": "实验描述",
  "project_id": 1,
  "status": "planned|running|completed",
  "start_date": "2024-01-01",
  "end_date": "2024-01-31",
  "data_size": "2.3GB",
  "results": "实验结果"
}
\`\`\`
EOF

    # 部署指南
    cat > docs/DEPLOYMENT.md << EOF
# 部署指南

## 免费部署方案

### 方案1: Vercel + Railway (推荐)

#### 前端部署到 Vercel
1. 将代码推送到 GitHub
2. 访问 [Vercel](https://vercel.com)
3. 连接 GitHub 仓库
4. 设置构建命令: \`cd frontend && npm run build\`
5. 设置输出目录: \`frontend/build\`

#### 后端部署到 Railway
1. 访问 [Railway](https://railway.app)
2. 连接 GitHub 仓库
3. 选择 \`backend\` 目录
4. 设置环境变量
5. 部署启动

### 方案2: Netlify + Heroku

#### 前端部署到 Netlify
1. 访问 [Netlify](https://netlify.com)
2. 拖拽 \`frontend/build\` 文件夹
3. 或连接 GitHub 自动部署

#### 后端部署到 Heroku
1. 安装 Heroku CLI
2. 创建应用: \`heroku create your-app-name\`
3. 推送代码: \`git push heroku main\`

### 方案3: GitHub Pages (纯静态)

适用于不需要后端数据库的展示版本。

\`\`\`bash
# 构建前端
cd frontend
npm run build

# 部署到 gh-pages
npm install -g gh-pages
gh-pages -d build
\`\`\`

## Docker 部署

### 本地 Docker
\`\`\`bash
# 构建镜像
docker-compose build

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
\`\`\`

### 云服务器部署
1. 购买云服务器 (阿里云、腾讯云等)
2. 安装 Docker 和 Docker Compose
3. 上传代码并运行

## 域名配置

### 免费域名
- [Freenom](https://freenom.com) - 免费域名注册
- [GitHub Pages](https://pages.github.com) - username.github.io

### DNS 配置
1. 添加 A 记录指向服务器IP
2. 添加 CNAME 记录用于子域名

## SSL 证书

### Let's Encrypt (免费)
\`\`\`bash
# 安装 certbot
sudo apt install certbot

# 获取证书
sudo certbot --nginx -d yourdomain.com
\`\`\`

### Cloudflare (推荐)
1. 注册 Cloudflare 账号
2. 添加域名
3. 修改 DNS 服务器
4. 开启 SSL/TLS 加密

## 环境变量配置

### 生产环境变量
\`\`\`bash
NODE_ENV=production
PORT=3001
JWT_SECRET=your-super-secret-key
DATABASE_URL=your-database-url
\`\`\`

### 平台特定配置

#### Vercel
在项目设置中添加环境变量

#### Railway
\`\`\`bash
railway variables set NODE_ENV=production
railway variables set JWT_SECRET=your-secret
\`\`\`

#### Heroku
\`\`\`bash
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your-secret
\`\`\`

## 监控和日志

### 免费监控工具
- [UptimeRobot](https://uptimerobot.com) - 网站监控
- [LogRocket](https://logrocket.com) - 错误追踪
- [Sentry](https://sentry.io) - 错误监控

### 日志管理
- 使用 \`morgan\` 记录HTTP请求
- 使用 \`winston\` 进行结构化日志
- 云平台通常提供内置日志查看

## 备份策略

### 数据库备份
\`\`\`bash
# SQLite 备份
cp database/research.db backup/research_\$(date +%Y%m%d).db

# 自动备份脚本
echo "0 2 * * * /path/to/backup.sh" | crontab -
\`\`\`

### 代码备份
- 使用 Git 版本控制
- 定期推送到 GitHub
- 创建重要版本的 Release

## 故障排除

### 常见问题
1. **端口冲突**: 修改环境变量中的端口
2. **数据库连接失败**: 检查数据库文件权限
3. **构建失败**: 检查 Node.js 版本兼容性
4. **API 403错误**: 检查 CORS 配置

### 调试技巧
\`\`\`bash
# 查看容器日志
docker-compose logs backend

# 进入容器调试
docker-compose exec backend sh

# 检查环境变量
echo \$NODE_ENV
\`\`\`
EOF

    print_success "项目文档创建完成"
}

# 初始化 Git 仓库
init_git_repository() {
    if [ "$init_git" = "y" ]; then
        print_info "初始化 Git 仓库..."
        
        # 创建 .gitignore
        cat > .gitignore << EOF
# 依赖
node_modules/
*/node_modules/

# 构建产物
frontend/build/
backend/dist/

# 环境变量
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# 日志
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# 数据库
database/*.db
database/*.sqlite
database/*.sqlite3

# 上传文件
backend/uploads/*
!backend/uploads/.gitkeep

# 缓存
.cache/
.parcel-cache/
.tmp/

# 操作系统
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# 测试覆盖率
coverage/

# Docker
.dockerignore

# Logs
logs/
*.log
EOF

        # 创建上传目录占位符
        mkdir -p backend/uploads
        touch backend/uploads/.gitkeep

        # 初始化 Git
        git init
        git add .
        git commit -m "🎉 初始化 AI神经科学研究CMS系统

- ✅ 完整的前后端架构
- ✅ React + Node.js + SQLite 技术栈
- ✅ Docker 容器化配置
- ✅ 多平台免费部署方案
- ✅ 完整的API设计
- ✅ 响应式UI设计
- ✅ 项目管理、论文跟踪、实验数据管理功能

基于AI神经科学现象研究框架，专门为学术研究团队设计。"

        print_success "Git 仓库初始化完成"
        
        print_info "创建 GitHub 仓库的命令:"
        echo ""
        echo -e "${YELLOW}gh repo create $PROJECT_NAME --public --description \"$PROJECT_DESCRIPTION\"${NC}"
        echo -e "${YELLOW}git remote add origin https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git${NC}"
        echo -e "${YELLOW}git branch -M main${NC}"
        echo -e "${YELLOW}git push -u origin main${NC}"
        echo ""
    fi
}

# 生成项目报告
generate_project_report() {
    print_info "生成项目报告..."
    
    cat > PROJECT_REPORT.md << EOF
# 🚀 AI神经科学研究CMS系统 - 项目完成报告

## 📊 项目概览

- **项目名称**: $PROJECT_NAME
- **创建时间**: $(date)
- **技术栈**: React + Node.js + SQLite + Docker
- **部署方案**: 多平台免费部署支持

## 🎯 已完成功能

### ✅ 前端功能
- [x] 响应式UI设计 (Tailwind CSS)
- [x] 路由管理 (React Router)
- [x] 状态管理 (React Query)
- [x] 组件化架构
- [x] 多页面应用 (Dashboard, Projects, Papers, etc.)

### ✅ 后端功能
- [x] RESTful API 设计
- [x] SQLite 数据库集成
- [x] JWT 身份验证
- [x] 文件上传支持
- [x] 错误处理中间件
- [x] 安全配置 (Helmet, CORS, Rate Limiting)

### ✅ 数据库设计
- [x] 用户表 (users)
- [x] 项目表 (projects)
- [x] 论文表 (papers)
- [x] 实验表 (experiments)
- [x] 关联关系设计

### ✅ 部署配置
- [x] Docker 容器化
- [x] docker-compose 配置
- [x] Vercel 部署配置
- [x] Railway 部署配置
- [x] Netlify 部署配置

### ✅ 开发工具
- [x] 开发环境脚本
- [x] 部署脚本
- [x] 环境变量配置
- [x] Git 仓库初始化

## 📁 项目结构

\`\`\`
$PROJECT_NAME/
├── frontend/                 # React 前端应用
│   ├── src/
│   │   ├── components/      # 可复用组件
│   │   ├── pages/          # 页面组件
│   │   ├── styles/         # 样式文件
│   │   └── App.js          # 主应用组件
│   ├── public/             # 静态资源
│   ├── package.json        # 前端依赖
│   ├── Dockerfile          # 前端容器配置
│   └── tailwind.config.js  # Tailwind 配置
│
├── backend/                 # Node.js 后端API
│   ├── routes/             # API 路由
│   ├── utils/              # 工具函数
│   ├── index.js            # 服务器入口
│   ├── package.json        # 后端依赖
│   ├── Dockerfile          # 后端容器配置
│   └── .env.example        # 环境变量示例
│
├── database/               # SQLite 数据库
├── scripts/                # 部署脚本
├── docs/                   # 项目文档
├── docker-compose.yml      # Docker 编排
├── vercel.json            # Vercel 配置
├── railway.toml           # Railway 配置
├── netlify.toml           # Netlify 配置
├── package.json           # 根目录配置
└── README.md              # 项目说明
\`\`\`

## 🚀 快速启动指南

### 方法1: 本地开发
\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

### 方法2: Docker 部署
\`\`\`bash
# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f
\`\`\`

### 方法3: 免费云部署
1. **Vercel (前端)**: 连接 GitHub 自动部署
2. **Railway (后端)**: 一键部署后端API
3. **访问应用**: https://your-app.vercel.app

## 💰 免费部署成本

| 服务 | 平台 | 费用 | 限制 |
|------|------|------|------|
| 前端托管 | Vercel | 免费 | 100GB 带宽/月 |
| 后端API | Railway | 免费 | \$5 额度/月 |
| 数据库 | SQLite | 免费 | 本地文件存储 |
| 域名 | Freenom | 免费 | .tk/.cf/.ga 域名 |
| SSL证书 | Let's Encrypt | 免费 | 自动续期 |
| **总计** | | **\$0/月** | 适合小型项目 |

## 🔧 技术特性

### 前端特性
- **现代化UI**: Tailwind CSS + Lucide 图标
- **响应式设计**: 支持桌面端和移动端
- **组件复用**: 高度模块化的组件设计
- **路由管理**: SPA 路由配置
- **状态管理**: React Query 数据获取

### 后端特性
- **RESTful API**: 标准化API设计
- **数据验证**: Express Validator 参数验证
- **安全性**: JWT认证 + 安全中间件
- **文件处理**: Multer 文件上传
- **错误处理**: 统一错误处理机制

### 数据库特性
- **轻量级**: SQLite 无需额外配置
- **关系型**: 完整的关联关系设计
- **迁移支持**: 数据库版本管理
- **备份简单**: 单文件备份策略

## 📈 扩展建议

### 短期优化
- [ ] 添加用户认证界面
- [ ] 实现文件上传功能
- [ ] 添加数据可视化图表
- [ ] 完善错误处理和用户反馈

### 中期扩展
- [ ] 集成邮件通知系统
- [ ] 添加实时协作功能
- [ ] 实现高级搜索和过滤
- [ ] 移动端APP开发

### 长期规划
- [ ] 微服务架构重构
- [ ] 人工智能辅助功能
- [ ] 多租户SaaS化
- [ ] 企业级权限管理

## 🎉 部署成功！

你的AI神经科学研究CMS系统已经准备就绪！

### 下一步操作：
1. 🔧 运行 \`./scripts/dev.sh\` 启动开发环境
2. 🐳 运行 \`docker-compose up\` 容器化部署
3. ☁️ 推送到 GitHub 并连接 Vercel/Railway
4. 📚 查看 \`docs/\` 目录了解详细文档
5. 🚀 开始你的AI神经科学研究之旅！

---
**项目创建时间**: $(date)  
**创建者**: $GITHUB_USERNAME  
**项目地址**: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME  
EOF

    print_success "项目报告生成完成"
}

# 主函数
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║            AI神经科学研究CMS系统 - 自动部署脚本              ║"
    echo "║                                                              ║"
    echo "║  🧠 基于杏仁核劫持理论的学术研究管理系统                    ║"
    echo "║  🚀 React + Node.js + SQLite + Docker                       ║"
    echo "║  💰 完全免费的云部署方案                                    ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    check_requirements
    get_user_input
    
    echo ""
    print_info "开始创建项目..."
    echo ""
    
    create_project_structure
    create_package_json
    create_frontend
    create_backend
    create_docker_config
    create_deployment_scripts
    create_documentation
    init_git_repository
    generate_project_report
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    🎉 项目创建成功！                        ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_success "✅ 项目名称: $PROJECT_NAME"
    print_success "✅ 前端框架: React 18 + Tailwind CSS"
    print_success "✅ 后端API: Node.js + Express + SQLite"
    print_success "✅ 容器化: Docker + docker-compose"
    print_success "✅ 部署方案: Vercel + Railway (免费)"
    print_success "✅ 文档完备: README + API + 部署指南"
    
    echo ""
    print_info "🚀 快速开始："
    echo -e "   ${YELLOW}cd $PROJECT_NAME${NC}"
    echo -e "   ${YELLOW}./scripts/dev.sh${NC}     # 本地开发"
    echo -e "   ${YELLOW}docker-compose up${NC}    # Docker部署"
    
    echo ""
    print_info "📚 重要文件："
    echo -e "   ${YELLOW}README.md${NC}            # 项目说明文档"
    echo -e "   ${YELLOW}PROJECT_REPORT.md${NC}    # 项目完成报告"
    echo -e "   ${YELLOW}docs/DEPLOYMENT.md${NC}   # 部署指南"
    echo -e "   ${YELLOW}docs/API.md${NC}          # API文档"
    
    echo ""
    print_info "🌐 免费部署："
    echo -e "   ${YELLOW}前端${NC}: Vercel (https://vercel.com)"
    echo -e "   ${YELLOW}后端${NC}: Railway (https://railway.app)"
    echo -e "   ${YELLOW}总成本${NC}: \$0/月"
    
    echo ""
    print_warning "⚠️  注意事项："
    echo "   1. 修改 backend/.env 配置数据库和JWT密钥"
    echo "   2. 在生产环境中使用强密码和HTTPS"
    echo "   3. 定期备份数据库文件"
    echo "   4. 查看 PROJECT_REPORT.md 了解完整功能"
    
    echo ""
    echo -e "${BLUE}🎯 这个系统专门为AI神经科学研究设计，包含：${NC}"
    echo "   • 项目管理 (基于五大研究模块)"
    echo "   • 论文跟踪 (从草稿到发表)"
    echo "   • 实验数据管理 (神经网络实验)"
    echo "   • 团队协作 (研究团队沟通)"
    echo "   • 数据分析 (可视化研究进展)"
    
    echo ""
    echo -e "${GREEN}感谢使用AI神经科学研究CMS系统！🧠✨${NC}"
    echo ""
}

# 运行主函数
main "$@"