# Deploying Frederick CAS + HMIS Warehouse on DigitalOcean

## What You're Getting

| Component | Purpose | Cost |
|-----------|---------|------|
| **CAS API** | Matching algorithm + rule engine | Included |
| **HMIS Warehouse** | Aggregates data from agencies + de-duplicates clients | Included |
| **Frontend Website** | What staff see + use | Included |
| **PostgreSQL Database** | Stores all data (CAS + Warehouse + reporting) | $15/month |
| **Redis Cache** | Speeds up matching and reports | $6/month |
| **Compute** | Runs the apps | $12-24/month |
| **Email (SendGrid)** | Notifications | $0-30/month |
| **TOTAL** | | **$33-75/month** |

## Before You Start

You need:

1. **A DigitalOcean account** with an API token — https://cloud.digitalocean.com/account/api/tokens
2. **A SendGrid API key** — sign up at https://sendgrid.com, then go to **Settings → API Keys → Create API Key** (Full Access). Copy the key — you'll only see it once.

## Which Script to Run

| Situation | Script |
|-----------|--------|
| First time — creating the app on DigitalOcean | `./DIGITALOCEAN_SETUP.sh` |
| Triggering a new deployment on an existing app | `./deploy.sh` |

## First-Time Setup

Run `DIGITALOCEAN_SETUP.sh` from the `frederick-cas` directory:

```bash
./DIGITALOCEAN_SETUP.sh
```

The script will:

1. Install `doctl` (DigitalOcean CLI) via snap if not already installed
2. Generate two Rails master keys and display them — **save both before continuing, you will not see them again**
3. Prompt for your domains (press Enter to accept the defaults)
4. Prompt for your DigitalOcean API token and SendGrid API key (input is hidden)
5. Authenticate with DigitalOcean and create the app from `app.yaml`

Once complete, initial deployment takes 10–15 minutes. Watch progress with:

```bash
doctl apps logs <APP_ID> --follow
```

## Triggering a Deployment

Run `deploy.sh` any time you want to redeploy:

```bash
./deploy.sh
```

Or pass credentials via environment variables to skip prompts:

```bash
DO_TOKEN=xxx APP_NAME=frederick-cas ./deploy.sh
```

The script will authenticate, list your apps, trigger a forced rebuild, and poll until the deployment completes.

## After Deployment

### Verify it's running

- CAS: `https://frederick-cas.ondigitalocean.app` — you should see a login page
- Warehouse: `https://frederick-warehouse.ondigitalocean.app` — you should see a login page

### Test email

1. Log into the CAS
2. Go to **Admin → Settings → Test Email**
3. Check your inbox

If email doesn't arrive, check https://app.sendgrid.com/email_activity for bounces.

## Troubleshooting

**Build failed** — Check build logs in the DigitalOcean app console. Usually a Ruby or bundler version mismatch.

**GitHub connection failed** — Go to DigitalOcean **Settings → Integrations → GitHub** and reconnect.

**Email not sending** — Verify your `SENDGRID_API_KEY` in the app's environment settings and check https://app.sendgrid.com/settings/sender_auth to authenticate your domain.

**Stuck "In Progress"** — First deploy can take 30 minutes. If still stuck, go to **Actions → Reboot**.
