# Partner Integration Guide

← [Back to Getting Started](../GETTING_STARTED.md)

Once the CAS is running, it shares data with several types of external partners — automatically through email notifications, on demand through exports, and continuously through its connection to the HMIS Warehouse. This guide explains what each partner receives and how to configure it.

---

## Shelter Agencies

Shelter staff are active participants in the match workflow. The CAS notifies them automatically at each step that requires their action.

### What they receive automatically

**Email notifications** are sent when:
- One of their clients is proposed for a match (action required: accept or decline)
- A match is canceled or the client is no longer being considered
- A match is successfully completed and the client is being housed
- A note is sent to them by your coordinator

Each email includes enough context to act without logging in — but staff can click through to see the full match details.

### What they can see when logged in

Shelter staff see only their own clients. From their account they can:
- View all active matches for their clients (**Matches → My Queue**)
- See the full history and notes for each match
- Update client availability (park/unpark)
- View past housed clients from their shelter

### Setting up shelter agency notifications

Notification routing is controlled by **Contacts**. Each program can have designated contacts who receive emails for that program's matches.

1. Go to **Admin → Contacts**
2. Find or create a contact for the shelter staff member
3. Assign them to the relevant programs

If a shelter staff member isn't receiving emails, check that they have a Contact record with the correct program assignments — not just a user account.

---

## Housing Providers

Housing providers own the units being matched. They may be external to your organization and don't necessarily have CAS accounts.

### Candidate list export

When a slot opens and a match is proposed, housing providers can receive a list of prioritized candidates for that vacancy.

1. Open the opportunity in **Programs → [Program] → [Voucher]**
2. Click **Export Candidates**
3. Download the CSV

The CSV includes the client's name (or a redacted ID for confidential clients), assessment score, referral date, housing preferences, and any notes relevant to the match. The exact columns depend on the match route configured for that program.

### Email notifications

Housing providers can be added as Contacts and receive email notifications at specific match stages — for example, when a client has been approved and is ready to begin the lease process.

Configure this at **Admin → Contacts**, the same way as shelter agencies.

---

## HMIS Warehouse (Housed Data Write-Back)

When a client is successfully housed through the CAS, that outcome is automatically written back to the HMIS Warehouse. This keeps your HMIS data current without a manual update.

### What gets written back

- **Client ID** — links to the HMIS warehouse client record
- **Match ID** — reference back to the CAS match
- **Housing date** — the move-in date recorded in the CAS

This appears in the Warehouse as a housed event and can be used in HMIS reporting, HUD APR submissions, and system performance measures.

### Analytics sync

Beyond housed events, the CAS continuously syncs a full analytics dataset to the Warehouse:

| Analytics Table | What it contains |
|-----------------|------------------|
| `cas_analytics_referrals` | All matches — client, opportunity, status, dates, decline reasons |
| `cas_analytics_clients` | Client demographics and assessment data |
| `cas_analytics_opportunities` | Vacancy details |
| `cas_analytics_steps` | Timeline of each step in every match |
| `cas_analytics_rejection_reasons` | Why matches were declined or canceled |
| `cas_analytics_referral_contacts` | Who was involved in each match |

These tables feed into the Warehouse's reporting layer (including dashboards and HUD reports). Your data team can query them directly or access them through the Warehouse's reporting tools.

The sync runs automatically. No configuration is needed beyond the initial CAS–Warehouse database connection.

---

## External Housing Programs (Referrals)

Not every client who needs housing will match with one of your CAS vouchers. When a client should be referred to an external program — Emergency Housing Vouchers, permanent supportive housing through a partner agency, or another community resource — the CAS tracks that referral.

### Creating an external referral

1. Open the client's record
2. Click **Add External Referral**
3. Select the program and enter the referral date

The referral is logged in the CAS and written to the Warehouse as a referral event (HUD Event Type 17), which appears in coordinated entry reporting.

### Exporting referrals for partners

Go to **Reports → External Referrals** to see all external referrals for a date range. This report can be downloaded as an Excel file and shared with partner programs. It includes:

- Client name and CAS ID
- Assessment type and score
- Referral date
- Domestic violence flag (if applicable)
- Housing status at time of referral
- Notes

---

## Oversight Partners and Funders

If you report to a county, state, or federal funder, the following exports are available.

### Available reports

| Report | Location | Format | What it shows |
|--------|----------|--------|---------------|
| **Housed Addresses** | Reports → Housed Addresses | Excel | Every housed client, move-in date, address, program, lease dates |
| **Match Progress** | Reports → Match Progress | Excel | Active matches, timeline, who's responsible for next step |
| **Agency Interactions** | Reports → Agency Interactions | Excel | Declined and canceled matches with reasons, by agency |
| **Parked Clients** | Reports → Parked Clients | Excel | Clients unavailable for matching, with reasons and expiration dates |
| **Dashboard** | Reports → Dashboard | Web | Live view of matches in progress, open vouchers, outcomes |

All reports can be filtered by date range and, where applicable, by program.

### Sharing dashboard access

If a funder or oversight partner needs ongoing visibility, you can create a read-only account for them:

1. **Admin → Users → Invite User**
2. Assign the **DND Staff** role (gives read access to reports and dashboards without ability to approve matches)

Or, for a partner who should only see their own program's activity, assign the **Shelter Agency** role tied to the relevant agency.

---

## Configuring Notifications

All email notifications route through your organization's SendGrid account. To adjust who receives what:

- **Add or change contacts for a program:** Admin → Contacts
- **Change a user's notification settings:** Admin → Users → [user] → Edit
- **Test that email is working:** Admin → Settings → Test Email
- **View sent emails:** Check https://app.sendgrid.com/email_activity

Notifications are sent at each match stage automatically. You cannot selectively disable individual notification types without a code change — but you can control who receives them by updating Contact assignments.

---

## Summary

| Partner | How they get data | What they receive |
|---------|------------------|-------------------|
| **Shelter agencies** | Email + CAS login | Match updates, client status, housed confirmation |
| **Housing providers** | Email + CSV export | Match notifications, candidate lists |
| **HMIS Warehouse** | Automatic sync | Housed events, full match analytics |
| **External programs** | CAS referral + XLSX export | Client referral details and outcomes |
| **Funders/oversight** | XLSX reports + dashboard | Match progress, housed outcomes, decline reasons |
