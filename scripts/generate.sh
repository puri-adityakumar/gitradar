#!/bin/bash
set -e

cd "$(dirname "$0")/../server"

echo "Generating Serverpod code..."
serverpod generate

echo "Code generation complete!"

# If app exists, update its dependencies
if [ -d "../app" ]; then
    echo "Updating Flutter app dependencies..."
    cd ../app
    flutter pub get
    echo "Flutter dependencies updated!"
fi
