# Partner Integration Guide

← [Back to Getting Started](../GETTING_STARTED.md)

The CAS is an internal tool, but it shares data with several external parties — housing providers who supply the units you're matching into, the HMIS Warehouse that feeds your client data, and funders who require outcome reporting. This guide explains what each receives and how to configure it.

---

## Housing Providers

Housing providers own or manage the units your clients are moving into. They may supply vouchers (Section 8, PSH, RRH) and need to know when a client has been approved and is ready to begin a lease.

### What they receive

**Email notifications** at relevant match stages — for example, when a client has been fully approved and is ready to sign a lease. Configure which stages trigger notifications by adding housing provider staff as **Contacts** assigned to the relevant program.

**Candidate list export** — if a housing provider wants to review candidates before a placement is finalized:
1. Open the opportunity in **Programs → [Program] → [Voucher]**
2. Click **Export Candidates**
3. Download the CSV and share with the provider

The CSV includes assessment scores, referral dates, housing preferences, and notes. Client names may be redacted depending on confidentiality settings.

### Setting up housing provider notifications

1. Go to **Admin → Contacts**
2. Create a contact for the housing provider staff member
3. Assign them to the program(s) they supply units for

---

## HMIS Warehouse

### Client data flowing in

Your HMIS Warehouse is the primary source of client records for the CAS. When the Warehouse syncs, it pushes updated client demographics, assessment scores, enrollment history, and eligibility flags to the CAS automatically. See the [Warehouse Integration Guide](warehouse-integration.md) for setup details.

### Housed data written back

When you record a move-in date in the CAS, the outcome is automatically written back to the Warehouse:

- The client's HMIS record is flagged as housed
- The CAS match ID and housing date are recorded
- This appears in Warehouse reporting and contributes to HUD system performance measures (e.g., length of time homeless, successful placement rate)

You don't need to manually update your HMIS when a client is housed through the CAS. The write-back handles it.

### Analytics sync

The CAS continuously exports a full match analytics dataset to the Warehouse:

| Table | Contains |
|-------|----------|
| `cas_analytics_referrals` | All matches — status, dates, outcomes, decline reasons |
| `cas_analytics_clients` | Client demographics and assessment data |
| `cas_analytics_opportunities` | Vacancy and program details |
| `cas_analytics_steps` | Step-by-step timeline for every match |
| `cas_analytics_rejection_reasons` | Why matches were declined or canceled |

Your data team can query these directly or access them through the Warehouse's reporting tools. This is what powers HUD APR submissions and system performance dashboards.

---

## External Referrals

Sometimes a client needs a resource that isn't one of your housing programs — a different agency's voucher, a specialized program for veterans, or another community resource. The CAS tracks these as external referrals.

### Creating a referral

1. Open the client's record
2. Click **Add External Referral**
3. Select the program and enter the referral date

The referral is logged in the CAS and written to the Warehouse as a HUD referral event (Event Type 17), which appears in coordinated entry reporting.

### Exporting referrals

Go to **Reports → External Referrals** to see all referrals for a date range. Download as Excel to share with the receiving program. The export includes client ID, assessment details, referral date, and notes.

---

## Funders and Oversight Bodies

If you report to county, state, or federal funders, the following exports are available on demand.

| Report | Location | Format | Contents |
|--------|----------|--------|----------|
| **Housed Addresses** | Reports → Housed Addresses | Excel | Client name, move-in date, address, program, lease dates |
| **Match Progress** | Reports → Match Progress | Excel | Active matches, current step, timeline |
| **Agency Interactions** | Reports → Agency Interactions | Excel | Declined/canceled matches with documented reasons |
| **Parked Clients** | Reports → Parked Clients | Excel | Unavailable clients with reasons and expiration dates |
| **Dashboard** | Reports → Dashboard | Web | Live view of open vouchers, matches in progress, outcomes |

All reports can be filtered by date range and program.

### Giving a funder read-only access

If a funder or oversight partner needs ongoing visibility into the system:

1. **Admin → Users → Invite User**
2. Assign them the **DND Staff** role — they can view reports and dashboards without being able to approve or act on matches

---

## Notification Configuration

All email notifications route through SendGrid. To manage who receives what:

- **Change contacts for a program:** Admin → Contacts
- **Update a user's notification preferences:** Admin → Users → [user] → Edit
- **Test that email is delivering:** Admin → Settings → Test Email
- **View sent email history:** https://app.sendgrid.com/email_activity

Notifications fire automatically at each match stage. You can control who receives them (via Contact assignments) but not which stages trigger them without a code change.
