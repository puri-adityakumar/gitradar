#!/bin/bash
set -e

cd "$(dirname "$0")/../server"

echo "Starting PostgreSQL..."
docker compose up -d

echo "Waiting for PostgreSQL to be ready..."
sleep 3

echo "PostgreSQL is running on localhost:5432"
echo "Database: gitradar"
echo "User: postgres"
