# GitRadar Database Documentation

## Overview

GitRadar uses PostgreSQL as its database, managed through Serverpod's ORM. The database stores user authentication data, watched repositories, synced GitHub activity (PRs/Issues), and in-app notifications.

## Database Files

| File | Purpose |
|------|---------|
| `server/lib/src/models/*.spy.yaml` | Model definitions (source of truth) |
| `server/migrations/` | Auto-generated SQL migrations |
| `server/docker-compose.yaml` | Local PostgreSQL 16 container |
| `server/config/development.yaml` | DB connection config (dev) |
| `server/config/passwords.yaml` | DB credentials |

## Model Files

```
server/lib/src/models/
├── user.spy.yaml              # GitHub-authenticated users
├── user_preferences.spy.yaml  # Theme and app settings
├── repository.spy.yaml        # Watched GitHub repositories
├── pull_request.spy.yaml      # Synced pull requests
├── issue.spy.yaml             # Synced issues
└── notification.spy.yaml      # In-app notifications
```

## Schema Overview

### Users & Preferences

- **User**: Stores GitHub identity (id, username, avatar) and encrypted PAT for API access. The PAT is never sent to the client.
- **UserPreferences**: One-to-one with User. Stores theme preference (light/dark/system).

### Repository Tracking

- **Repository**: Links a user to a GitHub repo they're watching. Each repo has independent notification settings (in-app, push, level). Tracks sync cursors for incremental updates.

### GitHub Activity

- **PullRequest**: Cached PR data from GitHub. Stores title, author, state (open/closed/merged), and read status. Limited to 50 per repo.
- **Issue**: Similar to PR but includes labels as JSON. State is only open/closed.

### Notifications

- **Notification**: In-app alerts for new/updated PRs and issues. Links to the source entity and tracks read status.

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
// Docs: https://dbml.dbdiagram.io/docs

Table users {
  id int [pk, increment]
  github_id int [unique, not null, note: 'GitHub user ID']
  github_username varchar [unique, not null]
  display_name varchar
  avatar_url varchar
  encrypted_pat varchar [not null, note: 'AES-256 encrypted, server-only']
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
  theme_mode varchar [not null, note: 'light | dark | system']
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
  is_private bool [not null]
  in_app_notifications bool [not null, default: true]
  push_notifications bool [not null, default: false]
  notification_level varchar [not null, note: 'all | mentions | none']
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
```

## Database Commands

```bash
# Start PostgreSQL (Docker)
./scripts/db-start.sh

# Stop PostgreSQL
./scripts/db-stop.sh

# Reset database (wipes all data)
./scripts/db-reset.sh

# Generate migrations from models
cd server && serverpod generate

# Apply migrations
cd server && dart run bin/main.dart --apply-migrations
```

## Connection Details (Development)

| Setting | Value |
|---------|-------|
| Host | localhost |
| Port | 5432 |
| Database | gitradar |
| User | postgres |
| Password | password |

## Data Limits (MVP)

| Limit | Value |
|-------|-------|
| Max repositories per user | 10 |
| Max PRs per repository | 50 |
| Max issues per repository | 50 |
| Sync interval | 5-10 minutes |
