# GitRadar - Development Tasks

## Phase 0: Project Setup
- [ ] **T0.1** Initialize monorepo structure
- [ ] **T0.2** Create Serverpod project in `/server`
- [ ] **T0.3** Create Flutter project in `/app`
- [ ] **T0.4** Configure Serverpod client generation
- [ ] **T0.5** Set up local PostgreSQL or Serverpod Cloud connection
- [ ] **T0.6** Create development scripts in root

## Phase 1: Authentication & Core Models
- [ ] **T1.1** Set up Serverpod auth module (email/password)
- [ ] **T1.2** Create `GithubCredential` model (encrypted PAT storage)
- [ ] **T1.3** Create `Repository` model with proper fields:
  - `userId`, `owner`, `repo`, `githubRepoId`
  - `notificationLevel`, `lastSyncedAt`
  - Unique constraint on `(userId, owner, repo)`
- [ ] **T1.4** Create `PullRequest` model:
  - Include `githubId`, unique `(repositoryId, number)`
  - `isRead` flag
- [ ] **T1.5** Create `Issue` model (similar to PR)
- [ ] **T1.6** Create `Notification` model
- [ ] **T1.7** Create `UserPreferences` model (theme only for MVP)
- [ ] **T1.8** Run migrations

## Phase 2: Backend Endpoints
- [ ] **T2.1** `AuthEndpoint` - login/logout/register (Serverpod auth)
- [ ] **T2.2** `CredentialEndpoint` - save/validate/delete GitHub PAT
- [ ] **T2.3** `RepositoryEndpoint`:
  - `addRepository(owner, repo)`
  - `listRepositories()`
  - `removeRepository(id)`
  - `updateSettings(id, notificationLevel)`
- [ ] **T2.4** `ActivityEndpoint`:
  - `listPullRequests(filter, cursor)`
  - `listIssues(filter, cursor)`
  - `markAsRead(type, id)`
- [ ] **T2.5** `NotificationEndpoint`:
  - `listNotifications(cursor)`
  - `markRead(id)`
  - `markAllRead()`
  - `getUnreadCount()`
- [ ] **T2.6** `PreferencesEndpoint`:
  - `getPreferences()`
  - `updatePreferences(theme)`

## Phase 3: GitHub Sync Service
- [ ] **T3.1** Create `GitHubApiService` - wrapper for GitHub REST API
- [ ] **T3.2** Implement PR fetching with pagination
- [ ] **T3.3** Implement Issue fetching with pagination
- [ ] **T3.4** Create sync cursor logic (incremental updates)
- [ ] **T3.5** Implement rate limit handling with backoff
- [ ] **T3.6** Create `NotificationService` to generate in-app notifications
- [ ] **T3.7** Set up Serverpod scheduled task for periodic sync

## Phase 4: Flutter App - Core
- [ ] **T4.1** Set up app structure with Riverpod
- [ ] **T4.2** Configure Serverpod client
- [ ] **T4.3** Implement theme system (light/dark)
- [ ] **T4.4** Create common widgets (cards, loading states, error states)
- [ ] **T4.5** Set up routing

## Phase 5: Flutter App - Screens
- [ ] **T5.1** Login/Register screen
- [ ] **T5.2** Repository list screen
  - Add repo button
  - Repo cards with stats
  - Swipe to delete
- [ ] **T5.3** Activity screen
  - Tabs: PRs | Issues
  - Filter chips (Open/Closed)
  - Tap to open in GitHub
- [ ] **T5.4** Notifications screen
  - Notification list
  - Mark read/unread
  - Tap to navigate
- [ ] **T5.5** Settings screen
  - GitHub PAT configuration
  - Theme toggle
  - Logout

## Phase 6: Polish & Demo
- [ ] **T6.1** Add empty states for all lists
- [ ] **T6.2** Add pull-to-refresh everywhere
- [ ] **T6.3** Handle error states gracefully
- [ ] **T6.4** Create demo seed data script
- [ ] **T6.5** Write README with setup instructions
- [ ] **T6.6** Record demo video / screenshots

---

## Task Sizing Guide
- **S**: < 1 hour
- **M**: 1-3 hours  
- **L**: 3-6 hours
- **XL**: 6+ hours (should be broken down)

## Parallelization Notes
These tasks can run in parallel:
- T1.3-T1.7 (models) after T1.1-T1.2
- T2.3-T2.6 (endpoints) after models complete
- T4.x (Flutter setup) while backend develops
- T5.1-T5.5 (screens) can be parallelized after T4.x
