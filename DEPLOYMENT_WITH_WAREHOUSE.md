# Deploying Frederick CAS + HMIS Warehouse on DigitalOcean

This guide covers deploying **both** the Coordinated Access System (CAS) and the HMIS Warehouse together on DigitalOcean.

## What You're Getting

| Component | Purpose | Cost |
|-----------|---------|------|
| **CAS API** | Matching algorithm + rule engine | Included |
| **HMIS Warehouse** | Aggregates data from agencies + de-duplicates clients | Included |
| **Frontend Website** | What staff see + use | Included |
| **PostgreSQL Database** | Stores all data (CAS + Warehouse + reporting) | $15/month |
| **Redis Cache** | Speeds up matching and reports | $6/month |
| **Compute** | Runs the apps | $12-24/month |
| **Email (SendGrid)** | Notifications | $0-30/month (pay-as-you-go) |
| **TOTAL** | Full system | **$45-85/month** |

## Pre-Deployment: What You Need

**GitHub Account**
- Fork these three repositories into your GitHub org:
  - `https://github.com/adamcamp/frederick-cas` → `<YOUR_ORG>/frederick-cas`
  - `https://github.com/adamcamp/hmis-warehouse` → `<YOUR_ORG>/hmis-warehouse`
  - `https://github.com/adamcamp/hmis-frontend` → `<YOUR_ORG>/hmis-frontend`

**DigitalOcean Account**
- Create account at https://digitalocean.com
- Set up a project named "Frederick CAS" (or similar)
- Get API token: https://cloud.digitalocean.com/account/api/tokens

**API Keys**
- **SendGrid API Key**: Sign up free at https://sendgrid.com, then go to Settings → API Keys
- **Rails Master Keys**: Generate two separate keys (one for CAS, one for Warehouse)

To generate Rails keys, run this in your terminal:
```bash
ruby -r securerandom -e "puts SecureRandom.hex(16)"
```

Run this **two times** - you'll have two 32-character hex strings.

## Deployment: The Easy Way

The automated script handles everything except SendGrid setup.

### Step 1: Create SendGrid API Key (5 minutes)

1. Go to https://sendgrid.com and create a free account
2. Click **Settings** → **API Keys** in the left menu
3. Click **Create API Key**
4. Name it "Frederick CAS" and select **Full Access**
5. Copy the key (you'll only see it once)
6. Keep it safe - you'll need it in Step 3

### Step 2: Prepare Your GitHub Repos

In each fork (`boston-cas`, `hmis-warehouse`, `hmis-frontend`), create and commit an empty `.env.production` file:

```bash
# In boston-cas/ directory:
touch .env.production
git add .env.production
git commit -m "Add production env placeholder"
git push origin main

# In hmis-warehouse/ directory:
touch .env.production
git add .env.production
git commit -m "Add production env placeholder"
git push origin main

# In hmis-frontend/ (no .env needed, but make sure it's up to date)
git push origin main
```

### Step 3: Generate Your Rails Master Keys

Open a terminal and run this command **two times**. Each time, copy the output:

```bash
ruby -r securerandom -e "puts SecureRandom.hex(16)"
```

You should have two 32-character strings, like:
- CAS_MASTER_KEY: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`
- WAREHOUSE_MASTER_KEY: `z9y8x7w6v5u4t3s2r1q0p9o8n7m6l5k4`

Keep these safe. Save them in a secure document.

### Step 4: Deploy to DigitalOcean

**Option A: Using the Script (Recommended)**

```bash
# From your workspace directory
bash boston-cas/DIGITALOCEAN_SETUP.sh
```

The script will ask you for:
1. Your DigitalOcean API token
2. SendGrid API key
3. CAS Rails Master Key
4. Warehouse Rails Master Key

Then it will:
- Create the DigitalOcean App
- Configure all environment variables
- Set up the databases
- Deploy your code

**Option B: Manual Deployment**

If you prefer to use the DigitalOcean web console:

1. Log in to https://cloud.digitalocean.com
2. Click **Apps** in the left sidebar
3. Click **Create App**
4. Under **Service Provider**, choose **GitHub**
5. Connect your GitHub account
6. Find your fork of `boston-cas`
7. Under **New App Configuration**, paste the contents of `boston-cas/app.yaml`
8. Enter your SendGrid API key and both Rails master keys when prompted
9. Click **Create Resources**
10. Wait 10-15 minutes for deployment to complete

## Deployment: Step-by-Step Manual Setup

If the automated script doesn't work, follow these steps manually.

### Create the DigitalOcean App

From your fork of `boston-cas`:

**In `app.yaml`, replace these placeholders:**

```yaml
repo: <YOUR_GITHUB_ORG>/boston-cas       # → your-org/boston-cas
repo: <YOUR_GITHUB_ORG>/hmis-warehouse   # → your-org/hmis-warehouse  
repo: <YOUR_GITHUB_ORG>/hmis-frontend    # → your-org/hmis-frontend
${RAILS_MASTER_KEY}                      # → your CAS master key
${WAREHOUSE_RAILS_MASTER_KEY}            # → your warehouse master key
${SENDGRID_API_KEY}                      # → your SendGrid API key
```

Then:

1. Log in to https://cloud.digitalocean.com
2. Click **Apps** in the left sidebar
3. Click **Create App**
4. Choose **GitHub** as the service provider
5. Connect your GitHub account
6. Paste your updated `app.yaml` into the configuration editor
7. Click **Create Resources**

The deployment takes 10-15 minutes. Watch the build logs to see progress.

## After Deployment: Database Setup

Once the app deploys, you need to initialize the warehouse data structure.

### Using DigitalOcean Console

1. In the DigitalOcean app console, click the **warehouse** component
2. In the **Console** tab, run:
   ```bash
   bundle exec rake db:create
   bundle exec rake db:migrate
   ```

3. Click the **api** component
4. In the **Console** tab, run:
   ```bash
   bundle exec rake db:create
   bundle exec rake db:migrate
   ```

### Using SSH

If console access doesn't work:

```bash
# Get the app ID from DigitalOcean
doctl apps get --format 'id' | grep frederick-cas

# SSH into the warehouse worker
doctl apps get-component --format 'instance_ids' frederick-cas warehouse

# Then run migrations
cd /app && bundle exec rake db:migrate
```

## Testing Your Deployment

### Test the CAS

1. Go to: `https://frederick-cas.ondigitalocean.app`
2. You should see the CAS login page
3. Create an admin user (you'll be prompted on first login)

### Test the Warehouse

1. Go to: `https://frederick-warehouse.ondigitalocean.app`
2. You should see the Warehouse login page
3. Create an admin user

### Test Email (SendGrid)

1. Log into the CAS
2. Navigate to **Admin** → **Settings**
3. Click **Test Email**
4. Check your inbox for the test message

If email doesn't arrive:
- Confirm your SendGrid API key is correct
- Check SendGrid's Activity Monitor (https://app.sendgrid.com/email_activity) for bounce messages
- Make sure Frederick's email domain is verified in SendGrid

## Cost Tracking

Monitor your DigitalOcean bill at https://cloud.digitalocean.com/account/billing/overview

**Typical costs:**
- App compute (CAS + Warehouse): $12-24/month
- PostgreSQL (includes 3 databases): $15/month
- Redis: $6/month
- Data transfer (usually free): $0
- Bandwidth (first 250GB free): $0
- **Subtotal**: $33-45/month

**SendGrid costs:**
- Free tier: up to 100 emails/day
- Pay-as-you-go: $0.35 per email for high volume

For Frederick's first 3-6 months, you'll likely stay under $100/month total.

## Troubleshooting

### Apps won't deploy

**Error: "GitHub connection failed"**
- Confirm DigitalOcean has permission to your GitHub repo
- Reconnect your account: Settings → Integrations → GitHub

**Error: "Build failed"**
- Check the build logs in DigitalOcean
- Common causes:
  - Missing Node.js modules: Run `yarn install` before pushing
  - Ruby version conflict: Check `.ruby-version` files match (3.3.x)
  - Gemfile issues: Run `bundle install` locally first

### Databases not created

```bash
# SSH into the CAS app
doctl apps logs frederick-cas api --follow

# Look for migration errors
# If stuck, manually create databases:
doctl databases db create <database-cluster-id> frederick_cas_production
doctl databases db create <database-cluster-id> frederick_warehouse_production
```

### Email not sending

1. Check SendGrid API key is correct in DigitalOcean (not expired)
2. Verify email domain is added in SendGrid settings:
   - Go to https://app.sendgrid.com/settings/sender_auth
   - Add: `frederick-cas.ondigitalocean.app`
3. Check SendGrid's Activity Monitor for bounces/errors

### Apps stuck "In Progress"

1. Wait 30 minutes - first deployment is slow
2. If still stuck, force re-deploy:
   - Click **Actions** → **Reboot**
   - Or push a new commit to trigger rebuild

## Monitoring & Maintenance

### View Logs

In DigitalOcean console:
- **api logs**: `doctl apps logs frederick-cas api --follow`
- **warehouse logs**: `doctl apps logs frederick-cas warehouse --follow`
- **web logs**: `doctl apps logs frederick-cas web --follow`

### Restart Apps

```bash
doctl apps restart frederick-cas
# Or restart individual components:
doctl apps restart frederick-cas --component-name api
doctl apps restart frederick-cas --component-name warehouse
```

### Database Backups

DigitalOcean automatically backs up PostgreSQL daily. To restore:
1. Go to **Databases** in DigitalOcean
2. Click your database cluster
3. Go to **Backups** tab
4. Click **Restore from Backup**

### Update Code

Just commit and push to GitHub:
```bash
git add .
git commit -m "Update configuration"
git push origin main
```

DigitalOcean will automatically rebuild and redeploy within 2-5 minutes.

## Key URLs After Deployment

| Service | URL |
|---------|-----|
| CAS | https://frederick-cas.ondigitalocean.app |
| Warehouse | https://frederick-warehouse.ondigitalocean.app |
| DigitalOcean Console | https://cloud.digitalocean.com/apps |
| SendGrid | https://app.sendgrid.com |

## Support

**DigitalOcean Support**: https://www.digitalocean.com/support
**SendGrid Support**: https://support.sendgrid.com
**System Issues**: Check logs via `doctl apps logs frederick-cas <component> --follow`

## Next Steps

Once deployed and tested:

1. **Configure Agencies**: Add your homeless service agencies to the CAS
2. **Set Up Programs**: Add housing program inventory  
3. **Create User Accounts**: Add staff members from each agency
4. **Configure Matching Rules**: Set up your custom matching algorithm
5. **Import Warehouse Data**: (Optional) Connect to local HMIS systems for data aggregation
6. **Train Staff**: Run training sessions on using the system

---

**Still have questions?** Check [DIGITALOCEAN_DEPLOYMENT_SIMPLE.md](DIGITALOCEAN_DEPLOYMENT_SIMPLE.md) for beginner-friendly explanations, or [DIGITALOCEAN_DEPLOYMENT.md](DIGITALOCEAN_DEPLOYMENT.md) for advanced topics.
