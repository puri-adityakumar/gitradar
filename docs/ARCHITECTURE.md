# GitRadar Architecture

Technical architecture documentation for the GitRadar platform.

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Flutter Application                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐  │
│  │   UI Layer      │  │   Riverpod      │  │   Serverpod Client  │  │
│  │   (Screens)     │◄─│   Providers     │◄─│   SDK               │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────────┘  │
└─────────────────────────────────────┬───────────────────────────────┘
                                      │ HTTPS/WebSocket
                                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Serverpod Backend                              │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    RPC Endpoints Layer                       │    │
│  │  AuthEndpoint │ RepositoryEndpoint │ ActivityEndpoint │ ... │    │
│  └───────────────────────────┬─────────────────────────────────┘    │
│                              │                                       │
│  ┌───────────────────────────▼─────────────────────────────────┐    │
│  │                    Services Layer                            │    │
│  │  GitHubApiService │ SyncService │ EncryptionService │ ...   │    │
│  └───────────────────────────┬─────────────────────────────────┘    │
│                              │                                       │
│  ┌───────────────────────────▼─────────────────────────────────┐    │
│  │                 Serverpod ORM / Database                     │    │
│  └───────────────────────────┬─────────────────────────────────┘    │
└──────────────────────────────┼──────────────────────────────────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        ▼                      ▼                      ▼
┌───────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  PostgreSQL   │    │   GitHub API    │    │    OneSignal    │
│   Database    │    │  api.github.com │    │  Push Service   │
└───────────────┘    └─────────────────┘    └─────────────────┘
```

## Backend Architecture

### Endpoint Layer

Serverpod uses RPC-style endpoints (not REST). Each endpoint is a Dart class with async methods.

```
server/lib/src/endpoints/
├── auth_endpoint.dart          # Login, logout, session validation
├── repository_endpoint.dart    # CRUD repos, sync trigger
├── activity_endpoint.dart      # List PRs/Issues, mark read
├── notification_endpoint.dart  # List notifications, mark read
└── preferences_endpoint.dart   # Theme settings
```

**Request Flow:**
```
Client SDK Method Call
        ↓
Serverpod Routing (auto-generated)
        ↓
Endpoint Method (with Session)
        ↓
Auth Handler Middleware
        ↓
Business Logic (Services)
        ↓
Database Query (ORM)
        ↓
Response Serialization
```

### Services Layer

```
server/lib/src/services/
├── github_api_service.dart     # GitHub REST API client
├── sync_service.dart           # PR/Issue sync logic
├── encryption_service.dart     # AES-256 PAT encryption
├── notification_service.dart   # In-app notification creation
└── onesignal_service.dart      # Push notification delivery
```

**GitHubApiService:**
- HTTP client for GitHub REST API
- Rate limit handling (5000 req/hr authenticated, 60 req/hr anonymous)
- Exponential backoff on 403/429 responses
- PAT decryption for authenticated requests

**SyncService:**
- Fetches PRs/Issues from GitHub
- Upserts to database (create or update)
- Enforces 50-item limit per repo
- Triggers notification creation

### Background Jobs

```
server/lib/src/futures/
└── repository_sync_call.dart   # Scheduled sync job
```

**Sync Schedule:**
- Runs every 5 minutes via Serverpod FutureCall
- Syncs all repositories for all users
- Self-reschedules after completion

```
┌─────────────────────────────────────────┐
│         RepositorySyncFutureCall        │
├─────────────────────────────────────────┤
│ 1. Query all users                      │
│ 2. For each user:                       │
│    └─ Query user's repositories         │
│       └─ For each repo:                 │
│          ├─ Fetch PRs from GitHub       │
│          ├─ Fetch Issues from GitHub    │
│          ├─ Upsert to database          │
│          └─ Create notifications        │
│ 3. Reschedule self (+5 minutes)         │
└─────────────────────────────────────────┘
```

### Authentication Flow

```
┌─────────┐     ┌──────────┐     ┌─────────────┐     ┌──────────┐
│  User   │────▶│  Client  │────▶│   Server    │────▶│  GitHub  │
│         │     │   App    │     │  AuthEndpoint│     │   API    │
└─────────┘     └──────────┘     └─────────────┘     └──────────┘
     │               │                  │                  │
     │  Enter PAT    │                  │                  │
     │──────────────▶│                  │                  │
     │               │  login(pat)      │                  │
     │               │─────────────────▶│                  │
     │               │                  │  GET /user       │
     │               │                  │─────────────────▶│
     │               │                  │  { id, login,    │
     │               │                  │◀───avatar, name }│
     │               │                  │                  │
     │               │                  │ Encrypt PAT      │
     │               │                  │ Create/Update User
     │               │                  │ Generate Token   │
     │               │  AuthResponse    │                  │
     │               │◀─────────────────│                  │
     │  Show Home    │                  │                  │
     │◀──────────────│                  │                  │
```

**Session Token Format:** `base64(userId:timestamp)`

**Anonymous Mode:**
- Skip PAT validation
- Create guest user (no PAT stored)
- Limited to public repositories
- 60 req/hr GitHub rate limit

## Frontend Architecture

### Feature-Based Structure

```
app/lib/src/
├── core/
│   ├── client.dart         # Serverpod client provider
│   ├── constants.dart      # URLs, limits, routes
│   └── theme.dart          # Material 3 theme
├── features/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── auth_provider.dart
│   ├── repositories/
│   │   ├── repositories_screen.dart
│   │   ├── add_repository_screen.dart
│   │   └── repositories_provider.dart
│   ├── activity/
│   │   ├── activity_screen.dart
│   │   └── activity_provider.dart
│   ├── notifications/
│   │   ├── notifications_screen.dart
│   │   └── notifications_provider.dart
│   └── settings/
│       ├── settings_screen.dart
│       └── settings_provider.dart
├── shared/
│   └── widgets/
│       ├── main_scaffold.dart
│       ├── empty_widget.dart
│       ├── error_widget.dart
│       ├── loading_widget.dart
│       └── skeleton_loader.dart
├── providers/
│   └── auth_provider.dart   # Global auth state
└── routing/
    └── router.dart          # GoRouter config
```

### State Management (Riverpod)

```
┌─────────────────────────────────────────────────────────────┐
│                    Provider Hierarchy                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  clientProvider (Serverpod Client)                          │
│       │                                                      │
│       ├── authStateProvider (login state)                   │
│       │       │                                              │
│       │       └── GoRouter redirect guards                  │
│       │                                                      │
│       ├── repositoriesProvider (FutureProvider)             │
│       │       │                                              │
│       │       └── syncProvider (StateNotifier)              │
│       │                                                      │
│       ├── pullRequestsProvider (FutureProvider)             │
│       │       │                                              │
│       │       └── selectedRepositoryProvider (filter)       │
│       │                                                      │
│       ├── issuesProvider (FutureProvider)                   │
│       │                                                      │
│       ├── notificationsProvider (FutureProvider)            │
│       │       │                                              │
│       │       └── unreadCountProvider                       │
│       │                                                      │
│       └── preferencesProvider (theme)                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Navigation (GoRouter)

```
/login              → LoginScreen (unauthenticated)
                         │
                         ▼ (on login success)
┌────────────────────────────────────────────────────┐
│                  MainScaffold                      │
│  ┌──────────────────────────────────────────────┐ │
│  │              Bottom Navigation               │ │
│  │  [Repos] [Activity] [Notifications] [Settings]│ │
│  └──────────────────────────────────────────────┘ │
├────────────────────────────────────────────────────┤
│ /repositories     → RepositoriesScreen            │
│ /repositories/add → AddRepositoryScreen           │
│ /activity         → ActivityScreen                │
│ /notifications    → NotificationsScreen           │
│ /settings         → SettingsScreen                │
└────────────────────────────────────────────────────┘
```

## Data Flow

### Sync Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Server    │    │   GitHub    │    │  Database   │
│ SyncService │    │    API      │    │ PostgreSQL  │
└──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                  │
       │  GET /repos/:owner/:repo/pulls     │
       │─────────────────▶│                  │
       │  [PR1, PR2, ...]│                  │
       │◀─────────────────│                  │
       │                  │                  │
       │  Upsert PRs                         │
       │────────────────────────────────────▶│
       │                  │                  │
       │  GET /repos/:owner/:repo/issues    │
       │─────────────────▶│                  │
       │  [Issue1, ...]  │                  │
       │◀─────────────────│                  │
       │                  │                  │
       │  Upsert Issues                      │
       │────────────────────────────────────▶│
       │                  │                  │
       │  Create notifications for new items │
       │────────────────────────────────────▶│
```

### Client Refresh Flow

```
User taps "Sync" button
        │
        ▼
syncProvider.sync()
        │
        ▼
client.repository.syncRepositories()
        │
        ▼
Server syncs all user repos from GitHub
        │
        ▼
Returns SyncResult[]
        │
        ▼
ref.invalidate(repositoriesProvider)
ref.invalidate(pullRequestsProvider)
ref.invalidate(issuesProvider)
        │
        ▼
UI rebuilds with fresh data
```

## Database Schema

See [DATABASE.md](DATABASE.md) for complete schema and DBML.

**Entity Relationships:**
```
User (1) ─────────────── (1) UserPreferences
  │
  │ (1:N)
  ▼
Repository
  │
  ├─── (1:N) ──▶ PullRequest
  │
  ├─── (1:N) ──▶ Issue
  │
  └─── (1:N) ──▶ Notification
```

## Security

### PAT Storage
- GitHub PATs encrypted with AES-256 before database storage
- Encryption key stored in server config (not in code)
- PATs never sent to client

### Session Tokens
- Format: `base64(userId:timestamp)`
- Validated on every authenticated request
- Decoded by custom auth handler

### API Security
- All endpoints require authentication (except login)
- User can only access their own data
- Repository ownership verified before operations

## Deployment

### Serverpod Cloud

```
┌────────────────────────────────────────┐
│           Serverpod Cloud              │
│  ┌──────────────────────────────────┐  │
│  │     gitradar.api.serverpod.space │  │
│  │                                   │  │
│  │  ┌─────────────┐ ┌─────────────┐ │  │
│  │  │   Server    │ │  PostgreSQL │ │  │
│  │  │  Container  │ │   Managed   │ │  │
│  │  └─────────────┘ └─────────────┘ │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

**Deployment Command:**
```bash
dart pub global run serverpod_cloud_cli deploy
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `ENCRYPTION_KEY` | AES-256 key for PAT encryption |
| `ONESIGNAL_APP_ID` | OneSignal application ID |
| `ONESIGNAL_API_KEY` | OneSignal REST API key |

## Performance Considerations

### Rate Limiting
- GitHub API: 5000 req/hr (authenticated), 60 req/hr (anonymous)
- Sync limited to 2 pages per API call (max 100 items)
- Exponential backoff on 403/429 responses

### Database Limits
- Max 10 repositories per user
- Max 50 PRs per repository
- Max 50 Issues per repository
- Older items pruned on sync

### Caching
- Serverpod client handles connection pooling
- No additional client-side cache (data from server is source of truth)
