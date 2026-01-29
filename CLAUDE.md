# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GitRadar is a GitHub monitoring platform built for the Serverpod 3 Global Hackathon. It provides near real-time notifications and unified tracking of pull requests, issues, and repository activity across multiple projects.

**Tech Stack:** Serverpod 3 + Flutter + PostgreSQL

## Commands

### Quick Start (use helper scripts)

```bash
./scripts/setup.sh               # First-time setup (install deps, generate code)
./scripts/db-start.sh            # Start PostgreSQL via Docker
./scripts/server-start.sh        # Start Serverpod server
./scripts/generate.sh            # Regenerate code after model changes (server + app)
./scripts/db-reset.sh            # Reset database (destructive)
```

### Server (Serverpod)

```bash
cd server
dart pub get                      # Install dependencies
dart pub global run serverpod_cli generate  # Generate code (models, endpoints, migrations)
dart run bin/main.dart --apply-migrations   # Run server (first time or after migrations)
dart run bin/main.dart            # Run server (subsequent runs)
dart test                         # Run all tests
dart test test/integration/auth_endpoint_test.dart  # Run single test file
dart analyze                      # Lint code
dart format .                     # Format code
```

### Deployment (Serverpod Cloud)

```bash
dart pub global run serverpod_cloud_cli deploy      # Deploy to production
dart pub global run serverpod_cloud_cli deployment list  # Check deployment status
dart pub global run serverpod_cloud_cli log         # View server logs
```

**Production URL:** `https://gitradar.api.serverpod.space/`

### App (Flutter)

```bash
cd app
flutter pub get                   # Install dependencies
flutter run -d chrome             # Run web
flutter run -d macos              # Run macOS desktop
flutter test                      # Run all tests
flutter test test/widget_test.dart  # Run single test
flutter analyze                   # Lint code
dart format .                     # Format code
```

### After Model Changes

When you modify `server/lib/src/models/*.spy.yaml` files:
```bash
./scripts/generate.sh             # Regenerates server + updates app dependencies
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

### Key Services

- **GitHubApiService** (`server/lib/src/services/github_api_service.dart`): HTTP client for GitHub REST API with rate limit handling and exponential backoff
- **SyncService** (`server/lib/src/services/sync_service.dart`): Syncs PRs/Issues from GitHub, creates notifications, enforces 50-item limit per repo
- **EncryptionService** (`server/lib/src/services/encryption_service.dart`): AES-256 encryption for PAT storage
- **NotificationService** (`server/lib/src/services/notification_service.dart`): Creates in-app notifications based on repo settings
- **OneSignalService** (`server/lib/src/services/onesignal_service.dart`): Push notification delivery

### Background Sync

The `RepositorySyncFutureCall` in `server/lib/src/futures/repository_sync_call.dart` runs every 5 minutes via Serverpod's scheduler. It syncs all repositories for all users and reschedules itself.

### Authentication

- Uses GitHub PAT-based auth (no Serverpod auth module, no OAuth for MVP)
- User submits PAT → Server validates via GitHub `GET /user` → Creates/updates User record
- User identity derived from GitHub (githubId, username, displayName, avatarUrl)
- GitHub PAT stored server-side only, AES-256 encrypted via `EncryptionService`
- Session token format: `base64(userId:timestamp)` - decoded by custom auth handler in `server/lib/src/util/auth_handler.dart`
- Client stores token in SharedPreferences, sends via Bearer auth header
- Supports anonymous mode (public repos only, 60 req/hr rate limit)
- Never return GitHub tokens to client

### Database Models

Define in `server/lib/src/models/*.spy.yaml` (note the `.spy.yaml` extension for Serverpod 3):

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

After changes, run `./scripts/generate.sh` or `cd server && dart pub global run serverpod_cli generate`.

### App State Management

The Flutter app uses **Riverpod** for state management and **GoRouter** for navigation:

- `clientProvider` (`app/lib/src/core/client.dart`): Serverpod client with auth key provider
- `sessionTokenProvider`: Manages session token in SharedPreferences
- `authStateProvider` (`app/lib/src/providers/auth_provider.dart`): Tracks login state, used by GoRouter redirect guards
- Feature-specific providers in `app/lib/src/features/{feature}/providers/`

GoRouter configuration in `app/lib/src/routing/router.dart` includes auth redirect guards that check `authStateProvider`.

## MVP Scope Boundaries

### In Scope
- GitHub PAT-based auth (user identity from GitHub API)
- Repository CRUD (max 10 per user)
- Per-repository notification settings (in-app + push toggles)
- Periodic sync via Serverpod scheduler (every 5 min)
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

## Code Style

- Use single quotes for strings (`'hello'` not `"hello"`)
- Always declare return types
- Prefer `const` constructors and declarations

## Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Methods/Variables**: `camelCase`
- **Database tables**: `snake_case`
- **Endpoints**: `{Feature}Endpoint` (e.g., `RepositoryEndpoint`)
- **Model files**: `{model_name}.spy.yaml` (Serverpod 3 format)
- **Future calls**: `{name}_call.dart` in `server/lib/src/futures/`

## Repository Structure

```
gitradar/
├── server/                    # Serverpod backend
│   ├── lib/src/
│   │   ├── endpoints/         # RPC endpoints (NOT REST)
│   │   ├── models/            # Serverpod model definitions (.spy.yaml)
│   │   ├── services/          # Business logic (GitHub API, sync, encryption)
│   │   ├── futures/           # Scheduled background tasks
│   │   └── generated/         # Auto-generated (DO NOT EDIT)
│   └── migrations/            # Database migrations
├── app/                       # Flutter application
│   ├── lib/src/
│   │   ├── features/          # Feature modules (auth, repositories, activity, notifications, settings)
│   │   ├── providers/         # Global Riverpod providers (auth state)
│   │   ├── routing/           # GoRouter config with auth guards
│   │   ├── core/              # Shared utilities, theme, client setup
│   │   └── generated/         # Serverpod client (DO NOT EDIT)
├── gitradar_client/           # Auto-generated Serverpod client package
├── scripts/                   # Development helper scripts
└── docs/                      # Documentation (PRD.md, setup guides)
```
