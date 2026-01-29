# Getting Started with GitRadar

Guide for setting up GitRadar for local development.

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter | 3.x | `brew install --cask flutter` |
| Dart | 3.x | Included with Flutter |
| Docker | Latest | `brew install --cask docker` |
| Serverpod CLI | Latest | `dart pub global activate serverpod_cli` |

Verify installations:
```bash
flutter --version
dart --version
docker --version
dart pub global run serverpod_cli --help
```

## Quick Setup

```bash
# Clone repository
git clone https://github.com/anthropics/gitradar.git
cd gitradar

# Run setup script (installs deps, generates code)
./scripts/setup.sh
```

## Running Locally

### 1. Start Database

```bash
./scripts/db-start.sh
```

This starts PostgreSQL 16 via Docker on port 5432.

### 2. Start Server

```bash
./scripts/server-start.sh
```

Or manually:
```bash
cd server
dart run bin/main.dart --apply-migrations
```

Server runs at `http://localhost:8080`

### 3. Start App

```bash
cd app
flutter run -d chrome --web-port=3000
```

App runs at `http://localhost:3000`

## Development Workflow

### After Model Changes

When you modify `server/lib/src/models/*.spy.yaml`:

```bash
./scripts/generate.sh
```

This regenerates:
- Server protocol (`server/lib/src/generated/`)
- Client SDK (`gitradar_client/lib/src/protocol/`)

### Hot Reload

- **Flutter:** Press `r` in terminal or save file
- **Server:** Restart required for endpoint changes

### Running Tests

```bash
# Server tests
cd server && dart test

# Single test file
cd server && dart test test/integration/auth_endpoint_test.dart

# App tests
cd app && flutter test
```

## Project Structure

```
gitradar/
├── server/                    # Serverpod backend
│   ├── bin/main.dart          # Entry point
│   ├── lib/src/
│   │   ├── endpoints/         # RPC endpoints
│   │   ├── models/            # Database models (.spy.yaml)
│   │   ├── services/          # Business logic
│   │   ├── futures/           # Background jobs
│   │   ├── util/              # Auth handler, helpers
│   │   └── generated/         # Auto-generated (DO NOT EDIT)
│   ├── config/                # Environment configs
│   ├── migrations/            # Database migrations
│   └── test/                  # Server tests
│
├── app/                       # Flutter application
│   ├── lib/
│   │   ├── main.dart          # Entry point
│   │   └── src/
│   │       ├── features/      # Feature modules
│   │       │   ├── auth/
│   │       │   ├── repositories/
│   │       │   ├── activity/
│   │       │   ├── notifications/
│   │       │   └── settings/
│   │       ├── core/          # Theme, client, constants
│   │       ├── shared/        # Shared widgets
│   │       ├── providers/     # Global providers
│   │       └── routing/       # GoRouter config
│   └── test/                  # App tests
│
├── gitradar_client/           # Generated Serverpod client
│
├── scripts/                   # Helper scripts
│   ├── setup.sh               # First-time setup
│   ├── db-start.sh            # Start PostgreSQL
│   ├── db-stop.sh             # Stop PostgreSQL
│   ├── db-reset.sh            # Reset database
│   ├── server-start.sh        # Start server
│   ├── generate.sh            # Regenerate code
│   ├── build-android.sh       # Build Android APK
│   └── seed-data.sh           # Seed demo repositories
│
└── docs/                      # Documentation
    ├── ARCHITECTURE.md        # Technical architecture
    ├── DATABASE.md            # Database schema
    ├── GETTING_STARTED.md     # This file
    └── PRD.md                 # Product requirements
```

## Common Tasks

### Add a New Endpoint

1. Create endpoint file in `server/lib/src/endpoints/`:
```dart
import 'package:serverpod/serverpod.dart';

class MyEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello, $name!';
  }
}
```

2. Regenerate code:
```bash
./scripts/generate.sh
```

3. Use from client:
```dart
final result = await client.my.hello('World');
```

### Add a New Model

1. Create model file in `server/lib/src/models/my_model.spy.yaml`:
```yaml
class: MyModel
table: my_models
fields:
  name: String
  createdAt: DateTime
```

2. Regenerate code:
```bash
./scripts/generate.sh
```

3. Apply migrations:
```bash
cd server && dart run bin/main.dart --apply-migrations
```

### Add a New Screen

1. Create screen in `app/lib/src/features/my_feature/`:
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Center(child: Text('Hello')),
    );
  }
}
```

2. Add route in `app/lib/src/routing/router.dart`

3. Add provider if needed in same feature folder

## Seed Demo Data

Populate the app with demo repositories:

```bash
# Local development
./scripts/seed-data.sh

# Production
./scripts/seed-data.sh https://gitradar.api.serverpod.space
```

This adds:
- `flutter/flutter`
- `serverpod/serverpod`
- `puri-adityakumar/astraa`

## Build Android APK

```bash
# Debug build
./scripts/build-android.sh

# Release build
./scripts/build-android.sh release
```

APK location: `app/build/app/outputs/flutter-apk/`

## Deployment

### Deploy Server to Serverpod Cloud

```bash
dart pub global run serverpod_cloud_cli deploy
```

### Check Deployment Status

```bash
dart pub global run serverpod_cloud_cli deployment list
```

### View Logs

```bash
dart pub global run serverpod_cloud_cli log
```

### Deploy Web App to Vercel

**Option 1: Manual Deploy**

```bash
# Build web
cd app && flutter build web --release

# Install Vercel CLI
npm i -g vercel

# Deploy
cd build/web && vercel
```

**Option 2: GitHub Actions (Automatic)**

1. Create Vercel project at [vercel.com](https://vercel.com)
2. Get tokens from Vercel dashboard:
   - `VERCEL_TOKEN` - Account Settings → Tokens
   - `VERCEL_ORG_ID` - Project Settings → General
   - `VERCEL_PROJECT_ID` - Project Settings → General
3. Add secrets to GitHub repo: Settings → Secrets → Actions
4. Push to `main` branch - auto-deploys

## Troubleshooting

### "serverpod: command not found"

Add Dart's global bin to PATH:
```bash
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Database connection failed

1. Check Docker is running: `docker ps`
2. Start database: `./scripts/db-start.sh`
3. Check logs: `docker compose -f server/docker-compose.yaml logs`

### Generated code out of sync

```bash
./scripts/generate.sh
cd app && flutter pub get
```

### Flutter build errors

```bash
cd app
flutter clean
flutter pub get
```
