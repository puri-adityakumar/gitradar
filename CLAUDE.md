# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GitRadar is a GitHub monitoring platform built for the Serverpod 3 Global Hackathon. It provides near real-time notifications and unified tracking of pull requests, issues, and repository activity across multiple projects.

**Tech Stack:** Serverpod 3 + Flutter + PostgreSQL

## Repository Structure (Monorepo)

```
gitradar/
├── server/                    # Serverpod backend
│   ├── lib/src/
│   │   ├── endpoints/         # RPC endpoints (NOT REST)
│   │   ├── models/            # Serverpod model definitions (.yaml)
│   │   ├── services/          # Business logic (GitHub API, sync)
│   │   └── generated/         # Auto-generated (DO NOT EDIT)
│   └── migrations/            # Database migrations
├── app/                       # Flutter application
│   ├── lib/src/
│   │   ├── features/          # Feature modules
│   │   ├── core/              # Shared utilities, theme
│   │   └── generated/         # Serverpod client (DO NOT EDIT)
└── docs/                      # Documentation (PRD.md, setup guides)
```

## Commands

### Server (Serverpod)

```bash
cd server
dart pub get                      # Install dependencies
serverpod generate                # Generate code (models, endpoints, migrations)
serverpod migrate                 # Run database migrations
dart run bin/main.dart            # Start development server (API: :8080, Web: :8082)
dart run bin/main.dart --apply-migrations  # First run with migrations
dart test                         # Run tests
```

### App (Flutter)

```bash
cd app
flutter pub get                   # Install dependencies
flutter run -d chrome             # Run web
flutter run -d iPhone             # Run iOS Simulator
flutter test                      # Run tests
flutter build web                 # Build web
```

### Full Project (after model changes)

```bash
cd server && serverpod generate && cd ../app && flutter pub get
```

### Database (Docker)

```bash
cd server
docker compose up -d              # Start PostgreSQL
docker compose down               # Stop PostgreSQL
```

## Architecture

### Serverpod Endpoints (RPC, NOT REST)

Serverpod uses RPC-style endpoints, not REST. Define methods as class methods:

```dart
// CORRECT - Serverpod RPC style
class RepositoryEndpoint extends Endpoint {
  Future<Repository> addRepository(Session session, String owner, String repo) async { ... }
  Future<List<Repository>> listRepositories(Session session) async { ... }
}
```

### Authentication

- Uses GitHub PAT-based auth (no Serverpod auth module, no OAuth for MVP)
- User submits PAT → Server validates via GitHub `GET /user` → Creates/updates User record
- User identity derived from GitHub (githubId, username, displayName, avatarUrl)
- GitHub PAT stored server-side only, AES-256 encrypted
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
indexes:
  idx_user_repo:
    fields: userId, owner, repo
    unique: true
```

## MVP Scope Boundaries

### In Scope
- GitHub PAT-based auth (user identity from GitHub API)
- Repository CRUD (max 10 per user)
- Per-repository notification settings (in-app + push toggles)
- Periodic sync via Serverpod scheduler (every 5-10 min)
- Store last 50 PRs/Issues per repo
- In-app notifications with mark read/unread
- Push notifications via OneSignal (per-repository)
- 4 screens: Login, Repos, Activity, Settings
- Light/Dark theme

### Out of Scope (Do NOT implement)
- GitHub OAuth flow
- Webhooks
- Full PR/Issue detail screens (link to GitHub instead)
- Comments fetching
- AI summarization
- Multi-user/team features

## GitHub API Guidelines

- Authenticated rate limit: 5000 requests/hour
- Implement exponential backoff on 403/429 responses
- Use `sort=updated&direction=desc` to get recent changes first
- Limit pagination (max 2 pages per sync for MVP)
- Required PAT scopes: `repo` (private repos), `read:user` (optional)

## Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Methods/Variables**: `camelCase`
- **Database tables**: `snake_case`
- **Endpoints**: `{Feature}Endpoint` (e.g., `RepositoryEndpoint`)
