# Your Two Shelter Sites

← [Back to Getting Started](../GETTING_STARTED.md)

Your organization operates two emergency shelters: one for families with children and one for individuals. This guide explains how the CAS distinguishes between them and what that means for how matching works.

---

## How the System Separates Family and Individual Clients

Every client in the system is tagged as either a family household or an individual when they're imported. This single flag determines which housing programs they can be matched to.

- Clients where `family_member = true` — families with children — are only eligible for programs that include the **Part of a Family** requirement
- All other clients are eligible for individual housing programs

**This is enforced automatically.** A family will never be proposed for individual housing, and an individual will never be proposed for family housing, regardless of what a coordinator does. The eligibility rules on the program control this.

When importing clients via CSV, the `Children Age & Gender` column and the family bedroom preference fields populate this flag automatically. When importing from HMIS, it comes from the enrollment data.

---

## Setting Up Each Shelter Site

In the CAS, each shelter site is an **agency**. This controls which staff see which clients.

- **Family Shelter agency** — staff assigned to this agency see only family clients
- **Individuals Shelter agency** — staff assigned to this agency see only individual clients

This isn't about privacy from other organizations — it's about keeping your own staff focused on the clients they support. A coordinator who works with family shelter residents shouldn't have to wade through the individual shelter caseload to find their clients.

Setting up agencies is a one-time step in **Admin → Agencies → New Agency**. Create one for each shelter site.

---

## How Clients Are Prioritized Within Each Program

When a housing slot opens, the system ranks all eligible clients for that program. Priority order:

1. **Chronically homeless clients** — homeless for more than a year (or repeatedly) with a disabling condition. This is a HUD definition applied consistently across both shelter populations.
2. **Shelter clients with documented need** — currently in emergency shelter with a housing barrier, service need, or disability on record.
3. **All other eligible clients** — ranked by total days homeless in the past three years, then by date they entered the system.

Both your shelter populations compete for housing within their respective program types. The family shelter clients compete only against other family shelter clients (for family housing slots), and individual shelter clients compete only against other individual shelter clients (for individual slots).

---

## Managing Clients Across Both Sites

### When a client moves between shelter sites

If someone moves from the individuals shelter to the family shelter (or vice versa), update their agency assignment in the system:

1. Open the client's record
2. Update the assigned agency to the new shelter site
3. Their match history and priority position are preserved

### When a client leaves without being housed

Park the client to remove them from active matching:

1. Open the client → **Availability → Park**
2. Select a reason (left shelter, refused housing, location, etc.)
3. Set an expiration date if you expect them to return

Parked clients don't lose their accrued homeless days. If they return to either shelter, reactivate them and they re-enter the queue with their full history intact.

### When you need to see across both sites

Coordinators (DND Staff) and Admins can see clients from both shelter sites. Reports at **Reports → Dashboard** and **Reports → Match Progress** cover the full picture across both programs.

---

## Practical Configuration Checklist

- [ ] "Family Shelter" agency created in Admin → Agencies
- [ ] "Individuals Shelter" agency created in Admin → Agencies
- [ ] Family shelter staff accounts created with Shelter Agency role → assigned to "Family Shelter"
- [ ] Individuals shelter staff accounts created with Shelter Agency role → assigned to "Individuals Shelter"
- [ ] Family housing program created with **Part of a Family = true** requirement
- [ ] Individual housing program created (no family requirement)
- [ ] Clients imported with correct family/individual flag
- [ ] Contacts set up for each program's email notifications
