# Admin Guide

← [Back to Getting Started](../GETTING_STARTED.md)

As Admin, you have full access to the system. You're responsible for the initial configuration and ongoing management.

---

## Initial Setup

### 1. Create Your Two Shelter Sites as Agencies

Your two shelters serve different populations, so set them up as separate agencies. This lets family shelter staff see only family clients, and individual shelter staff see only their clients.

1. Go to **Admin → Agencies → New Agency**
2. Create **"Family Shelter"**
3. Create **"Individuals Shelter"**

### 2. Invite Your Staff

Go to **Admin → Users → Invite User**. Staff receive an email to set their password.

| Role | Who gets it | Key access |
|------|-------------|------------|
| **Admin** | You (and a backup) | Everything |
| **DND Staff** | Housing coordinators | Review and approve all matches |
| **Housing Subsidy Admin (HSA)** | Staff who record move-ins | Record housing dates, manage units |
| **Shelter Agency** | Family shelter staff → assign to "Family Shelter" | See and act on family clients only |
| **Shelter Agency** | Individuals shelter staff → assign to "Individuals Shelter" | See and act on individual clients only |

A typical small-organization setup: 1 admin, 2 DND Staff coordinators, 1 HSA, 2–3 Shelter Agency staff per shelter.

### 3. Set Up Your Housing Programs

Programs represent the housing types you're placing clients into — not your shelters themselves. Create at least two: one for families, one for individuals.

**For a family housing program:**
1. Go to **Programs → New Program**
2. Enter the program name (e.g., "Family Permanent Supportive Housing") and funding source
3. Under Requirements, add **Part of a Family = true** — this restricts the program to family households
4. Add sub-programs for each distinct housing location or funding stream
5. Add vouchers to each sub-program — each voucher is one available unit

**For an individual housing program:**
1. Same steps, but name it for individuals (e.g., "Individual Rapid Re-Housing")
2. Do not add the family requirement — or explicitly exclude families if needed
3. Add sub-programs and vouchers

Repeat for each program type you operate (PSH, RRH, Emergency Housing Vouchers, etc.).

**Eligibility requirements** let you restrict any program further — for example, requiring chronic homelessness status, veteran status, or a minimum assessment score. These are optional but useful for programs with specific funder requirements.

### 4. Get Clients into the System

See the [Warehouse Integration Guide](warehouse-integration.md). The short version:

- **Quick start:** Use the [migration template](migration-template.csv) — fill it in from your intake records and import at **Clients → Import**. You can have clients in the system within hours.
- **Long-term:** Connect to your HMIS Warehouse for automatic nightly updates. Client records, assessment scores, and enrollment history stay current without manual work.

Make sure each imported client has `family_member` set correctly — this is what determines which programs they can be matched to.

---

## Ongoing Administration

### Managing Staff Accounts

- **Add a new staff member:** Admin → Users → Invite User
- **Change a role or agency assignment:** Admin → Users → find the user → Edit
- **Deactivate a staff member who has left:** Admin → Users → Deactivate (access ends immediately)

When adding shelter staff, always assign them to the correct agency (Family Shelter or Individuals Shelter). Getting this wrong means they'll see the wrong clients.

### Managing Contacts (Email Notifications)

Contacts control who receives email notifications for each program's matches. This is separate from user accounts — a contact is a person associated with a program for notification purposes.

1. Go to **Admin → Contacts**
2. Create a contact for each staff member who should receive match emails
3. Assign each contact to the programs they're responsible for

Typical setup:
- Family shelter staff contacts → assigned to family housing programs
- Individual shelter staff contacts → assigned to individual housing programs
- Coordinators → assigned to all programs

If someone isn't receiving match notifications, check their Contact record and program assignments — not just their user account.

### Managing Housing Programs

- **Add a new program:** Programs → New Program
- **Add a voucher to an existing program:** Programs → [Program] → [Sub-program] → Add Voucher
- **Mark a voucher unavailable** (unit under repair, etc.): Open the voucher → mark Unavailable
- **Edit eligibility requirements:** Programs → [Program] → Requirements

### System Settings

- **Test email delivery:** Admin → Settings → Test Email
- **View sent emails:** https://app.sendgrid.com/email_activity (requires SendGrid login)

---

## Reports

| Report | Use it to |
|--------|-----------|
| **Dashboard** | System-wide view — open vouchers, matches in progress, recent placements |
| **Match Progress** | Find stuck matches and which step they're on |
| **Housed** | Track placements over time by program |
| **Parked Clients** | See who's unavailable, why, and when they might re-enter the pool |
| **Agency Interactions** | Review decline and cancellation reasons by shelter site |
