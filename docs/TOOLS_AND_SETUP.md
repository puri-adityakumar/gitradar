# GitRadar - Tools & Setup Guide

## Recommended MCP Tools

For agentic coding with Amp, consider these MCP servers:

### Essential
| MCP Server | Purpose |
|------------|---------|
| **filesystem** | Read/write project files |
| **github** | Access GitHub API directly for testing/research |

### Optional but Useful
| MCP Server | Purpose |
|------------|---------|
| **postgres** | Direct database queries during development |
| **fetch** | Test HTTP requests to GitHub API |

## VS Code Extensions

Recommended for this project:
- **Dart** - Dart language support
- **Flutter** - Flutter SDK integration
- **Serverpod** - Serverpod development tools
- **Amp** - AI coding assistant

## Environment Setup

### Prerequisites
```bash
# Install Flutter
# https://docs.flutter.dev/get-started/install

# Install Dart (comes with Flutter)

# Install Serverpod CLI
dart pub global activate serverpod_cli

# PostgreSQL (local or use Serverpod Cloud)
```

### Environment Variables

Create `.env` files (not committed to git):

**server/.env**
```env
# Serverpod configuration
SERVERPOD_DATABASE_HOST=localhost
SERVERPOD_DATABASE_PORT=5432
SERVERPOD_DATABASE_NAME=gitradar
SERVERPOD_DATABASE_USER=postgres
SERVERPOD_DATABASE_PASSWORD=your_password

# Encryption key for GitHub tokens (generate a 32-byte key)
GITHUB_TOKEN_ENCRYPTION_KEY=your_32_byte_base64_key
```

### Amp Configuration

Add to your `.amp/settings.json` if needed:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_pat_here"
      }
    }
  }
}
```

## Development Workflow

### Starting Development

```bash
# Terminal 1: Start PostgreSQL (if local)
docker-compose up -d postgres

# Terminal 2: Start Serverpod server
cd server
dart run bin/main.dart

# Terminal 3: Start Flutter app
cd app
flutter run -d chrome
```

### After Model Changes

```bash
cd server
serverpod generate
cd ../app
flutter pub get
```

## Testing GitHub API

Use the GitHub MCP or curl to test endpoints:

```bash
# List repos (public)
curl https://api.github.com/users/flutter/repos

# List PRs with auth
curl -H "Authorization: Bearer YOUR_PAT" \
  https://api.github.com/repos/flutter/flutter/pulls?state=all&sort=updated

# Check rate limit
curl -H "Authorization: Bearer YOUR_PAT" \
  https://api.github.com/rate_limit
```

## Debugging Tips

### Common Issues

1. **"serverpod generate" fails**
   - Check YAML syntax in model files
   - Ensure all field types are valid

2. **Database connection errors**
   - Verify PostgreSQL is running
   - Check credentials in config

3. **Flutter client not updating**
   - Run `flutter pub get` after `serverpod generate`
   - Check `app/lib/src/generated/` is not stale

4. **GitHub rate limiting**
   - Check remaining quota: `GET /rate_limit`
   - Wait for reset or use authenticated requests
