#!/bin/bash
set -e

cd "$(dirname "$0")/../server"

# Check if this is first run (migrations needed)
if [ "$1" == "--apply-migrations" ] || [ "$1" == "-m" ]; then
    echo "Starting server with migrations..."
    dart run bin/main.dart --apply-migrations
else
    echo "Starting server..."
    echo "(Use --apply-migrations or -m for first run)"
    dart run bin/main.dart
fi
