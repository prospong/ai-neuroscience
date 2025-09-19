# AI Neuroscience CMS - Backend API

## Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

## Environment Variables

Copy `.env.example` to `.env` and configure:

- `NODE_ENV`: Environment (development/production)
- `PORT`: Server port (default: 3001)
- `JWT_SECRET`: Secret key for JWT tokens
- `ADMIN_EMAIL`: Default admin email
- `ADMIN_PASSWORD`: Default admin password

## API Endpoints

- `GET /api/health` - Health check
- `GET /` - API info

## Development

- Uses Express.js framework
- SQLite database (planned)
- JWT authentication (planned)
- RESTful API design
