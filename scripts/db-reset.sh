#!/bin/bash
set -e

cd "$(dirname "$0")/../server"

echo "WARNING: This will delete all data in the database!"
read -p "Are you sure? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Stopping and removing containers..."
    docker compose down -v

    echo "Starting fresh database..."
    docker compose up -d

    sleep 3
    echo "Database reset complete."
else
    echo "Aborted."
fi
