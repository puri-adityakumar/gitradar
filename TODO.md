# GitRadar - Development Tasks

## Phase 0: Server Setup (DONE)
- [x] **T0.1** Initialize monorepo structure
- [x] **T0.2** Create Serverpod project in `/server`
- [x] **T0.3** Set up local PostgreSQL with Docker
  - **Config:** PostgreSQL runs on port **5433** (to avoid conflicts with other projects)
- [x] **T0.4** Verify server starts and connects to database
  - **Note:** Requires `dart pub get` and packages: flutter, docker, serverpod_cli
  - Run `./scripts/setup.sh` once prerequisites are installed
- [x] **T0.5** Create development scripts in root (start db, start server)

## Phase 1: Database Models (DONE)
- [x] **T1.1** Create `User` model (GitHub PAT-based auth, optional):
  - `githubId?`, `githubUsername?`, `displayName?`, `avatarUrl?`
  - `encryptedPat?` (scope=serverOnly), `deviceId?`, `isAnonymous`
  - `onesignalPlayerId?`, `lastValidatedAt?`
  - Unique constraints on `githubId`, `githubUsername`, `deviceId`
- [x] **T1.2** Create `Repository` model:
  - `userId`, `owner`, `repo`, `githubRepoId`
  - `inAppNotifications`, `pushNotifications`, `notificationLevel`
  - `lastSyncedAt`, `lastPrCursor`, `lastIssueCursor`
  - Unique constraint on `(userId, owner, repo)`
- [x] **T1.3** Create `PullRequest` model:
  - Include `githubId`, unique `(repositoryId, number)`
  - `isRead` flag
- [x] **T1.4** Create `Issue` model (similar to PR, with `labelsJson`)
- [x] **T1.5** Create `Notification` model
- [x] **T1.6** Create `UserPreferences` model (theme only for MVP)
- [x] **T1.7** Run `serverpod generate` and apply migrations
  - **Note:** Code generated. Migrations pending (need API fixes first).
  - Created `gitradar_client/` package for Serverpod client generation
  - Created `server/config/generator.yaml` for Serverpod 3 config

## Phase 2: Backend Endpoints (DONE)
- [x] **T2.1** `AuthEndpoint` (GitHub PAT optional):
  - `login(githubPat)` - validate PAT, create/update user, return session
  - `loginAnonymous(deviceId)` - create anonymous user (public repos only)
  - `upgradeWithPat(githubPat)` - convert anonymous to authenticated
  - `validateSession()` - refresh user data from GitHub
  - `logout()` - invalidate session
  - `registerPushToken(onesignalPlayerId)` - for push notifications
  - `hasPat()` - check if user has PAT
- [x] **T2.2** `RepositoryEndpoint`:
  - `addRepository(owner, repo)` - validates via GitHub API, max 10 repos
  - `listRepositories()`
  - `removeRepository(id)` - cascades delete to PRs/Issues/Notifications
  - `updateNotificationSettings(id, inApp, push, level)`
  - `checkRepositoryAccess(owner, repo)` - verify repo access
  - **Note:** Anonymous users can only add public repos (rate limit: 60/hr)
- [x] **T2.3** `ActivityEndpoint`:
  - `listPullRequests(filter, cursor)` - cursor-based pagination
  - `listIssues(filter, cursor)` - cursor-based pagination
  - `markAsRead(type, id)`
  - `getCounts()` - returns ActivityCounts
- [x] **T2.4** `NotificationEndpoint`:
  - `listNotifications(cursor)` - cursor-based pagination
  - `markRead(id)`
  - `markAllRead()`
  - `getUnreadCount()`
- [x] **T2.5** `PreferencesEndpoint`:
  - `getPreferences()` - auto-creates defaults
  - `updatePreferences(theme)`
- [x] **T2.6** Helper models created:
  - `AuthResponse`, `PaginatedPullRequests`, `PaginatedIssues`, `PaginatedNotifications`
  - `ActivityCounts`, `PullRequestFilter`, `IssueFilter`

## Phase 3: GitHub Sync Service (DONE)
- [x] **T3.1** Create `GitHubApiService` - wrapper for GitHub REST API
- [x] **T3.2** Implement PR fetching with pagination
- [x] **T3.3** Implement Issue fetching with pagination
- [x] **T3.4** Create sync cursor logic (incremental updates)
- [x] **T3.5** Implement rate limit handling with backoff
- [x] **T3.6** Create `NotificationService` to generate in-app notifications
- [x] **T3.7** Create `OneSignalService` for push notifications (per-repo settings)
- [x] **T3.8** Set up Serverpod scheduled task for periodic sync
  - **Note:** Run `serverpod generate` to generate SyncResult model code

## Phase 3.5: Serverpod 3.2.3 API Compatibility Fixes (DONE)

> Code was updated to work with Serverpod 3.2.3 breaking API changes.

- [x] **T3.5.1** Fix `session.auth.userId` references (15+ occurrences)
  - Created `SessionUtil` helper using `session.authenticated?.userIdentifier`
  - Files: all endpoints now import and use `SessionUtil`
- [x] **T3.5.2** Fix `.lessThan()` method calls on columns
  - Changed to `<` operator: `t.id < cursor`
  - Files: `activity_endpoint.dart`, `notification_endpoint.dart`
- [x] **T3.5.3** Fix `FutureCall<void>` type constraint
  - Changed to `FutureCall<SyncResult>` with nullable parameter
  - File: `repository_sync_call.dart`
- [x] **T3.5.4** Fix `session.futureCallWithDelay()` method
  - Changed to `session.serverpod.futureCallWithDelay()` (deprecated but works)
  - Files: `repository_sync_call.dart`, `bin/main.dart`
- [x] **T3.5.5** Fix `OneSignalService` static access error
  - Replaced `Session.log` with simple `print()` for stub
  - File: `onesignal_service.dart`
- [x] **T3.5.6** Fix null safety issue in `NotificationService`
  - Added `!` operator after null check
  - File: `notification_service.dart`

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
