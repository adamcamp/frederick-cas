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
echo -e "${YELLOW}Before running this script, ensure your GitHub account is connected${NC}"
echo -e "${YELLOW}to DigitalOcean at: https://cloud.digitalocean.com/account/integrations${NC}"
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

# Generate secret key bases (128-char hex, matching Rails convention)
CAS_SECRET_KEY_BASE=$(openssl rand -hex 64)
WAREHOUSE_SECRET_KEY_BASE=$(openssl rand -hex 64)

echo -e "${YELLOW}Generated Rails secret key bases — save these somewhere safe:${NC}"
echo ""
echo "  CAS SECRET_KEY_BASE:       $CAS_SECRET_KEY_BASE"
echo "  Warehouse SECRET_KEY_BASE: $WAREHOUSE_SECRET_KEY_BASE"
echo ""
echo -e "${RED}You will not see these again. Copy them now before continuing.${NC}"
echo ""
read -rp "Press Enter when you have saved both keys..."
echo ""

# Collect configuration
read -rp "Domain (default: frederick-cas.adamsworlds.com): " DOMAIN
DOMAIN="${DOMAIN:-frederick-cas.adamsworlds.com}"

read -rp "Email domain for no-reply address (default: adamsworlds.com): " EMAIL_DOMAIN
EMAIL_DOMAIN="${EMAIL_DOMAIN:-adamsworlds.com}"

# Collect secrets (hidden)
echo "The following inputs are hidden."
echo ""

read -rsp "DigitalOcean API Token: " DO_TOKEN
echo ""

read -rsp "SendGrid API Key: " SENDGRID_KEY
echo ""

read -rp "DigitalOcean Spaces region (e.g. nyc3, sfo3): " SPACES_REGION
SPACES_REGION="${SPACES_REGION:-nyc3}"

read -rp "Spaces bucket for temporary uploads (e.g. frederick-warehouse-tmp): " SPACES_TMP_BUCKET
SPACES_TMP_BUCKET="${SPACES_TMP_BUCKET:-frederick-warehouse-tmp}"

read -rp "Spaces bucket for public reports (e.g. frederick-warehouse-public): " SPACES_PUBLIC_BUCKET
SPACES_PUBLIC_BUCKET="${SPACES_PUBLIC_BUCKET:-frederick-warehouse-public}"

read -rsp "Spaces Access Key ID: " SPACES_ACCESS_KEY_ID
echo ""

read -rsp "Spaces Secret Access Key: " SPACES_SECRET_ACCESS_KEY
echo ""

echo ""
echo -e "${YELLOW}Authenticating with DigitalOcean...${NC}"
doctl auth init --access-token "$DO_TOKEN"

# Create managed Valkey cluster if it doesn't already exist
CACHE_CLUSTER_NAME="frederick-cas-cache"
echo ""
echo -e "${YELLOW}Setting up Valkey cluster...${NC}"
EXISTING_CACHE=$(doctl databases list --format Name --no-header 2>/dev/null | grep "^${CACHE_CLUSTER_NAME}$" || true)
if [[ -z "$EXISTING_CACHE" ]]; then
  echo "Creating managed Valkey cluster '${CACHE_CLUSTER_NAME}'..."
  doctl databases create "$CACHE_CLUSTER_NAME" \
    --engine valkey \
    --version 8 \
    --region nyc3 \
    --size db-s-1vcpu-1gb \
    --num-nodes 1
  echo -e "${GREEN}Valkey cluster created ✓${NC}"
else
  echo -e "${GREEN}Valkey cluster '${CACHE_CLUSTER_NAME}' already exists ✓${NC}"
fi

# Build a temp spec with all placeholders filled in.
# Note: ${db.*} and ${cache.*} references are left intact — DigitalOcean
# resolves those automatically from the managed database/cache bindings.
TEMP_SPEC=$(mktemp "$HOME/.frederick-cas-spec-XXXXXX.yaml")
trap "rm -f $TEMP_SPEC" EXIT

sed \
  -e "s|\${DOMAIN}|${DOMAIN}|g" \
  -e "s|\${EMAIL_DOMAIN}|${EMAIL_DOMAIN}|g" \
  -e "s|\${SECRET_KEY_BASE}|${CAS_SECRET_KEY_BASE}|g" \
  -e "s|\${WAREHOUSE_SECRET_KEY_BASE}|${WAREHOUSE_SECRET_KEY_BASE}|g" \
  -e "s|\${SENDGRID_API_KEY}|${SENDGRID_KEY}|g" \
  -e "s|\${CACHE_CLUSTER_NAME}|${CACHE_CLUSTER_NAME}|g" \
  -e "s|\${SPACES_REGION}|${SPACES_REGION}|g" \
  -e "s|\${SPACES_TMP_BUCKET}|${SPACES_TMP_BUCKET}|g" \
  -e "s|\${SPACES_PUBLIC_BUCKET}|${SPACES_PUBLIC_BUCKET}|g" \
  -e "s|\${SPACES_ACCESS_KEY_ID}|${SPACES_ACCESS_KEY_ID}|g" \
  -e "s|\${SPACES_SECRET_ACCESS_KEY}|${SPACES_SECRET_ACCESS_KEY}|g" \
  "$SCRIPT_DIR/app.yaml" > "$TEMP_SPEC"

APP_NAME="frederick-cas"
EXISTING_APP_ID=$(doctl apps list --format Spec.Name,ID --no-header 2>/dev/null | awk -v name="$APP_NAME" '$1 == name { print $2 }')

if [[ -n "$EXISTING_APP_ID" ]]; then
  echo -e "${YELLOW}App '${APP_NAME}' already exists (ID: ${EXISTING_APP_ID}).${NC}"
  echo "To redeploy, use deploy.sh. To recreate it, delete it first:"
  echo "  doctl apps delete $EXISTING_APP_ID"
  exit 0
fi

echo -e "${YELLOW}Creating DigitalOcean App from app.yaml...${NC}"
APP_ID=$(doctl apps create --spec "$TEMP_SPEC" --format ID --no-header)

echo ""
echo -e "${GREEN}App created successfully!${NC}"
echo ""
echo "App ID:  $APP_ID"
echo "Console: https://cloud.digitalocean.com/apps/${APP_ID}"
echo ""
echo "Once deployed (10-15 minutes), your services will be at:"
echo "  Frontend:  https://${DOMAIN}"
echo "  API:       https://${DOMAIN}/api"
echo "  Warehouse: https://${DOMAIN}/warehouse"
echo ""
echo -e "${YELLOW}Watch build progress:${NC}"
echo "  doctl apps logs $APP_ID --follow"
