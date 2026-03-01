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

You need two things:

1. **A DigitalOcean account** — https://digitalocean.com
2. **A SendGrid API key** — sign up at https://sendgrid.com, then go to **Settings → API Keys → Create API Key** (Full Access). Copy the key — you'll only see it once.

## Deploy

Click the button in [README.md](README.md). DigitalOcean will walk you through a wizard. Fill in these values:

| Variable | What to enter |
|----------|---------------|
| `CAS_DOMAIN` | Leave as `frederick-cas.ondigitalocean.app` unless you have a custom domain |
| `WAREHOUSE_DOMAIN` | Leave as `frederick-warehouse.ondigitalocean.app` unless you have a custom domain |
| `EMAIL_DOMAIN` | Domain for outgoing no-reply emails (e.g. `frederick-cas.org`) |
| `RAILS_MASTER_KEY` | Run `openssl rand -hex 16` in a terminal and paste the result |
| `WAREHOUSE_RAILS_MASTER_KEY` | Run `openssl rand -hex 16` again — use a **different** value |
| `SENDGRID_API_KEY` | Your SendGrid API key |

**Save both master keys somewhere safe before clicking Create.** You cannot retrieve them later.

Deployment takes 10-15 minutes. Watch progress at https://cloud.digitalocean.com/apps.

## After Deployment

### Verify it's running

- CAS: `https://frederick-cas.ondigitalocean.app` — you should see a login page
- Warehouse: `https://frederick-warehouse.ondigitalocean.app` — you should see a login page

### Test email

1. Log into the CAS
2. Go to **Admin → Settings → Test Email**
3. Check your inbox

If email doesn't arrive, check https://app.sendgrid.com/email_activity for bounces.

## Updating

Push to `main` and DigitalOcean rebuilds automatically within 2-5 minutes.

## Troubleshooting

**Build failed** — Check build logs in the DigitalOcean app console. Usually a Ruby or bundler version mismatch.

**GitHub connection failed** — Go to DigitalOcean **Settings → Integrations → GitHub** and reconnect.

**Email not sending** — Verify your `SENDGRID_API_KEY` in the app's environment settings and check https://app.sendgrid.com/settings/sender_auth to authenticate your domain.

**Stuck "In Progress"** — First deploy can take 30 minutes. If still stuck, go to **Actions → Reboot**.
