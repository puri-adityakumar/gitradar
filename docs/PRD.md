# GitRadar - Product Requirements Document

## Executive Summary

**Product Name:** GitRadar  
**Version:** 1.0.0  
**Type:** Developer Productivity Tool  
**Platform:** Cross-platform (Flutter Web, iOS, Android)  
**Target:** Serverpod 3 Global Hackathon Submission

### Vision Statement
GitRadar is a minimalist GitHub monitoring platform that provides developers with near real-time notifications and unified tracking of pull requests, issues, and repository activity across multiple projects.

### Value Proposition
Never miss critical repository updates. GitRadar delivers a clean, distraction-free command center for GitHub activity, eliminating notification overload while ensuring developers stay informed about what matters.

---

## MVP Scope (Hackathon Submission)

> **Important:** This section defines what will be built for the hackathon. Features outside this scope are deferred to post-hackathon phases.

### In Scope ✅
- **Authentication:** Serverpod auth (email/password registration)
- **GitHub Integration:** Personal Access Token (PAT) input, stored server-side encrypted
- **Repository Management:** Add/list/remove repos (max 10 per user)
- **Sync:** Periodic polling every 5-10 minutes via Serverpod scheduler
- **Data Limits:** Store last 50 PRs and 50 Issues per repository
- **Notifications:** In-app only, with mark read/unread
- **UI Screens:** 4 total - Login, Repositories, Activity, Settings
- **Theme:** Light/Dark mode toggle

### Out of Scope ❌ (Post-MVP)
- GitHub OAuth flow (use PAT for MVP)
- Webhooks for real-time updates
- Push notifications (FCM)
- Digest mode / smart filtering
- Full PR/Issue detail screens (link to GitHub instead)
- Comments fetching and display
- AI summarization
- Multi-user/team features
- Desktop/Email notifications

### Product Limits (MVP)
| Limit | Value |
|-------|-------|
| Max repos per user | 10 |
| Max PRs stored per repo | 50 |
| Max Issues stored per repo | 50 |
| Sync interval | 5-10 minutes |
| Rate limit strategy | Exponential backoff on 403/429 |

---

## Product Overview

### Problem Statement
Developers managing multiple GitHub repositories face three core challenges:

1. **Notification Overload**: GitHub's native notifications are overwhelming and difficult to filter
2. **Missed Updates**: Critical pull request comments and issue updates get lost in noise
3. **Context Switching**: Constantly checking multiple repositories disrupts workflow

### Solution
GitRadar provides a unified, intelligent monitoring layer with:

- Selective repository watching with granular notification controls
- Real-time activity tracking across all monitored repositories
- Clean, minimalist interface focused on actionable information
- Smart filtering to surface high-priority updates

### Success Metrics

**Primary Metrics:**
- Time saved checking repository status (target: 60% reduction)
- Critical updates response time (target: 80% improvement)
- User satisfaction with notification relevance (target: 90%)

**Secondary Metrics:**
- Number of repositories actively monitored per user
- Daily active usage rate
- Notification accuracy (relevant vs total notifications)

---

## Technical Architecture

### Technology Stack

**Frontend:**
- Framework: Flutter 3.x
- Language: Dart
- UI Library: Material Design 3
- State Management: Provider / Riverpod
- HTTP Client: Serverpod Client SDK

**Backend:**
- Framework: Serverpod 3.x
- Language: Dart
- Database: PostgreSQL (Serverpod Cloud managed)
- ORM: Serverpod native ORM
- Scheduled Jobs: Serverpod built-in scheduler

**External Integration:**
- GitHub REST API v3
- Optional: GitHub Webhooks for real-time events
- Optional: Firebase Cloud Messaging for push notifications

**Deployment:**
- Backend: Serverpod Cloud
- Frontend Web: Netlify / Vercel
- Mobile: APK distribution for demo

### System Architecture

```
┌─────────────────────────────────────────┐
│         Flutter Application             │
│  ┌───────────┐      ┌────────────────┐  │
│  │    UI     │◄────►│ Serverpod      │  │
│  │  Layer    │      │ Client SDK     │  │
│  └───────────┘      └────────────────┘  │
└──────────────────────┬──────────────────┘
                       │ HTTPS
┌──────────────────────▼──────────────────┐
│      Serverpod Backend Server           │
│  ┌──────────────────────────────────┐   │
│  │      API Endpoints Layer         │   │
│  │  • Repository Management         │   │
│  │  • Pull Request Tracking         │   │
│  │  • Notification Management       │   │
│  └───────────┬──────────────────────┘   │
│              │                           │
│  ┌───────────▼──────────────────────┐   │
│  │    Business Logic Layer          │   │
│  │  • GitHub API Integration        │   │
│  │  • Activity Monitoring           │   │
│  │  • Notification Engine           │   │
│  └───────────┬──────────────────────┘   │
│              │                           │
│  ┌───────────▼──────────────────────┐   │
│  │      Data Access Layer           │   │
│  │  • Serverpod ORM                 │   │
│  │  • Database Migrations           │   │
│  └───────────┬──────────────────────┘   │
└──────────────┼───────────────────────────┘
               │
┌──────────────▼───────────────────────────┐
│       PostgreSQL Database                │
│  • repositories                          │
│  • pull_requests                         │
│  • issues                                │
│  • notifications                         │
│  • user_preferences                      │
└──────────────────────────────────────────┘
               ▲
               │
┌──────────────┴───────────────────────────┐
│         GitHub REST API                  │
│  api.github.com                          │
└──────────────────────────────────────────┘
```

### Data Models

> **Authentication:** Uses Serverpod's built-in auth module. User model is managed by `serverpod_auth`.

**GithubCredential** (separate from preferences for security)
```yaml
class: GithubCredential
table: github_credentials
fields:
  id: int (primary key)
  userId: int (foreign key, unique)
  encryptedToken: String         # AES-256 encrypted, server-side only
  tokenScopes: String?           # Comma-separated scopes
  lastValidatedAt: DateTime?
  createdAt: DateTime
  updatedAt: DateTime
indexes:
  idx_user:
    fields: userId
    unique: true
```

**Repository**
```yaml
class: Repository
table: repositories
fields:
  id: int (primary key)
  userId: int (foreign key)
  owner: String                  # GitHub owner (user or org)
  repo: String                   # GitHub repo name
  githubRepoId: int              # GitHub's stable ID (survives renames)
  isPrivate: bool
  notificationLevel: String (all|mentions|none)
  lastSyncedAt: DateTime?
  lastPrCursor: DateTime?        # For incremental sync
  lastIssueCursor: DateTime?     # For incremental sync
  createdAt: DateTime
  updatedAt: DateTime
indexes:
  idx_user_repo:
    fields: userId, owner, repo
    unique: true
  idx_github_id:
    fields: githubRepoId
```

**PullRequest**
```yaml
class: PullRequest
table: pull_requests
fields:
  id: int (primary key)
  repositoryId: int (foreign key)
  githubId: int                  # GitHub's stable PR ID
  number: int                    # PR number (e.g., #123)
  title: String
  body: String?
  author: String
  state: String (open|closed|merged)
  htmlUrl: String
  githubCreatedAt: DateTime      # When GitHub created it
  githubUpdatedAt: DateTime      # When GitHub last updated it
  createdAt: DateTime            # When we stored it
  updatedAt: DateTime
  isRead: bool
indexes:
  idx_repo_number:
    fields: repositoryId, number
    unique: true
  idx_repo_state:
    fields: repositoryId, state
  idx_unread:
    fields: repositoryId, isRead
```

**Issue**
```yaml
class: Issue
table: issues
fields:
  id: int (primary key)
  repositoryId: int (foreign key)
  githubId: int                  # GitHub's stable Issue ID
  number: int                    # Issue number
  title: String
  body: String?
  author: String
  state: String (open|closed)
  labelsJson: String?            # JSON array of label names (MVP simplicity)
  htmlUrl: String
  githubCreatedAt: DateTime
  githubUpdatedAt: DateTime
  createdAt: DateTime
  updatedAt: DateTime
  isRead: bool
indexes:
  idx_repo_number:
    fields: repositoryId, number
    unique: true
  idx_repo_state:
    fields: repositoryId, state
  idx_unread:
    fields: repositoryId, isRead
```

**Notification**
```yaml
class: Notification
table: notifications
fields:
  id: int (primary key)
  userId: int (foreign key)
  type: String (pr_opened|pr_updated|issue_opened|issue_updated)
  title: String
  message: String
  repositoryId: int (foreign key)
  pullRequestId: int? (foreign key, nullable)  # Direct FK instead of polymorphic
  issueId: int? (foreign key, nullable)        # Direct FK instead of polymorphic
  isRead: bool
  createdAt: DateTime
indexes:
  idx_user_unread:
    fields: userId, isRead
  idx_user_created:
    fields: userId, createdAt
```

**UserPreferences** (no secrets here)
```yaml
class: UserPreferences
table: user_preferences
fields:
  id: int (primary key)
  userId: int (foreign key, unique)
  themeMode: String (light|dark|system)
  createdAt: DateTime
  updatedAt: DateTime
indexes:
  idx_user:
    fields: userId
    unique: true
```

### Serverpod RPC Endpoints Specification

> **Note:** Serverpod uses RPC-style endpoints, not REST. Each endpoint is a Dart class with async methods.

**RepositoryEndpoint**
```dart
class RepositoryEndpoint extends Endpoint {
  Future<Repository> addRepository(Session session, String owner, String repo) async;
  Future<List<Repository>> listRepositories(Session session) async;
  Future<void> removeRepository(Session session, int repositoryId) async;
  Future<Repository> updateSettings(Session session, int repositoryId, String notificationLevel) async;
}
```

**ActivityEndpoint**
```dart
class ActivityEndpoint extends Endpoint {
  Future<PaginatedResult<PullRequest>> listPullRequests(Session session, PullRequestFilter? filter, String? cursor) async;
  Future<PaginatedResult<Issue>> listIssues(Session session, IssueFilter? filter, String? cursor) async;
  Future<void> markAsRead(Session session, String entityType, int entityId) async;
  Future<ActivityCounts> getCounts(Session session) async;
}
```

**NotificationEndpoint**
```dart
class NotificationEndpoint extends Endpoint {
  Future<PaginatedResult<Notification>> listNotifications(Session session, String? cursor) async;
  Future<void> markRead(Session session, int notificationId) async;
  Future<void> markAllRead(Session session) async;
  Future<int> getUnreadCount(Session session) async;
}
```

**CredentialEndpoint**
```dart
class CredentialEndpoint extends Endpoint {
  Future<bool> saveGitHubToken(Session session, String token) async;
  Future<bool> validateGitHubToken(Session session) async;
  Future<void> deleteGitHubToken(Session session) async;
  Future<bool> hasGitHubToken(Session session) async;
}
```

**PreferencesEndpoint**
```dart
class PreferencesEndpoint extends Endpoint {
  Future<UserPreferences> getPreferences(Session session) async;
  Future<UserPreferences> updatePreferences(Session session, UserPreferencesUpdate update) async;
}
```

### Background Jobs

**GitHub Sync Job**
- Frequency: Every 5 minutes
- Actions:
  - Fetch latest PRs from all watched repositories
  - Fetch latest issues from all watched repositories
  - Detect new comments on existing PRs/issues
  - Generate notifications for new activity
  - Update last sync timestamp

**Notification Digest Job**
- Frequency: Configurable (hourly/daily)
- Actions:
  - Aggregate unread notifications
  - Generate digest summary
  - Send consolidated notification
  - Mark digest as sent

**Cleanup Job**
- Frequency: Daily at 02:00 UTC
- Actions:
  - Archive read notifications older than 30 days
  - Remove closed PRs/issues older than 90 days
  - Optimize database indexes

---

## Design System

### Visual Identity

**Brand Principles:**
- Minimalist: Remove all non-essential elements
- Professional: Clean, technical aesthetic
- Functional: Form follows function
- Accessible: WCAG 2.1 AA compliant

**Typography:**
- Primary Font: Roboto (Material Design default)
- Monospace Font: Roboto Mono (for code/repo names)
- Font Scales:
  - H1: 32px, Medium (600)
  - H2: 24px, Medium (600)
  - H3: 20px, Medium (600)
  - Body: 16px, Regular (400)
  - Caption: 14px, Regular (400)
  - Overline: 12px, Medium (600)

**Spacing System:**
- Base unit: 8px
- Scale: 4px, 8px, 16px, 24px, 32px, 48px, 64px

### Color Palette

**Light Mode**

Primary Colors:
- Background: #FFFFFF
- Surface: #F5F5F5
- Surface Variant: #E8E8E8

Text Colors:
- Primary Text: #212121
- Secondary Text: #757575
- Disabled Text: #BDBDBD

Accent Colors:
- Primary Action: #1976D2 (Material Blue 700)
- Secondary Action: #424242 (Material Grey 800)
- Error: #D32F2F (Material Red 700)
- Success: #388E3C (Material Green 700)
- Warning: #F57C00 (Material Orange 700)

Status Indicators:
- PR Open: #388E3C (Green)
- PR Merged: #7B1FA2 (Purple)
- PR Closed: #757575 (Grey)
- Issue Open: #1976D2 (Blue)
- Issue Closed: #757575 (Grey)

**Dark Mode**

Primary Colors:
- Background: #121212
- Surface: #1E1E1E
- Surface Variant: #2C2C2C

Text Colors:
- Primary Text: #FFFFFF
- Secondary Text: #B0B0B0
- Disabled Text: #6B6B6B

Accent Colors:
- Primary Action: #64B5F6 (Material Blue 300)
- Secondary Action: #E0E0E0 (Material Grey 300)
- Error: #EF5350 (Material Red 400)
- Success: #66BB6A (Material Green 400)
- Warning: #FFA726 (Material Orange 400)

Status Indicators:
- PR Open: #66BB6A (Green)
- PR Merged: #BA68C8 (Purple)
- PR Closed: #B0B0B0 (Grey)
- Issue Open: #64B5F6 (Blue)
- Issue Closed: #B0B0B0 (Grey)

### Component Library

**Cards**
```
Elevation: 1dp (light), 2dp (dark)
Border Radius: 8px
Padding: 16px
Margin: 8px vertical, 16px horizontal
```

**Buttons**
```
Primary:
  - Background: Primary Action color
  - Text: White
  - Height: 40px
  - Border Radius: 4px
  - Padding: 16px horizontal

Secondary:
  - Background: Transparent
  - Border: 1px solid Primary Action
  - Text: Primary Action color
  - Height: 40px
  - Border Radius: 4px
  - Padding: 16px horizontal

Text:
  - Background: Transparent
  - Text: Primary Action color
  - No border
```

**Input Fields**
```
Height: 56px
Border: 1px solid (Secondary Text in light, #3C3C3C in dark)
Border Radius: 4px
Padding: 16px
Focus Border: 2px solid Primary Action
Error Border: 2px solid Error color
```

**List Items**
```
Height: Minimum 64px
Padding: 16px
Divider: 1px solid Surface Variant
Leading Icon Size: 24px
Trailing Icon Size: 20px
```

**Chips/Tags**
```
Height: 32px
Border Radius: 16px
Padding: 12px horizontal
Background: Surface Variant
Text: Primary Text
Border: None
```

**Navigation Bar**
```
Height: 64px (mobile), 72px (desktop)
Elevation: 4dp
Background: Surface
Items: Icon + Label
Active Indicator: Primary Action color underline (4px)
```

### Layout Grid

**Mobile (< 600px)**
- Columns: 4
- Margin: 16px
- Gutter: 16px

**Tablet (600px - 1240px)**
- Columns: 8
- Margin: 24px
- Gutter: 24px

**Desktop (> 1240px)**
- Columns: 12
- Margin: 24px
- Gutter: 24px
- Max Width: 1440px (centered)

### Iconography

**Icon Set:** Material Icons (outlined variant)

**Commonly Used Icons:**
- Repository: folder_outlined
- Pull Request: call_merge
- Issue: error_outline
- Comment: chat_bubble_outline
- Notification: notifications_outlined
- Settings: settings_outlined
- Search: search
- Filter: filter_list
- Mark Read: check_circle_outline
- Open External: open_in_new
- Refresh: refresh
- Add: add_circle_outline
- Delete: delete_outline
- Menu: menu
- Close: close

**Icon Sizes:**
- Small: 16px
- Medium: 24px (default)
- Large: 32px

### Animation & Transitions

**Principles:**
- Subtle and functional
- Duration: 200-300ms
- Easing: Material standard curve

**Common Transitions:**
- Screen transitions: Slide (300ms)
- Card expand/collapse: Scale + Fade (250ms)
- Button press: Scale (100ms)
- Notification appear: Slide from top (200ms)
- List item reveal: Fade in (150ms)

---

## Feature Specification

### MVP Feature Set

#### 1. Repository Management

**1.1 Add Repository**

User Story: As a developer, I want to add GitHub repositories to my watchlist so that I can monitor their activity.

Acceptance Criteria:
- User can enter repository URL or owner/repo format
- System validates repository exists on GitHub
- System checks if repository is already being watched
- Repository is saved with default notification settings
- User receives confirmation of successful addition
- Error handling for invalid URLs or non-existent repositories

UI Components:
- Add Repository button (FAB or App Bar action)
- Repository URL input field
- Validation feedback
- Loading indicator during verification
- Success/error snackbar

**1.2 View Watched Repositories**

User Story: As a developer, I want to see all repositories I'm watching so that I can manage my monitoring list.

Acceptance Criteria:
- Display list of all watched repositories
- Show repository name, URL, and last sync time
- Display notification status (enabled/disabled)
- Support pull-to-refresh
- Empty state when no repositories are watched
- Search/filter capabilities

UI Components:
- Repository list view
- Repository card with metadata
- Pull-to-refresh indicator
- Empty state illustration and message
- Search bar

**1.3 Remove Repository**

User Story: As a developer, I want to remove repositories from my watchlist when I no longer need to monitor them.

Acceptance Criteria:
- User can swipe or tap delete on repository
- System shows confirmation dialog
- Associated PRs, issues, and notifications are handled appropriately
- User receives confirmation of deletion

UI Components:
- Swipe-to-delete gesture
- Delete confirmation dialog
- Undo snackbar (optional)

**1.4 Configure Repository Notifications**

User Story: As a developer, I want to customize notification settings per repository to reduce noise.

Acceptance Criteria:
- User can set notification level: All, Mentions Only, None
- Settings persist across sessions
- Changes take effect immediately
- Visual indication of current setting

UI Components:
- Settings icon on repository card
- Settings bottom sheet or dialog
- Radio buttons for notification levels
- Save/Cancel actions

#### 2. Pull Request Monitoring

**2.1 View All Pull Requests**

User Story: As a developer, I want to see all open pull requests across my watched repositories in one place.

Acceptance Criteria:
- Display aggregated list of PRs from all repositories
- Show PR number, title, author, repository, and status
- Support filtering by repository, status, or date
- Support sorting by created date, updated date, or repository
- Show unread indicator for new PRs or PRs with new comments
- Display last comment timestamp
- Infinite scroll or pagination for large lists

UI Components:
- PR list view
- PR card with metadata
- Filter chips
- Sort dropdown
- Unread badge
- Loading skeleton

**2.2 View Pull Request Details**

User Story: As a developer, I want to see detailed information about a pull request including recent comments.

Acceptance Criteria:
- Display full PR title and description
- Show author, creation date, and last update time
- Display current state (open, merged, closed)
- Show recent comments (last 5-10)
- Provide link to view full PR on GitHub
- Mark PR as read when viewed
- Show file change count (if available)

UI Components:
- PR detail screen
- Header with title and metadata
- Description section
- Comments timeline
- "Open in GitHub" button
- Mark as read action

**2.3 PR Notifications**

User Story: As a developer, I want to be notified when new pull requests are opened or when PRs I'm watching receive comments.

Acceptance Criteria:
- Notification created when new PR is opened in watched repository
- Notification created when comment is added to any PR
- Notification respects repository notification settings
- Notification includes PR title, repository, and triggering action
- Tapping notification navigates to PR details
- Notification marked as read when PR is viewed

UI Components:
- Notification card in notification center
- Badge on notification icon
- Toast notification (optional)

#### 3. Issue Tracking

**3.1 View All Issues**

User Story: As a developer, I want to see all open issues across my watched repositories.

Acceptance Criteria:
- Display aggregated list of issues from all repositories
- Show issue number, title, author, repository, and labels
- Support filtering by repository, labels, or status
- Support sorting by created date or updated date
- Show unread indicator for new issues or issues with new comments
- Infinite scroll or pagination

UI Components:
- Issue list view
- Issue card with metadata and labels
- Filter chips
- Sort dropdown
- Unread badge
- Loading skeleton

**3.2 View Issue Details**

User Story: As a developer, I want to see detailed information about an issue including recent comments.

Acceptance Criteria:
- Display full issue title and description
- Show author, creation date, and labels
- Display current state (open, closed)
- Show recent comments
- Provide link to view full issue on GitHub
- Mark issue as read when viewed

UI Components:
- Issue detail screen
- Header with title and metadata
- Label chips
- Description section
- Comments timeline
- "Open in GitHub" button

**3.3 Issue Notifications**

User Story: As a developer, I want to be notified when new issues are created or when issues receive updates.

Acceptance Criteria:
- Notification created when new issue is opened
- Notification created when comment is added to any issue
- Notification respects repository notification settings
- Tapping notification navigates to issue details

UI Components:
- Notification card
- Badge on notification icon

#### 4. Notification Center

**4.1 View All Notifications**

User Story: As a developer, I want to see all my notifications in one centralized location.

Acceptance Criteria:
- Display chronological list of all notifications
- Group notifications by date (Today, Yesterday, This Week, Older)
- Show notification type, title, and timestamp
- Distinguish read from unread notifications
- Support filtering by type or repository
- Support mark all as read action
- Support individual delete action

UI Components:
- Notification list view
- Notification card with icon and metadata
- Group headers
- Filter dropdown
- Mark all read button
- Swipe-to-delete

**4.2 Notification Actions**

User Story: As a developer, I want to quickly act on notifications without leaving the notification center.

Acceptance Criteria:
- Tap notification to navigate to related entity (PR/Issue)
- Swipe to mark as read
- Swipe to delete
- Long press for additional actions
- Bulk selection mode for multi-delete

UI Components:
- Swipe actions
- Long-press menu
- Selection checkboxes
- Bulk action toolbar

#### 5. Activity Dashboard

**5.1 Overview Statistics**

User Story: As a developer, I want to see a summary of activity across all my watched repositories.

Acceptance Criteria:
- Display count of watched repositories
- Show count of open PRs and issues
- Display count of unread notifications
- Show recent activity timeline (last 10 events)
- Display most active repository
- Refreshable data

UI Components:
- Dashboard screen
- Stat cards
- Activity timeline
- Pull-to-refresh

**5.2 Repository Activity View**

User Story: As a developer, I want to see activity breakdown by repository.

Acceptance Criteria:
- Display per-repository statistics
- Show PR and issue counts per repository
- Display last sync time per repository
- Allow tap to filter view by repository

UI Components:
- Repository breakdown cards
- Tap-to-filter interaction

#### 6. User Preferences

**6.1 Theme Selection**

User Story: As a developer, I want to choose between light and dark themes to match my preference.

Acceptance Criteria:
- User can select Light, Dark, or System theme
- Theme persists across app restarts
- Theme change applies immediately without restart
- All screens respect theme setting

UI Components:
- Settings screen
- Theme selector (radio buttons or segmented control)

**6.2 GitHub Token Configuration**

User Story: As a developer, I want to optionally provide my GitHub Personal Access Token to access private repositories.

Acceptance Criteria:
- User can enter and save GitHub PAT
- Token is stored securely (encrypted)
- User can view masked token
- User can delete token
- Token validation on save
- Fallback to public API if no token provided

UI Components:
- PAT input field (obscured)
- Save/Cancel buttons
- Validation feedback
- Delete token button

**6.3 Notification Preferences**

User Story: As a developer, I want to configure global notification settings to control when and how I'm notified.

Acceptance Criteria:
- User can enable/disable notifications globally
- User can set quiet hours (start and end time)
- User can enable digest mode (hourly or daily)
- Settings persist and are respected by notification engine

UI Components:
- Settings toggles
- Time pickers for quiet hours
- Radio buttons for digest frequency

### Future Enhancements (Post-MVP)

**Phase 2 Features:**
- Webhook integration for real-time updates
- PR review status tracking
- Code review comment notifications
- Mention detection and highlighting
- Multi-user/team support
- Advanced filtering (by author, file changes, etc)
- PR merge conflict detection
- Integration with Slack/Discord
- Desktop notifications
- Email digest

**Phase 3 Features:**
- AI-powered PR summarization
- Automated PR triage and prioritization
- Review assignment suggestions
- Code analysis insights
- Productivity analytics
- Custom notification rules engine
- GitHub Actions integration
- CI/CD status monitoring

---

## User Interface Specification

### Screen Layouts

#### Home Screen / Dashboard

**Layout:**
```
┌────────────────────────────────────┐
│  GitRadar              ⚙ 🔔       │ App Bar
├────────────────────────────────────┤
│                                    │
│  ┌──────────────────────────────┐ │
│  │   Watched Repositories: 5    │ │ Stat Cards
│  └──────────────────────────────┘ │
│  ┌──────────────────────────────┐ │
│  │   Open Pull Requests: 12     │ │
│  └──────────────────────────────┘ │
│  ┌──────────────────────────────┐ │
│  │   Open Issues: 7             │ │
│  └──────────────────────────────┘ │
│  ┌──────────────────────────────┐ │
│  │   Unread Notifications: 3    │ │
│  └──────────────────────────────┘ │
│                                    │
│  Recent Activity                   │ Section Header
│  ────────────────────────────────  │
│  ┌──────────────────────────────┐ │
│  │ 🔀 New PR: Fix auth bug      │ │ Activity
│  │    flutter/flutter            │ │ Timeline
│  │    2 hours ago                │ │ Items
│  └──────────────────────────────┘ │
│  ┌──────────────────────────────┐ │
│  │ 💬 Comment on PR #456        │ │
│  │    serverpod/serverpod        │ │
│  │    5 hours ago                │ │
│  └──────────────────────────────┘ │
│                                    │
├────────────────────────────────────┤
│   Home   PRs   Issues   Notify    │ Bottom Nav
└────────────────────────────────────┘
```

#### Repository List Screen

**Layout:**
```
┌────────────────────────────────────┐
│  ← Repositories          + 🔍     │ App Bar
├────────────────────────────────────┤
│                                    │
│  ┌──────────────────────────────┐ │
│  │ 📁 flutter/flutter           │ │ Repo Card 1
│  │    Last synced: 5 min ago    │ │
│  │    PRs: 145  Issues: 2,341   │ │
│  │    🔔 All notifications  ⚙   │ │
│  └──────────────────────────────┘ │
│                                    │
│  ┌──────────────────────────────┐ │
│  │ 📁 serverpod/serverpod       │ │ Repo Card 2
│  │    Last synced: 12 min ago   │ │
│  │    PRs: 3  Issues: 12        │ │
│  │    🔕 Mentions only      ⚙   │ │
│  └──────────────────────────────┘ │
│                                    │
│  ┌──────────────────────────────┐ │
│  │ 📁 user/private-repo         │ │ Repo Card 3
│  │    Last synced: 1 hour ago   │ │
│  │    PRs: 0  Issues: 5         │ │
│  │    🔔 All notifications  ⚙   │ │
│  └──────────────────────────────┘ │
│                                    │
├────────────────────────────────────┤
│   Home   PRs   Issues   Notify    │ Bottom Nav
└────────────────────────────────────┘
```

#### Add Repository Screen

**Layout:**
```
┌────────────────────────────────────┐
│  ← Add Repository              ✓   │ App Bar
├────────────────────────────────────┤
│                                    │
│  Repository URL or owner/repo      │ Label
│  ┌──────────────────────────────┐ │
│  │ https://github.com/...       │ │ Input Field
│  └──────────────────────────────┘ │
│                                    │
│  Notification Settings             │ Section
│  ┌──────────────────────────────┐ │
│  │ ○ All activity               │ │ Radio
│  │ ● Mentions only              │ │ Options
│  │ ○ None (watch only)          │ │
│  └──────────────────────────────┘ │
│                                    │
│         [Add Repository]           │ Action Button
│                                    │
├────────────────────────────────────┤
│   Home   PRs   Issues   Notify    │ Bottom Nav
└────────────────────────────────────┘
```

#### Pull Requests Screen

**Layout:**
```
┌────────────────────────────────────┐
│  Pull Requests           🔍 ⋮     │ App Bar
├────────────────────────────────────┤
│  All  Open  Merged  Closed         │ Filter Chips
│                                    │
│  ┌──────────────────────────────┐ │
│  │ ● #1234                      │ │ PR Card 1
│  │   Fix authentication bug     │ │ (Unread)
│  │   flutter/flutter            │ │
│  │   by @john-dev               │ │
│  │   Opened 2 hours ago         │ │
│  │   [Open]                     │ │
│  └──────────────────────────────┘ │
│                                    │
│  ┌──────────────────────────────┐ │
│  │   #1233                      │ │ PR Card 2
│  │   Add dark mode support      │ │ (Read)
│  │   flutter/flutter            │ │
│  │   by @jane-dev               │ │
│  │   Updated 5 hours ago        │ │
│  │   [Open]                     │ │
│  └──────────────────────────────┘ │
│                                    │
│  ┌──────────────────────────────┐ │
│  │   #1232                      │ │ PR Card 3
│  │   Update documentation       │ │
│  │   serverpod/serverpod        │ │
│  │   by @bob-dev                │ │
│  │   Merged 1 day ago           │ │
│  │   [Merged]                   │ │
│  └──────────────────────────────┘ │
│                                    │
├────────────────────────────────────┤
│   Home   PRs   Issues   Notify    │ Bottom Nav
└────────────────────────────────────┘
```

#### Pull Request Detail Screen

**Layout:**
```
┌────────────────────────────────────┐
│  ← PR #1234              ⋯  ↗     │ App Bar
├────────────────────────────────────┤
│                                    │
│  Fix authentication bug            │ Title
│                                    │
│  flutter/flutter  [Open]           │ Meta
│  by @john-dev • 2 hours ago        │
│                                    │
│  ──────────────────────────────    │ Divider
│                                    │
│  Description                       │ Section
│  This PR fixes the OAuth login     │ Description
│  flow that was causing timeouts    │ Text
│  for users with 2FA enabled...     │
│                                    │
│  Files Changed: 5  +124 -56        │ Stats
│                                    │
│  ──────────────────────────