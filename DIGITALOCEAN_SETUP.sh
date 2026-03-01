#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}Frederick CAS — DigitalOcean Deployment Setup${NC}"
echo "================================================"
echo ""

# Check prerequisites
if ! command -v doctl &> /dev/null; then
  echo "Installing doctl via snap..."
  sudo snap install doctl
  echo -e "${GREEN}doctl installed ✓${NC}"
else
  echo -e "${GREEN}doctl already installed ✓${NC}"
fi

if [[ ! -f "$SCRIPT_DIR/app.yaml" ]]; then
  echo -e "${RED}Error: app.yaml not found in $SCRIPT_DIR${NC}"
  exit 1
fi

# Generate Rails master keys
CAS_MASTER_KEY=$(openssl rand -hex 16)
WAREHOUSE_MASTER_KEY=$(openssl rand -hex 16)

echo -e "${YELLOW}Generated Rails master keys — save these somewhere safe:${NC}"
echo ""
echo "  CAS master key:       $CAS_MASTER_KEY"
echo "  Warehouse master key: $WAREHOUSE_MASTER_KEY"
echo ""
echo -e "${RED}You will not see these again. Copy them now before continuing.${NC}"
echo ""
read -rp "Press Enter when you have saved both keys..."
echo ""

# Collect configuration
read -rp "CAS domain (default: frederick-cas.ondigitalocean.app): " CAS_DOMAIN
CAS_DOMAIN="${CAS_DOMAIN:-frederick-cas.ondigitalocean.app}"

read -rp "Warehouse domain (default: frederick-warehouse.ondigitalocean.app): " WAREHOUSE_DOMAIN
WAREHOUSE_DOMAIN="${WAREHOUSE_DOMAIN:-frederick-warehouse.ondigitalocean.app}"

read -rp "Email domain for no-reply address (default: frederick-cas.org): " EMAIL_DOMAIN
EMAIL_DOMAIN="${EMAIL_DOMAIN:-frederick-cas.org}"
echo ""

# Collect secrets (hidden)
echo "The following inputs are hidden."
echo ""

read -rsp "DigitalOcean API Token: " DO_TOKEN
echo ""

read -rsp "SendGrid API Key: " SENDGRID_KEY
echo ""

echo ""
echo -e "${YELLOW}Authenticating with DigitalOcean...${NC}"
doctl auth init --access-token "$DO_TOKEN"

# Build a temp spec with all placeholders filled in.
# Note: ${db.*} and ${cache.*} references are left intact — DigitalOcean
# resolves those automatically from the managed database/cache bindings.
TEMP_SPEC=$(mktemp "$HOME/.frederick-cas-spec-XXXXXX.yaml")
trap "rm -f $TEMP_SPEC" EXIT

sed \
  -e "s|\${CAS_DOMAIN}|${CAS_DOMAIN}|g" \
  -e "s|\${WAREHOUSE_DOMAIN}|${WAREHOUSE_DOMAIN}|g" \
  -e "s|\${EMAIL_DOMAIN}|${EMAIL_DOMAIN}|g" \
  -e "s|\${RAILS_MASTER_KEY}|${CAS_MASTER_KEY}|g" \
  -e "s|\${WAREHOUSE_RAILS_MASTER_KEY}|${WAREHOUSE_MASTER_KEY}|g" \
  -e "s|\${SENDGRID_API_KEY}|${SENDGRID_KEY}|g" \
  "$SCRIPT_DIR/app.yaml" > "$TEMP_SPEC"

echo -e "${YELLOW}Creating DigitalOcean App from app.yaml...${NC}"
APP_ID=$(doctl apps create --spec "$TEMP_SPEC" --format ID --no-header)

echo ""
echo -e "${GREEN}App created successfully!${NC}"
echo ""
echo "App ID:  $APP_ID"
echo "Console: https://cloud.digitalocean.com/apps/${APP_ID}"
echo ""
echo "Once deployed (10-15 minutes), your services will be at:"
echo "  CAS:       https://${CAS_DOMAIN}"
echo "  Warehouse: https://${WAREHOUSE_DOMAIN}"
echo ""
echo -e "${YELLOW}Watch build progress:${NC}"
echo "  doctl apps logs $APP_ID --follow"
