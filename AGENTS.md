# GitRadar - Agent Instructions

## Project Overview

GitRadar is a GitHub monitoring platform for the Serverpod 3 Global Hackathon.
Tech stack: **Serverpod 3 + Flutter + PostgreSQL**

## Repository Structure (Monorepo)

```
gitradar/
├── server/                    # Serverpod backend
│   ├── lib/
│   │   ├── src/
│   │   │   ├── endpoints/     # RPC endpoints (NOT REST)
│   │   │   ├── models/        # Serverpod model definitions
│   │   │   ├── services/      # Business logic (GitHub API, sync)
│   │   │   └── generated/     # Auto-generated (DO NOT EDIT)
│   │   └── server.dart
│   └── migrations/            # Database migrations
├── app/                       # Flutter application
│   ├── lib/
│   │   ├── src/
│   │   │   ├── features/      # Feature modules
│   │   │   ├── core/          # Shared utilities, theme
│   │   │   └── generated/     # Serverpod client (DO NOT EDIT)
│   │   └── main.dart
│   └── pubspec.yaml
├── docs/                      # Documentation
│   ├── PRD.md                 # Product Requirements Document
│   ├── GETTING_STARTED.md     # Flutter/Serverpod setup for beginners
│   └── TOOLS_AND_SETUP.md     # Development setup guide
├── AGENTS.md                  # This file
└── README.md
```

## Commands

### Server (Serverpod)

```bash
# Navigate to server
cd server

# Install dependencies
dart pub get

# Generate code (models, endpoints, migrations)
serverpod generate

# Run database migrations
serverpod migrate

# Start development server
dart run bin/main.dart

# Run tests
dart test
```

### App (Flutter)

```bash
# Navigate to app
cd app

# Install dependencies
flutter pub get

# Generate Serverpod client (after server changes)
# Run from app directory - client is auto-generated from server

# Run web
flutter run -d chrome

# Run tests
flutter test

# Build web
flutter build web
```

### Full Project

```bash
# From root - generate all code
cd server && serverpod generate && cd ../app && flutter pub get
```

## Code Conventions

### Serverpod Endpoints (RPC, NOT REST)

Serverpod uses RPC-style endpoints, not REST. Define methods like:

```dart
// ✅ CORRECT - Serverpod RPC style
class RepositoryEndpoint extends Endpoint {
  Future<Repository> addRepository(Session session, AddRepositoryRequest request) async {
    // Implementation
  }
  
  Future<List<Repository>> listRepositories(Session session) async {
    // Implementation
  }
}

// ❌ WRONG - Don't design REST-style routes
// POST /repository/add - This is NOT how Serverpod works
```

### Authentication

- Use Serverpod's built-in auth module
- Every endpoint method receives `Session session` - use it for auth checks
- GitHub PAT stored server-side only, encrypted
- Never return GitHub tokens to client

### Database Models

Define in `server/lib/src/models/*.yaml`:

```yaml
class: Repository
table: repositories
fields:
  userId: int
  owner: String
  repo: String
  githubRepoId: int
  # ... other fields
indexes:
  idx_user_repo:
    fields: userId, owner, repo
    unique: true
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Methods/Variables**: `camelCase`
- **Database tables**: `snake_case`
- **Endpoints**: `{Feature}Endpoint` (e.g., `RepositoryEndpoint`)

### Error Handling

- Use Serverpod's exception system
- Define typed errors: `GitHubRateLimitedException`, `RepositoryNotFoundException`
- Always handle GitHub API errors gracefully

## MVP Scope Boundaries

### ✅ IN SCOPE (Implement these)
- Serverpod auth (email/password) + GitHub PAT storage
- Repository CRUD (add/list/remove, max 10 per user)
- Periodic sync via Serverpod scheduler (every 5-10 min)
- Store last 50 PRs/Issues per repo
- In-app notifications with mark read/unread
- 4 screens: Login, Repos, Activity, Settings
- Light/Dark theme

### ❌ OUT OF SCOPE (Do NOT implement unless explicitly asked)
- GitHub OAuth flow (use PAT for MVP)
- Webhooks
- Push notifications (FCM)
- Digest mode / smart filtering
- Full PR/Issue detail screens (link to GitHub instead)
- Comments fetching
- AI summarization
- Multi-user/team features

## Task Definition of Done

A task is complete when:
1. Code compiles without errors
2. Auth checks are in place (every endpoint verifies user ownership)
3. Basic error handling for external API calls
4. UI has loading and error states
5. `serverpod generate` runs without errors
6. Relevant tests pass (if tests exist)

## GitHub API Guidelines

### Rate Limiting
- Authenticated: 5000 requests/hour
- Use conditional requests (`If-Modified-Since`, `ETag`) where possible
- Implement exponential backoff on 403/429

### Sync Strategy
- Use `sort=updated&direction=desc` to get recent changes first
- Store `lastSyncedAt` per repository
- Limit pagination (max 2 pages per sync for MVP)
- Use `since` parameter for incremental syncs

### Required Scopes for PAT
- `repo` (for private repos)
- `read:user` (optional, for user info)

## File Patterns

### When creating new endpoints
1. Create model in `server/lib/src/models/`
2. Create endpoint in `server/lib/src/endpoints/`
3. Run `serverpod generate`
4. Update Flutter app to use new client methods

### When creating new UI features
1. Create feature folder in `app/lib/src/features/{feature}/`
2. Add screens, widgets, providers in feature folder
3. Register routes if needed
