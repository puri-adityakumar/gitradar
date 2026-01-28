#!/bin/bash
set -e

echo "=== GitRadar Setup ==="
echo ""

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter is not installed. Install with: brew install --cask flutter"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Install with: brew install --cask docker"
    exit 1
fi

if ! command -v serverpod &> /dev/null; then
    echo "ERROR: Serverpod CLI is not installed. Install with: dart pub global activate serverpod_cli"
    exit 1
fi

echo "All prerequisites found!"
echo ""

# Navigate to project root
cd "$(dirname "$0")/.."
PROJECT_ROOT=$(pwd)

# Create Serverpod project if server doesn't exist
if [ ! -d "server" ]; then
    echo "Creating Serverpod project..."
    serverpod create gitradar --no-flutter

    # Rename to match our structure
    mv gitradar_server server
    rm -rf gitradar_client  # We'll generate client when Flutter app is created

    echo "Serverpod project created!"
else
    echo "Server directory already exists, skipping creation."
fi

# Install server dependencies
echo ""
echo "Installing server dependencies..."
cd "$PROJECT_ROOT/server"
dart pub get

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Start Docker Desktop"
echo "2. Run: ./scripts/db-start.sh"
echo "3. Run: ./scripts/server-start.sh"
