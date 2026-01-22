# GitRadar - Development Tasks

## Phase 0: Server Setup
- [ ] **T0.1** Initialize monorepo structure
- [ ] **T0.2** Create Serverpod project in `/server`
- [ ] **T0.3** Set up local PostgreSQL with Docker
- [ ] **T0.4** Verify server starts and connects to database
- [ ] **T0.5** Create development scripts in root (start db, start server)

## Phase 1: Database Models
- [ ] **T1.1** Create `User` model (GitHub PAT-based auth):
  - `githubId`, `githubUsername`, `displayName`, `avatarUrl`
  - `encryptedPat`, `onesignalPlayerId`, `lastValidatedAt`
  - Unique constraint on `githubId`
- [ ] **T1.2** Create `Repository` model:
  - `userId`, `owner`, `repo`, `githubRepoId`
  - `inAppNotifications`, `pushNotifications`, `notificationLevel`
  - `lastSyncedAt`, `lastPrCursor`, `lastIssueCursor`
  - Unique constraint on `(userId, owner, repo)`
- [ ] **T1.3** Create `PullRequest` model:
  - Include `githubId`, unique `(repositoryId, number)`
  - `isRead` flag
- [ ] **T1.4** Create `Issue` model (similar to PR)
- [ ] **T1.5** Create `Notification` model
- [ ] **T1.6** Create `UserPreferences` model (theme only for MVP)
- [ ] **T1.7** Run `serverpod generate` and apply migrations

## Phase 2: Backend Endpoints
- [ ] **T2.1** `AuthEndpoint` (GitHub PAT-based):
  - `login(githubPat)` - validate PAT, create/update user, return session
  - `validateSession()` - refresh user data from GitHub
  - `logout()` - invalidate session
  - `registerPushToken(onesignalPlayerId)` - for push notifications
- [ ] **T2.2** `RepositoryEndpoint`:
  - `addRepository(owner, repo)`
  - `listRepositories()`
  - `removeRepository(id)`
  - `updateNotificationSettings(id, inApp, push, level)`
- [ ] **T2.3** `ActivityEndpoint`:
  - `listPullRequests(filter, cursor)`
  - `listIssues(filter, cursor)`
  - `markAsRead(type, id)`
- [ ] **T2.4** `NotificationEndpoint`:
  - `listNotifications(cursor)`
  - `markRead(id)`
  - `markAllRead()`
  - `getUnreadCount()`
- [ ] **T2.5** `PreferencesEndpoint`:
  - `getPreferences()`
  - `updatePreferences(theme)`

## Phase 3: GitHub Sync Service
- [ ] **T3.1** Create `GitHubApiService` - wrapper for GitHub REST API
- [ ] **T3.2** Implement PR fetching with pagination
- [ ] **T3.3** Implement Issue fetching with pagination
- [ ] **T3.4** Create sync cursor logic (incremental updates)
- [ ] **T3.5** Implement rate limit handling with backoff
- [ ] **T3.6** Create `NotificationService` to generate in-app notifications
- [ ] **T3.7** Create `OneSignalService` for push notifications (per-repo settings)
- [ ] **T3.8** Set up Serverpod scheduled task for periodic sync

## Phase 4: Backend Testing (Local)
- [ ] **T4.1** Test `AuthEndpoint` - login with valid/invalid PAT
- [ ] **T4.2** Test `RepositoryEndpoint` - CRUD operations
- [ ] **T4.3** Test `ActivityEndpoint` - list PRs/Issues, mark as read
- [ ] **T4.4** Test `NotificationEndpoint` - list, mark read
- [ ] **T4.5** Test GitHub sync manually - verify data populates
- [ ] **T4.6** Test error handling - rate limits, invalid repos, network errors
- [ ] **T4.7** Write unit tests for critical services

## Phase 5: Deploy Serverpod
- [ ] **T5.1** Set up Serverpod Cloud account (or self-hosted)
- [ ] **T5.2** Configure production environment variables
- [ ] **T5.3** Deploy server to Serverpod Cloud
- [ ] **T5.4** Run migrations on production database
- [ ] **T5.5** Verify all endpoints work in production
- [ ] **T5.6** Test GitHub sync in production environment

## Phase 6: Flutter App Setup
- [ ] **T6.1** Create Flutter project in `/app`
- [ ] **T6.2** Configure Serverpod client generation
- [ ] **T6.3** Set up app structure with Riverpod
- [ ] **T6.4** Configure Serverpod client connection (local + production)
- [ ] **T6.5** Implement theme system (light/dark)
- [ ] **T6.6** Create common widgets (cards, loading states, error states)
- [ ] **T6.7** Set up routing

## Phase 7: Flutter App Screens
- [ ] **T7.1** Login screen (PAT-based):
  - PAT input field
  - "Connect with GitHub" button
  - Validation feedback
- [ ] **T7.2** Repository list screen:
  - Add repo button
  - Repo cards with notification status (in-app/push icons)
  - Swipe to delete
  - Per-repo notification settings modal
- [ ] **T7.3** Activity screen:
  - Tabs: PRs | Issues
  - Filter chips (Open/Closed)
  - Tap to open in GitHub
- [ ] **T7.4** Notifications screen:
  - Notification list
  - Mark read/unread
  - Tap to navigate
- [ ] **T7.5** Settings screen:
  - User profile (from GitHub)
  - Theme toggle
  - Update PAT / Logout

## Phase 8: Integration Testing & Polish
- [ ] **T8.1** End-to-end testing: Login → Add repo → View PRs → Notifications
- [ ] **T8.2** Test on web (Chrome)
- [ ] **T8.3** Test on iOS Simulator
- [ ] **T8.4** Test on Android device (optional)
- [ ] **T8.5** Add empty states for all lists
- [ ] **T8.6** Add pull-to-refresh everywhere
- [ ] **T8.7** Handle error states gracefully
- [ ] **T8.8** Create demo seed data script
- [ ] **T8.9** Write README with setup instructions
- [ ] **T8.10** Record demo video / screenshots

---

## Task Sizing Guide
- **S**: < 1 hour
- **M**: 1-3 hours
- **L**: 3-6 hours
- **XL**: 6+ hours (should be broken down)

## Development Flow Summary
```
Setup → Models → Endpoints → Services → Test Backend → Deploy → Flutter → Screens → Integration Test
```
