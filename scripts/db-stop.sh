#!/bin/bash
set -e

cd "$(dirname "$0")/../server"

echo "Stopping PostgreSQL..."
docker compose down

echo "PostgreSQL stopped."
