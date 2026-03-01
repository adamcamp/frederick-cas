#!/usr/bin/env bash
# deploy.sh — Trigger a new DigitalOcean App Platform deployment for Frederick CAS
#
# Usage:
#   ./deploy.sh                        # prompts for token and app name
#   DO_TOKEN=xxx ./deploy.sh           # skip token prompt
#   DO_TOKEN=xxx APP_NAME=xxx ./deploy.sh  # skip both prompts
#
# Requires: doctl

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---- Prerequisites ----
if ! command -v doctl &>/dev/null; then
  echo "Installing doctl via snap..."
  sudo snap install doctl
  echo -e "${GREEN}doctl installed ✓${NC}"
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

echo -e "${YELLOW}Authenticating with DigitalOcean...${NC}"
doctl auth init --access-token "$DO_TOKEN"

# ---- Find the app ----
echo -e "${YELLOW}Fetching app list...${NC}"
APP_NAMES=$(doctl apps list --format Spec.Name --no-header 2>/dev/null) || {
  echo -e "${RED}Error: Could not reach DigitalOcean API. Check your token.${NC}" >&2
  exit 1
}

if [[ -z "${APP_NAME:-}" ]]; then
  echo ""
  echo "Available apps:"
  echo "$APP_NAMES" | nl -w2 -s') '
  echo ""
  read -rp "App name (default: frederick-cas): " APP_NAME
  APP_NAME="${APP_NAME:-frederick-cas}"
fi

APP_ID=$(doctl apps list --format Spec.Name,ID --no-header 2>/dev/null | awk -v name="$APP_NAME" '$1 == name {print $2}')

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

DEPLOY_ID=$(doctl apps create-deployment "$APP_ID" --force-rebuild --format ID --no-header) || {
  echo -e "${RED}Error: Failed to trigger deployment.${NC}" >&2
  exit 1
}

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
  PHASE=$(doctl apps get-deployment "$APP_ID" "$DEPLOY_ID" --format Phase --no-header 2>/dev/null) || break

  printf "\r  ${SPIN[$SPIN_IDX]} Phase: %-20s" "$PHASE"
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
