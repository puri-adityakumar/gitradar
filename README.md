# GitRadar

A GitHub monitoring platform that provides unified tracking of pull requests, issues, and repository activity across multiple projects.

**Built with:** [Serverpod 3](https://serverpod.dev) + [Flutter](https://flutter.dev) + PostgreSQL

**Live Demo:** [gitradar.api.serverpod.space](https://gitradar.api.serverpod.space/)

## Features

- **Multi-repo monitoring** - Track up to 10 repositories in one dashboard
- **Unified activity feed** - See all PRs and issues across repos with filtering
- **Smart notifications** - Per-repository in-app and push notification settings
- **Manual sync** - Force refresh data from GitHub on demand
- **Dark mode** - Full light/dark theme support
- **Anonymous mode** - Browse public repos without GitHub PAT (60 req/hr limit)

## Screenshots

| Repositories | Activity | Notifications |
|--------------|----------|---------------|
| Track repos with notification toggles | Filter PRs/Issues by repo | In-app notification center |

## Quick Start

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.x
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Serverpod CLI](https://docs.serverpod.dev/)

```bash
dart pub global activate serverpod_cli
```

### Run Locally

```bash
# 1. Clone and setup
git clone https://github.com/anthropics/gitradar.git
cd gitradar
./scripts/setup.sh

# 2. Start database
./scripts/db-start.sh

# 3. Start server
./scripts/server-start.sh

# 4. Start app (in another terminal)
cd app && flutter run -d chrome --web-port=3000
```

### Environment

Server runs at `http://localhost:8080`
App runs at `http://localhost:3000`

## Project Structure

```
gitradar/
├── server/              # Serverpod backend
│   ├── lib/src/
│   │   ├── endpoints/   # RPC endpoints
│   │   ├── models/      # Database models (.spy.yaml)
│   │   ├── services/    # Business logic
│   │   └── futures/     # Background jobs
│   └── migrations/      # Database migrations
├── app/                 # Flutter application
│   └── lib/src/
│       ├── features/    # Feature modules
│       ├── core/        # Theme, client, constants
│       └── routing/     # GoRouter config
├── gitradar_client/     # Generated Serverpod client
├── scripts/             # Dev helper scripts
└── docs/                # Documentation
```

## Documentation

| Document | Description |
|----------|-------------|
| [CLAUDE.md](CLAUDE.md) | AI assistant instructions |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Technical architecture & diagrams |
| [DATABASE.md](docs/DATABASE.md) | Schema & DBML |
| [GETTING_STARTED.md](docs/GETTING_STARTED.md) | Detailed setup guide |
| [PRD.md](docs/PRD.md) | Product requirements |

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3, Riverpod, GoRouter, Material 3 |
| Backend | Serverpod 3, Dart |
| Database | PostgreSQL 16 |
| Push Notifications | OneSignal |
| Deployment | Serverpod Cloud |

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [GETTING_STARTED.md](docs/GETTING_STARTED.md) for development setup.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Built for the [Serverpod 3 Global Hackathon](https://serverpod.dev)
- GitHub REST API for repository data
- OneSignal for push notifications
