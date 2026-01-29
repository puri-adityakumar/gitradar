# GitRadar - Product Requirements Document

## Overview

**Product:** GitRadar
**Type:** Developer Productivity Tool
**Platform:** Cross-platform (Flutter Web, iOS, Android, macOS)
**Built for:** Serverpod 3 Global Hackathon

### Vision

GitRadar is a minimalist GitHub monitoring platform that provides developers with unified tracking of pull requests, issues, and repository activity across multiple projects.

### Problem

Developers managing multiple GitHub repositories face:
1. **Notification Overload** - GitHub's native notifications are overwhelming
2. **Missed Updates** - Critical PR/issue updates get lost in noise
3. **Context Switching** - Constantly checking multiple repos disrupts workflow

### Solution

A clean, distraction-free command center for GitHub activity with:
- Selective repository watching with granular notification controls
- Unified activity tracking across all monitored repositories
- Smart filtering to surface high-priority updates

---

## MVP Scope

### Features

| Feature | Description |
|---------|-------------|
| **PAT Authentication** | GitHub Personal Access Token login with user identity from GitHub API |
| **Repository Management** | Add, list, remove repos (max 10 per user) |
| **Per-Repo Notifications** | Independent in-app and push notification settings per repository |
| **Activity Feed** | Unified view of PRs and Issues with filtering by repository |
| **Notification Center** | In-app notifications with mark read/unread |
| **Manual Sync** | Force refresh data from GitHub on demand |
| **Background Sync** | Automatic polling every 5 minutes via Serverpod scheduler |
| **Theme Support** | Light/Dark/System mode toggle |
| **Anonymous Mode** | Browse public repos without PAT (60 req/hr limit) |

### Screens

1. **Login** - PAT input with guest mode option
2. **Repositories** - Watched repos with sync status and notification toggles
3. **Activity** - Unified PR/Issue feed with repository filter
4. **Notifications** - In-app notification center
5. **Settings** - Theme, account info, logout

### Limits

| Limit | Value | Reason |
|-------|-------|--------|
| Max repositories per user | 10 | MVP scope |
| Max PRs per repository | 50 | Storage efficiency |
| Max Issues per repository | 50 | Storage efficiency |
| Sync interval | 5 minutes | GitHub rate limits |

### Out of Scope (MVP)

- GitHub OAuth flow (using PAT for simplicity)
- Real-time webhooks (using polling instead)
- Full PR/Issue detail screens (link to GitHub)
- Comments fetching and display
- AI summarization
- Multi-user/team features
- Desktop/Email notifications

---

## User Stories

### Authentication
- As a developer, I want to authenticate with my GitHub PAT so I can access my repositories
- As a developer, I want to browse public repos anonymously without providing credentials

### Repository Management
- As a developer, I want to add repositories to my watchlist to monitor their activity
- As a developer, I want to configure notification settings per repository to reduce noise
- As a developer, I want to remove repositories I no longer need to monitor
- As a developer, I want to manually sync my repositories to get the latest data

### Activity Tracking
- As a developer, I want to see all PRs across my watched repos in one place
- As a developer, I want to filter PRs/Issues by repository
- As a developer, I want to open PRs/Issues directly in GitHub

### Notifications
- As a developer, I want to receive in-app notifications for new activity
- As a developer, I want to receive push notifications for important updates
- As a developer, I want to mark notifications as read

### Preferences
- As a developer, I want to switch between light and dark themes
- As a developer, I want my preferences to persist across sessions

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Time saved checking repo status | 60% reduction |
| Critical updates response time | 80% improvement |
| User satisfaction with notification relevance | 90% |

---

## Future Scope

### Phase 2: Real-Time & Enhanced Monitoring

| Feature | Description |
|---------|-------------|
| **Webhook Integration** | Real-time updates via GitHub webhooks instead of polling |
| **PR Review Tracking** | Track review status, approvals, and requested changes |
| **Comment Notifications** | Notifications for new comments on PRs/Issues |
| **Mention Detection** | Highlight when user is @mentioned |
| **Advanced Filtering** | Filter by author, labels, file changes, date range |
| **PR Conflict Detection** | Alert when PRs have merge conflicts |

### Phase 3: Integrations & Productivity

| Feature | Description |
|---------|-------------|
| **Slack/Discord Integration** | Forward notifications to team channels |
| **Email Digest** | Daily/weekly summary emails |
| **Desktop Notifications** | Native OS notifications |
| **GitHub Actions Status** | Show CI/CD pipeline status |
| **Custom Notification Rules** | Rule-based notification filtering |
| **Multi-Account Support** | Switch between GitHub accounts |

### Phase 4: Intelligence & Analytics

| Feature | Description |
|---------|-------------|
| **AI PR Summarization** | Auto-generated PR summaries using LLMs |
| **Smart Prioritization** | ML-based PR/Issue priority scoring |
| **Review Assignment Suggestions** | Suggest reviewers based on code ownership |
| **Productivity Analytics** | Personal and team productivity insights |
| **Code Review Insights** | Track review patterns and bottlenecks |
| **Digest Mode** | Batch notifications into smart digests |

### Phase 5: Team & Enterprise

| Feature | Description |
|---------|-------------|
| **Team Workspaces** | Shared repository lists for teams |
| **Organization Dashboard** | Aggregate view across org repos |
| **RBAC** | Role-based access control |
| **SSO/SAML** | Enterprise authentication |
| **Audit Logging** | Track user actions for compliance |
| **On-Premise Deployment** | Self-hosted option |

---

## Technical References

- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture and diagrams
- [DATABASE.md](DATABASE.md) - Database schema and DBML
- [GETTING_STARTED.md](GETTING_STARTED.md) - Development setup guide
