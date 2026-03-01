# Getting Started with Frederick CAS

The Frederick CAS is a tool for coordinating housing placements across Frederick's shelter system. Your organization runs the system; shelters in the community participate by reviewing matches for their clients.

This guide walks through setup and daily use. Once the system is running, share the role-specific guide with each group of users:

- [Admin Guide](docs/admin.md) — system setup and ongoing administration
- [Coordinator Guide](docs/coordinator.md) — reviewing and approving matches (DND Staff)
- [Housing Subsidy Admin Guide](docs/housing-subsidy-admin.md) — recording move-in dates and managing units
- [Shelter Agency Guide](docs/shelter-agency.md) — reviewing matches for shelter clients
- [Warehouse Integration Guide](docs/warehouse-integration.md) — connecting your existing spreadsheet process to the HMIS Warehouse
- [Partner Integration Guide](docs/partner-integration.md) — how data flows out to shelter agencies, housing providers, the HMIS, and funders

---

## How It Works

When a housing slot opens up, the CAS automatically finds the highest-priority eligible client across all participating shelters, proposes the match, and routes it through an approval process. Each shelter reviews matches for their own clients. Your organization makes the final call.

No more spreadsheets. Every decision is logged.

---

## Initial Setup (Admin)

Do these steps once when you first launch the system.

### 1. Add Your Shelters as Agencies

Each participating shelter needs an agency record.

1. Go to **Admin → Agencies → New Agency**
2. Enter the shelter name
3. Repeat for each shelter

### 2. Invite Staff

Invite everyone who will use the system. They'll receive an email to set their password.

**Go to Admin → Users → Invite User** and assign one of these roles:

| Role | Assign to | Guide |
|------|-----------|-------|
| **Admin** | You — full access to everything | [Admin Guide](docs/admin.md) |
| **DND Staff** | Your organization's housing coordinators who approve matches | [Coordinator Guide](docs/coordinator.md) |
| **Housing Subsidy Admin (HSA)** | Staff who record move-in dates and manage housing units | [HSA Guide](docs/housing-subsidy-admin.md) |
| **Shelter Agency** | Staff at each partner shelter who review matches for their clients | [Shelter Agency Guide](docs/shelter-agency.md) |

Start small. One admin, one or two coordinators from your org, and one contact per shelter.

### 3. Set Up Your Housing Programs

Programs represent the housing types you're matching people into (e.g., Permanent Supportive Housing, Rapid Re-Housing).

1. Go to **Programs → New Program**
2. Enter the program name and funding source
3. Add sub-programs for each distinct location or funding stream within the program
4. Add vouchers — each voucher is one housing slot

**Eligibility requirements** are optional but powerful. You can restrict a program to specific populations (e.g., must be chronically homeless, must be a veteran). Set these on the program and they apply to all its vouchers automatically.

### 4. Get Clients into the System

Clients are the people being matched to housing.

**Option A: HMIS Warehouse connection (recommended)**
If your CAS is connected to the HMIS Warehouse, client data flows in automatically from the community's HMIS. Assessment scores, housing history, and eligibility are kept current without manual work. See the [Warehouse Integration Guide](docs/warehouse-integration.md) for how to move your existing data in.

**Option B: Manual import**
Go to **Clients → Import** and upload a CSV. The system will walk you through required fields (name, date of birth, assessment score, housing history).

Once imported, review each client's availability status. Clients default to **Available**, meaning they can be matched.

---

## How Matching Works

### When a Slot Opens

When one of your housing vouchers becomes available:

1. Open the voucher in the system and mark it **Available**
2. The matching engine automatically finds all eligible clients across all shelters
3. Clients are ranked by priority (chronic homelessness, assessment score, time homeless)
4. The top candidate is proposed as a match

### The Approval Workflow

A typical match moves through these steps:

```
Voucher available
      ↓
Your coordinator reviews the proposed match → Approve or decline
      ↓
The client's shelter reviews → Accept or decline
      ↓
Your housing admin confirms → Records the housing date
```

Everyone gets an email when it's their turn to act. If a match is declined at any step, the reason is recorded and the next eligible client is automatically proposed.

### Acting on a Match

Staff see their pending actions in **Matches → My Queue**. Click into a match to:
- View the client's information and history
- Approve, decline (with a required reason), or defer
- Add notes

---

## Day-to-Day

### Your org's coordinators

- Check **Matches → My Queue** each morning for matches needing your review
- Open a new voucher when a unit becomes available: **Programs → [Program] → Add Voucher → mark Available**
- Review **Reports → Dashboard** for a system-wide snapshot

### Shelter staff

- Check **Matches → My Queue** for clients at their shelter who are in an active match
- Update a client's status if they've left the shelter, been housed elsewhere, or aren't currently a candidate: open the client → **Availability** → **Park** (requires a reason)
- Shelter staff only see their own clients — they cannot see clients from other shelters

### Recording a successful placement

When a client is housed:
1. Open the match → **Record Housing Date**
2. Enter the move-in date
3. The client is removed from the active pool and recorded in the housed report

---

## Reports

| Report | Use it to |
|--------|-----------|
| **Dashboard** | See how many matches are in progress and how many vouchers are open |
| **Parked Clients** | Review who's unavailable and why — re-activate when they're ready |
| **Match Progress** | Spot bottlenecks (e.g., a shelter that's slow to respond) |
| **Housed** | Track successful placements over time |

---

## Common Situations

**A shelter client was housed directly (not through the CAS).** Open the client → **Mark as Housed** → enter the date. This keeps your housed numbers accurate.

**A client declined housing and isn't ready to engage.** Open the client → **Availability** → **Park** → select a reason. They stay in the system but won't be matched until you reactivate them.

**A voucher has been sitting open for a long time.** Check whether all eligible clients are parked or already matched. You may need to revisit eligibility requirements or expand the eligible population.

**A shelter wants to add a new staff member.** Go to **Admin → Users → Invite User**, set their role to Shelter Agency, and assign them to the correct agency. They'll only see their shelter's clients.

**You need to change who gets email notifications for a program.** Go to **Admin → Contacts**, find the contact, and update their program assignments.
