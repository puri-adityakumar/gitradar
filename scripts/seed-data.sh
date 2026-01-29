#!/bin/bash

# Seed data script for GitRadar
#
# Adds demo repositories to a user account for testing/demo purposes.
#
# Usage:
#   ./scripts/seed-data.sh [API_URL]
#
# Examples:
#   ./scripts/seed-data.sh                                        # Local
#   ./scripts/seed-data.sh https://gitradar.api.serverpod.space   # Production

set -e

API_URL="${1:-http://localhost:8080}"
DEVICE_ID="seed-demo-$(date +%s)"

echo "GitRadar Seed Data Script"
echo "========================="
echo "API URL: $API_URL"
echo "Device ID: $DEVICE_ID"
echo ""

# Step 1: Login as anonymous user
echo "1. Logging in as anonymous user..."
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/loginAnonymous" \
  -H "Content-Type: application/json" \
  -d "{\"deviceId\": \"$DEVICE_ID\"}")

SESSION_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"sessionToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$SESSION_TOKEN" ]; then
  echo "   ✗ Failed to login. Response: $LOGIN_RESPONSE"
  exit 1
fi

echo "   ✓ Logged in. Token: ${SESSION_TOKEN:0:20}..."
echo ""

# Demo repositories to seed
REPOS=(
  "flutter:flutter"
  "serverpod:serverpod"
  "puri-adityakumar:astraa"
)

# Step 2: Add repositories
echo "2. Adding repositories..."
for REPO in "${REPOS[@]}"; do
  OWNER="${REPO%%:*}"
  REPO_NAME="${REPO##*:}"

  echo "   Adding $OWNER/$REPO_NAME..."

  RESPONSE=$(curl -s -X POST "$API_URL/repository/addRepository" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $SESSION_TOKEN" \
    -d "{\"owner\": \"$OWNER\", \"repo\": \"$REPO_NAME\"}" 2>&1)

  if echo "$RESPONSE" | grep -q '"id"'; then
    echo "   ✓ Added $OWNER/$REPO_NAME"
  elif echo "$RESPONSE" | grep -qi "already"; then
    echo "   ⊘ $OWNER/$REPO_NAME already exists"
  else
    echo "   ✗ Failed: $RESPONSE"
  fi
done

echo ""

# Step 3: Trigger sync
echo "3. Syncing repositories..."
SYNC_RESPONSE=$(curl -s -X POST "$API_URL/repository/syncRepositories" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $SESSION_TOKEN" \
  -d "{}")

if echo "$SYNC_RESPONSE" | grep -q "repositoryId"; then
  echo "   ✓ Sync complete"
  # Parse sync results
  echo "$SYNC_RESPONSE" | grep -o '"newPullRequests":[0-9]*' | while read line; do
    echo "     $line"
  done
else
  echo "   ✗ Sync failed: $SYNC_RESPONSE"
fi

echo ""

# Step 4: Get activity counts
echo "4. Fetching summary..."
COUNTS_RESPONSE=$(curl -s -X POST "$API_URL/activity/getCounts" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $SESSION_TOKEN" \
  -d "{}")

if echo "$COUNTS_RESPONSE" | grep -q "openPullRequests"; then
  OPEN_PRS=$(echo "$COUNTS_RESPONSE" | grep -o '"openPullRequests":[0-9]*' | cut -d: -f2)
  OPEN_ISSUES=$(echo "$COUNTS_RESPONSE" | grep -o '"openIssues":[0-9]*' | cut -d: -f2)
  UNREAD=$(echo "$COUNTS_RESPONSE" | grep -o '"unreadNotifications":[0-9]*' | cut -d: -f2)
  echo "   Open PRs: $OPEN_PRS"
  echo "   Open Issues: $OPEN_ISSUES"
  echo "   Unread Notifications: $UNREAD"
else
  echo "   ✗ Failed to get counts"
fi

echo ""
echo "========================="
echo "Seed data complete!"
echo ""
echo "Device ID for reuse: $DEVICE_ID"
echo ""
echo "To test in browser:"
echo "  1. Open the app"
echo "  2. Click 'Continue as Guest'"
echo "  3. Repositories will be automatically synced"
