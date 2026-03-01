#!/usr/bin/env bash
# deploy.sh — Trigger a new DigitalOcean App Platform deployment for Frederick CAS
#
# Usage:
#   ./deploy.sh                        # prompts for token and app name
#   DO_TOKEN=xxx ./deploy.sh           # skip token prompt
#   DO_TOKEN=xxx APP_NAME=xxx ./deploy.sh  # skip both prompts
#
# Requires: curl, jq

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DO_API="https://api.digitalocean.com/v2"

# ---- Prerequisites ----
if ! command -v curl &>/dev/null; then
  echo -e "${RED}Error: curl is required but not installed.${NC}" >&2
  exit 1
fi
if ! command -v jq &>/dev/null; then
  echo -e "${RED}Error: jq is required but not installed.${NC}" >&2
  echo "  macOS:  brew install jq"
  echo "  Ubuntu: apt-get install jq"
  exit 1
fi

echo -e "${CYAN}Frederick CAS — DigitalOcean Deploy${NC}"
echo "====================================="
echo ""

# ---- Credentials ----
if [[ -z "${DO_TOKEN:-}" ]]; then
  read -rsp "DigitalOcean API Token: " DO_TOKEN
  echo ""
fi
if [[ -z "$DO_TOKEN" ]]; then
  echo -e "${RED}Error: DO_TOKEN is required.${NC}" >&2
  exit 1
fi

do_get() {
  curl -sf -H "Authorization: Bearer $DO_TOKEN" "$DO_API/$1"
}

do_post() {
  local path="$1"
  shift
  curl -sf -X POST \
    -H "Authorization: Bearer $DO_TOKEN" \
    -H "Content-Type: application/json" \
    "$DO_API/$path" \
    "$@"
}

# ---- Find the app ----
echo -e "${YELLOW}Fetching app list...${NC}"
APPS_JSON=$(do_get "apps" 2>/dev/null) || {
  echo -e "${RED}Error: Could not reach DigitalOcean API. Check your token.${NC}" >&2
  exit 1
}

# Build a display list of apps
APP_NAMES=$(echo "$APPS_JSON" | jq -r '.apps[].spec.name')

if [[ -z "${APP_NAME:-}" ]]; then
  echo ""
  echo "Available apps:"
  echo "$APP_NAMES" | nl -w2 -s') '
  echo ""
  read -rp "App name (default: frederick-cas): " APP_NAME
  APP_NAME="${APP_NAME:-frederick-cas}"
fi

APP_ID=$(echo "$APPS_JSON" | jq -r --arg name "$APP_NAME" \
  '.apps[] | select(.spec.name == $name) | .id')

if [[ -z "$APP_ID" ]]; then
  echo -e "${RED}Error: App '${APP_NAME}' not found.${NC}" >&2
  echo "Available apps: $APP_NAMES"
  exit 1
fi

echo ""
echo -e "App: ${GREEN}${APP_NAME}${NC}  (ID: ${APP_ID})"

# ---- Trigger deployment ----
echo ""
echo -e "${YELLOW}Triggering deployment...${NC}"

DEPLOY_JSON=$(do_post "apps/${APP_ID}/deployments" -d '{"force_build": true}') || {
  echo -e "${RED}Error: Failed to trigger deployment.${NC}" >&2
  exit 1
}

DEPLOY_ID=$(echo "$DEPLOY_JSON" | jq -r '.deployment.id')
DEPLOY_URL="https://cloud.digitalocean.com/apps/${APP_ID}/deployments/${DEPLOY_ID}"

echo ""
echo -e "${GREEN}Deployment triggered!${NC}"
echo "  Deployment ID: $DEPLOY_ID"
echo "  Console:       $DEPLOY_URL"
echo ""

# ---- Poll until complete ----
echo -e "${YELLOW}Waiting for deployment to finish (Ctrl+C to stop watching)...${NC}"
echo ""

SPIN=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
SPIN_IDX=0

while true; do
  STATUS_JSON=$(do_get "apps/${APP_ID}/deployments/${DEPLOY_ID}" 2>/dev/null) || break
  PHASE=$(echo "$STATUS_JSON" | jq -r '.deployment.phase')
  PROGRESS=$(echo "$STATUS_JSON" | jq -r '
    .deployment.progress |
    if . then
      "\(.success_steps // 0)/\(.total_steps // "?") steps"
    else "—"
    end
  ')

  printf "\r  ${SPIN[$SPIN_IDX]} Phase: %-20s  Progress: %-15s" "$PHASE" "$PROGRESS"
  SPIN_IDX=$(( (SPIN_IDX + 1) % ${#SPIN[@]} ))

  case "$PHASE" in
    ACTIVE)
      echo ""
      echo ""
      echo -e "${GREEN}Deployment successful!${NC}"
      echo "  Console: $DEPLOY_URL"
      break
      ;;
    ERROR|CANCELED|UNKNOWN)
      echo ""
      echo ""
      echo -e "${RED}Deployment ended with phase: ${PHASE}${NC}"
      echo "  Check logs at: $DEPLOY_URL"
      exit 1
      ;;
  esac

  sleep 5
done
