#!/bin/bash

# Stream Serverpod Cloud logs
#
# Usage:
#   ./scripts/logs.sh          # Stream live logs
#   ./scripts/logs.sh 1h       # Last hour
#   ./scripts/logs.sh 100      # Last 100 entries

set -e

PROJECT="gitradar"

if [ -z "$1" ]; then
    echo "Streaming live logs for $PROJECT..."
    echo "Press Ctrl+C to stop"
    echo ""
    dart pub global run serverpod_cloud_cli log --project "$PROJECT" --tail
elif [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Fetching last $1 logs for $PROJECT..."
    dart pub global run serverpod_cloud_cli log --project "$PROJECT" --limit "$1"
else
    echo "Fetching logs since $1 for $PROJECT..."
    dart pub global run serverpod_cloud_cli log --project "$PROJECT" --since "$1"
fi
