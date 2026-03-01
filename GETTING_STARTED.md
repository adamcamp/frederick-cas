# Getting Started with Frederick CAS

Your organization operates two emergency shelters — one for families and one for individuals — along with homeless prevention programs. The CAS manages housing matching for your shelter clients: when a housing slot opens, the system automatically identifies your highest-priority eligible client and routes the match through your staff for approval.

This is an internal tool. All staff using it are part of your organization. There are no external partner agencies.

Once the system is running, share the relevant guide with each group of staff:

- [Admin Guide](docs/admin.md) — system setup and configuration
- [Coordinator Guide](docs/coordinator.md) — reviewing and approving matches
- [Housing Subsidy Admin Guide](docs/housing-subsidy-admin.md) — recording move-in dates and managing housing units
- [Shelter Staff Guide](docs/shelter-agency.md) — confirming match availability for your shelter clients
- [Warehouse Integration Guide](docs/warehouse-integration.md) — getting your client data into the system
- [Partner Integration Guide](docs/partner-integration.md) — data shared with housing providers, the HMIS, and funders
- [Prevention Programs Guide](docs/prevention-programs.md) — how your prevention work connects to the CAS

---

## How It Works

When a housing slot opens:

1. A coordinator marks the voucher **Available**
2. The matching engine finds the highest-priority eligible client across both shelters
3. The coordinator reviews and approves the proposed match
4. The shelter staff confirm the client is ready and available
5. The coordinator or housing admin records the move-in date when the client is housed

Every step is logged. Declined matches are documented with reasons. If a match falls through, the system automatically moves to the next eligible client.

**Family and individual programs are separate.** Families with children are only matched to family housing; individuals are only matched to individual housing. The system enforces this automatically based on how programs are configured.

**Prevention clients are tracked separately** in your HMIS. They don't go through the CAS matching workflow unless they lose housing and enter one of your shelters — at which point they're imported into the CAS like any other shelter client.

---

## Initial Setup

Do these steps once when you first launch the system.

### 1. Set Up Your Two Shelter Sites

Because your two shelters serve different populations, set them up as separate agencies. This keeps your family shelter staff and individual shelter staff focused on their own clients.

1. Go to **Admin → Agencies → New Agency**
2. Create **"Family Shelter"**
3. Create **"Individuals Shelter"**

Your own organization doesn't need a separate agency record — the two shelter sites are enough.

### 2. Invite Your Staff

Go to **Admin → Users → Invite User**. For a small organization, you likely need:

| Role | Assign to | Guide |
|------|-----------|-------|
| **Admin** | Program director or system administrator | [Admin Guide](docs/admin.md) |
| **DND Staff** | Housing coordinators who approve matches | [Coordinator Guide](docs/coordinator.md) |
| **Housing Subsidy Admin (HSA)** | Staff who record move-in dates and manage units | [HSA Guide](docs/housing-subsidy-admin.md) |
| **Shelter Agency** | Family shelter staff — assign to "Family Shelter" agency | [Shelter Staff Guide](docs/shelter-agency.md) |
| **Shelter Agency** | Individuals shelter staff — assign to "Individuals Shelter" agency | [Shelter Staff Guide](docs/shelter-agency.md) |

A small team might be 1 admin, 2 coordinators, 1 HSA, and 2–3 staff per shelter site.

### 3. Set Up Your Housing Programs

Programs are the housing types you're matching clients into — not your shelters. Examples: Permanent Supportive Housing, Rapid Re-Housing, Emergency Housing Vouchers.

**For each program:**

1. Go to **Programs → New Program**
2. Enter the program name and funding source
3. Set eligibility requirements (this is how you separate family and individual housing):
   - For family programs: add the **Part of a Family** requirement
   - For individual programs: no family requirement (or explicitly exclude families)
4. Add sub-programs for distinct locations or funding streams within the program
5. Add vouchers — each voucher represents one available housing slot

**You will typically have at least two programs:** one for families, one for individuals. If you have different funding sources or housing types, create separate programs for each.

### 4. Get Clients into the System

See the [Warehouse Integration Guide](docs/warehouse-integration.md) for the full process. In short:

- **If you have HMIS data:** Export HUD-standard CSV files from your HMIS, upload to the Warehouse, and clients flow in automatically. This is the recommended long-term approach.
- **To get started quickly:** Download the [migration template](docs/migration-template.csv), fill it in from your intake records, and import it at **Clients → Import**. You can be matching within hours.

When clients are imported, the system records whether they are part of a family household. This determines which programs they can be matched to.

---

## How Matching Works

### When a Slot Opens

1. A coordinator opens the voucher and marks it **Available**
2. The system finds all eligible clients for that program:
   - For family programs: only clients with `family_member = true`
   - For individual programs: only clients without family status
3. Clients are ranked by priority: chronic homelessness first, then days homeless, then time in the system
4. The top candidate is proposed as a match

### The Approval Workflow

```
Voucher available
      ↓
Coordinator reviews the proposed match → Approve or decline
      ↓
Shelter staff confirm client is available and ready → Accept or decline
      ↓
Housing admin records the move-in date
```

Everyone involved gets an email at their step. If a match is declined at any point, the reason is logged and the next eligible client is proposed automatically.

---

## Day-to-Day

### Coordinators
- Check **Matches → My Queue** each morning
- Open new vouchers when a housing unit becomes available
- Review **Reports → Dashboard** for a system-wide view of both shelters

### Shelter staff (family shelter or individuals shelter)
- Check **Matches → My Queue** for clients awaiting your confirmation
- If a client has left the shelter, declined housing, or isn't ready: open the client → **Availability → Park** (with a reason)
- You only see clients from your own shelter

### Housing admin
- Check **Matches → My Queue** for clients to move in
- Record move-in date when a client is housed: open the match → **Record Housing Date**

---

## Reports

| Report | Use it to |
|--------|-----------|
| **Dashboard** | See active matches and open vouchers across both programs |
| **Match Progress** | Find matches that are stuck and why |
| **Housed** | Track successful placements by program and date |
| **Parked Clients** | See who's unavailable and when they might be ready |

---

## Common Situations

**A client moved from the individuals shelter to the family shelter (or vice versa).** Update their record to reflect the correct shelter. Their match history follows them.

**A client in your prevention program is about to lose housing.** Once they enter a shelter, import them into the CAS and they'll be eligible for matching. See the [Prevention Programs Guide](docs/prevention-programs.md).

**A client was housed directly outside of the CAS.** Open the client → **Mark as Housed** → enter the date.

**A client declined housing and isn't ready to engage.** Open the client → **Availability → Park** → select a reason. They stay in the system but won't be matched until you reactivate them.

**A voucher has been open for a long time.** Check whether eligible clients are parked or already in a match. You may need to revisit the program's eligibility requirements.

**You need to add a new staff member.** Admin → Users → Invite User. Assign them to the correct role and, for shelter staff, to the correct agency (Family Shelter or Individuals Shelter).
