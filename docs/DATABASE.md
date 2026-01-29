# GitRadar Database Schema

## Overview

GitRadar uses PostgreSQL managed through Serverpod's ORM. The database stores user data, watched repositories, synced GitHub activity (PRs/Issues), and in-app notifications.

## Entity Relationship Diagram

```
┌─────────────┐       ┌───────────────────┐
│    User     │───────│  UserPreferences  │
│             │  1:1  │                   │
└─────────────┘       └───────────────────┘
       │
       │ 1:N
       ▼
┌─────────────┐
│ Repository  │
└─────────────┘
       │
       ├─────────────┬─────────────┐
       │ 1:N         │ 1:N         │ 1:N
       ▼             ▼             ▼
┌─────────────┐ ┌─────────┐ ┌──────────────┐
│ PullRequest │ │  Issue  │ │ Notification │
└─────────────┘ └─────────┘ └──────────────┘
```

## DBML Schema

```dbml
// GitRadar Database Schema
// Visualize at: https://dbdiagram.io

Table users {
  id int [pk, increment]
  github_id int [unique, not null, note: 'GitHub user ID']
  github_username varchar [unique, not null]
  display_name varchar
  avatar_url varchar
  encrypted_pat varchar [note: 'AES-256 encrypted, server-only']
  onesignal_player_id varchar [note: 'Push notification device ID']
  last_validated_at timestamp
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]

  indexes {
    github_id [unique]
    github_username [unique]
  }
}

Table user_preferences {
  id int [pk, increment]
  user_id int [unique, not null, ref: > users.id]
  theme_mode varchar [not null, default: 'system', note: 'light | dark | system']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]

  indexes {
    user_id [unique]
  }
}

Table repositories {
  id int [pk, increment]
  user_id int [not null, ref: > users.id]
  owner varchar [not null, note: 'GitHub owner/org']
  repo varchar [not null, note: 'Repository name']
  github_repo_id int [not null, note: 'Stable GitHub repo ID']
  is_private bool [not null, default: false]
  in_app_notifications bool [not null, default: true]
  push_notifications bool [not null, default: false]
  notification_level varchar [not null, default: 'all', note: 'all | mentions | none']
  last_synced_at timestamp
  last_pr_cursor timestamp [note: 'For incremental PR sync']
  last_issue_cursor timestamp [note: 'For incremental issue sync']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]

  indexes {
    (user_id, owner, repo) [unique]
    github_repo_id
    user_id
  }
}

Table pull_requests {
  id int [pk, increment]
  repository_id int [not null, ref: > repositories.id]
  github_id int [not null, note: 'GitHub PR ID']
  number int [not null, note: 'PR number (#123)']
  title varchar [not null]
  body text
  author varchar [not null]
  author_avatar_url varchar
  state varchar [not null, note: 'open | closed | merged']
  html_url varchar [not null]
  github_created_at timestamp [not null]
  github_updated_at timestamp [not null]
  is_read bool [not null, default: false]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]

  indexes {
    (repository_id, number) [unique]
    (repository_id, state)
    (repository_id, is_read)
    (repository_id, github_updated_at)
  }
}

Table issues {
  id int [pk, increment]
  repository_id int [not null, ref: > repositories.id]
  github_id int [not null, note: 'GitHub issue ID']
  number int [not null, note: 'Issue number (#456)']
  title varchar [not null]
  body text
  author varchar [not null]
  author_avatar_url varchar
  state varchar [not null, note: 'open | closed']
  labels_json text [note: 'JSON array of label names']
  html_url varchar [not null]
  github_created_at timestamp [not null]
  github_updated_at timestamp [not null]
  is_read bool [not null, default: false]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]

  indexes {
    (repository_id, number) [unique]
    (repository_id, state)
    (repository_id, is_read)
    (repository_id, github_updated_at)
  }
}

Table notifications {
  id int [pk, increment]
  user_id int [not null, ref: > users.id]
  type varchar [not null, note: 'pr_opened | pr_updated | issue_opened | issue_updated']
  title varchar [not null]
  message varchar [not null]
  repository_id int [not null, ref: > repositories.id]
  pull_request_id int [ref: > pull_requests.id, note: 'Nullable - set if PR notification']
  issue_id int [ref: > issues.id, note: 'Nullable - set if issue notification']
  is_read bool [not null, default: false]
  created_at timestamp [default: `now()`]

  indexes {
    (user_id, is_read)
    (user_id, created_at)
    repository_id
  }
}

// Response/Filter models (not persisted)
// - AuthResponse: sessionToken, user
// - PaginatedPullRequests: items, nextCursor, hasMore
// - PaginatedIssues: items, nextCursor, hasMore
// - PaginatedNotifications: items, nextCursor, hasMore
// - ActivityCounts: openPullRequests, openIssues, unreadNotifications
// - SyncResult: repositoryId, newPullRequests, updatedPullRequests, newIssues, updatedIssues, notificationsCreated, syncedAt
// - PullRequestFilter: repositoryId, state, isRead
// - IssueFilter: repositoryId, state, isRead
```

## Model Files

```
server/lib/src/models/
├── user.spy.yaml                 # GitHub-authenticated users
├── user_preferences.spy.yaml     # Theme settings
├── repository.spy.yaml           # Watched GitHub repositories
├── pull_request.spy.yaml         # Synced pull requests
├── issue.spy.yaml                # Synced issues
├── notification.spy.yaml         # In-app notifications
├── auth_response.spy.yaml        # Login response
├── sync_result.spy.yaml          # Sync operation result
├── activity_counts.spy.yaml      # Dashboard counts
├── paginated_*.spy.yaml          # Pagination wrappers
├── pull_request_filter.spy.yaml  # PR query filter
└── issue_filter.spy.yaml         # Issue query filter
```

## Data Limits

| Limit | Value | Reason |
|-------|-------|--------|
| Max repositories per user | 10 | MVP scope |
| Max PRs per repository | 50 | Storage efficiency |
| Max Issues per repository | 50 | Storage efficiency |
| Sync interval | 5 minutes | GitHub rate limits |

## Commands

```bash
# Start PostgreSQL (Docker)
./scripts/db-start.sh

# Stop PostgreSQL
./scripts/db-stop.sh

# Reset database (destructive)
./scripts/db-reset.sh

# Generate migrations from models
cd server && dart pub global run serverpod_cli generate

# Apply migrations
cd server && dart run bin/main.dart --apply-migrations
```

## Connection (Development)

| Setting | Value |
|---------|-------|
| Host | localhost |
| Port | 5432 |
| Database | gitradar |
| User | postgres |
| Password | (see `server/config/passwords.yaml`) |
