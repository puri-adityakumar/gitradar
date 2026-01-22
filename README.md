# GitRadar

A GitHub monitoring platform built with Serverpod 3 and Flutter.

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (includes Dart)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Serverpod CLI](https://docs.serverpod.dev/)

```bash
# Install via Homebrew (macOS)
brew install --cask flutter
brew install --cask docker

# Install Serverpod CLI
dart pub global activate serverpod_cli
```

## Project Structure

```
gitradar/
├── server/          # Serverpod backend
├── app/             # Flutter application (created after backend is ready)
├── docs/            # Documentation
└── scripts/         # Development scripts
```

## Quick Start

```bash
# 1. Start PostgreSQL
./scripts/db-start.sh

# 2. Start Serverpod server
./scripts/server-start.sh

# 3. (After frontend is ready) Start Flutter app
./scripts/app-start.sh
```

## First Time Setup

```bash
# Run the setup script after installing prerequisites
./scripts/setup.sh
```

## Development Commands

### Server
```bash
cd server
dart pub get                           # Install dependencies
serverpod generate                     # Generate code
dart run bin/main.dart --apply-migrations  # Run with migrations
dart test                              # Run tests
```

### Database
```bash
./scripts/db-start.sh                  # Start PostgreSQL
./scripts/db-stop.sh                   # Stop PostgreSQL
./scripts/db-reset.sh                  # Reset database (destructive)
```

## Documentation

- [PRD](docs/PRD.md) - Product Requirements Document
- [Getting Started](docs/GETTING_STARTED.md) - Setup guide for beginners
- [Tools & Setup](docs/TOOLS_AND_SETUP.md) - Development tools
