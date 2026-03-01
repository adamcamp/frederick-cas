# Getting Started with Frederick CAS

This guide is for housing coordinators, agency staff, and administrators setting up and using the Coordinated Access System (CAS) for the first time.

---

## What Does the CAS Do?

The CAS matches people experiencing homelessness to available housing. When a housing slot opens up, the system automatically finds eligible candidates, ranks them by need, and routes the match through an approval workflow involving the relevant agencies.

Think of it as a structured process that replaces spreadsheets and phone tag with a shared, auditable system.

---

## First Login

Go to your CAS URL (e.g. `https://frederick-cas.ondigitalocean.app`) and log in with the admin account created during setup.

Start in **Admin** (top navigation) to configure the system before any matching can happen.

---

## Step 1: Set Up Agencies

Agencies are the organizations that participate in the matching process — housing authorities, shelter providers, service agencies, and your lead coordinating organization.

1. Go to **Admin → Agencies → New Agency**
2. Enter the agency name and contact information
3. Repeat for each participating organization

---

## Step 2: Add Staff Users

Each person who will use the system needs an account with an appropriate role.

1. Go to **Admin → Users → Invite User**
2. Enter their email and assign a role:

| Role | What They Can Do |
|------|-----------------|
| **Admin** | Full access — manage all settings, users, and data |
| **DND Staff** | Review and approve matches across all programs |
| **Housing Subsidy Admin (HSA)** | Final sign-off on matches, record housing dates |
| **Shelter Agency** | Review clients from their shelter, provide feedback on matches |
| **Program Manager** | Manage their own programs and vouchers |
| **Data Manager** | Import clients, manage client records |

Users receive an email invitation to set their password.

---

## Step 3: Set Up Housing Programs

Programs represent your housing inventory. Each program has one or more sub-programs, and each sub-program has vouchers (the actual slots available for matching).

### Create a Program

1. Go to **Programs → New Program**
2. Enter the program name and funding source (e.g., HUD CoC - PSH, HUD CoC - RRH)
3. Assign the Housing Subsidy Admin agency responsible for this program

### Add a Sub-Program

Within a program, sub-programs represent distinct locations or funding streams.

1. Open the program and click **New Sub-Program**
2. Choose the type:
   - **Project-Based**: Housing units in a specific building
   - **Tenant-Based**: Scattered-site vouchers (client finds their own unit)
3. Add the number of vouchers available

### Set Eligibility Requirements (Optional)

You can restrict who is eligible for a program by adding requirements:

1. Open the program or sub-program and go to **Requirements**
2. Add rules such as:
   - Must be chronically homeless
   - Must be a veteran
   - Must have a specific minimum bedroom size
   - Must have a disability

Requirements set on a program apply to all its sub-programs and vouchers automatically.

---

## Step 4: Add Clients

Clients are the people being matched to housing. There are two ways they get into the system:

### Connected to HMIS Warehouse (Automatic)

If your CAS is connected to the HMIS Warehouse, clients flow in automatically from your community's HMIS data. Their assessment scores, housing history, and eligibility information are kept up to date without manual entry.

### Manual Import

If you're not using the Warehouse connection:

1. Go to **Clients → Import**
2. Upload a CSV with client data (name, date of birth, assessment score, housing history)
3. Review imported records and correct any issues

### Client Availability

Once in the system, each client has an availability status per matching route:

- **Available** — eligible to be matched
- **Matched** — currently in an active match process
- **Parked** — temporarily unavailable (e.g., in another program, declined housing, or not ready). A reason is required and is visible in reports.

---

## Step 5: How Matching Works

Once you have housing slots and available clients, the matching engine runs automatically.

### When a Voucher Becomes Available

1. A staff member marks a voucher as **available** in the system
2. The matching engine finds all clients who meet the eligibility requirements
3. Clients are ranked by your community's prioritization criteria (typically: chronic homelessness status, assessment score, length of homelessness)
4. The top-ranked client is proposed as a match

### The Match Workflow

A match moves through a series of decision steps, each handled by a different role. A typical workflow:

```
Voucher available
      ↓
DND Staff reviews → Proceed or Decline
      ↓
Shelter Agency reviews → Accept or Decline
      ↓
Housing Subsidy Admin reviews → Accept or Decline
      ↓
Match confirmed → Housing date recorded
```

At each step, the assigned staff member receives an email notification. They log into the CAS, review the client's information, and record their decision. If they decline, they must select a reason — this creates an audit trail.

If a match is declined at any step, the next eligible client on the ranked list is automatically proposed.

### Finding Matches

Staff can view their outstanding decisions at **Matches → My Queue**, which shows every match waiting on their action.

---

## Step 6: Day-to-Day Operations

### Your Daily Checklist

**Housing Subsidy Admins:**
- Check **Matches → My Queue** for matches waiting on your decision
- Record housing dates when a client moves in: open the match → **Record Housing Date**
- Add new vouchers when units become available: **Programs → [Your Program] → Add Voucher**

**Shelter Agency Staff:**
- Check **Matches → My Queue** for client reviews pending your input
- Update client availability if someone is no longer a candidate: open the client → **Availability**

**DND / Lead Agency Staff:**
- Monitor **Dashboard** for overall match progress and bottlenecks
- Review matches flagged for escalation
- Manage parked clients: **Clients → Parked** to review and re-activate when appropriate

---

## Reports

Go to **Reports** to see:

| Report | What It Shows |
|--------|---------------|
| **Dashboard** | High-level summary of matches in progress and available vouchers |
| **Match Progress** | Where matches are getting stuck in the workflow |
| **Parked Clients** | Who's unavailable and why |
| **Housed** | Successfully placed clients with housing dates |
| **Agency Interactions** | Which agencies are participating in matches |

---

## Common Questions

**A client was matched to the wrong program. What do I do?**
Open the match and click **Decline** with the reason "Wrong program type." The next eligible client will be proposed, and the declined client remains available for other matches.

**A client has been housed outside of the CAS. How do I record it?**
Go to the client record → **Mark as Housed**. Enter the housing date and program. This removes them from the active matching pool.

**A voucher has been on hold for months. Can I pause it?**
Yes — open the voucher and set its status to **Inactive**. It won't generate new matches until you reactivate it.

**How do I add a new eligibility rule that doesn't exist yet?**
Contact your system administrator. New rule types require a code change.

**Who gets email notifications?**
Each agency contact assigned to a program receives notifications when a match step requires their action. Manage contacts under **Admin → Contacts**.
