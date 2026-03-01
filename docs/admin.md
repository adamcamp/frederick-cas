# Admin Guide

← [Back to Getting Started](../GETTING_STARTED.md)

As an Admin, you have full access to the system. You're responsible for initial setup and ongoing system management.

---

## Initial Setup

Do these steps once when you first launch the system.

### 1. Add Your Shelters as Agencies

Each participating shelter needs an agency record before you can assign staff to it.

1. Go to **Admin → Agencies → New Agency**
2. Enter the shelter name
3. Repeat for each shelter in your network

### 2. Invite Staff

Invite everyone who will use the system. They'll receive an email to set their password.

**Go to Admin → Users → Invite User** and assign one of these roles:

| Role | Assign to |
|------|-----------|
| **Admin** | You — full access to everything |
| **DND Staff** | Your organization's housing coordinators who approve matches |
| **Housing Subsidy Admin (HSA)** | Staff who record move-in dates and manage housing units |
| **Shelter Agency** | Staff at each partner shelter who review matches for their clients |

Start small — one admin, one or two coordinators from your org, and one contact per shelter. You can always add more later.

When inviting a **Shelter Agency** user, assign them to the correct agency so they only see their shelter's clients.

### 3. Set Up Your Housing Programs

Programs represent the housing types you're matching people into (e.g., Permanent Supportive Housing, Rapid Re-Housing).

1. Go to **Programs → New Program**
2. Enter the program name and funding source
3. Add sub-programs for each distinct location or funding stream within the program
4. Add vouchers — each voucher is one available housing slot

**Eligibility requirements** are optional but powerful. You can restrict a program to specific populations (e.g., must be chronically homeless, must be a veteran). Set these on the program and they apply to all its vouchers automatically.

### 4. Get Clients into the System

Clients are the people being matched to housing.

**Option A: HMIS Warehouse connection (recommended)**
If your CAS is connected to the HMIS Warehouse, client data flows in automatically from the community's HMIS. Assessment scores, housing history, and eligibility are kept current without manual work. Talk to your IT contact to configure this.

**Option B: Manual import**
Go to **Clients → Import** and upload a CSV. The system will walk you through required fields (name, date of birth, assessment score, housing history).

Once imported, review each client's availability status. Clients default to **Available**, meaning they can be matched.

---

## Ongoing Administration

### Managing Users

- **Add a new user:** Admin → Users → Invite User
- **Change a user's role:** Admin → Users → find the user → Edit
- **Deactivate a user:** Admin → Users → find the user → Deactivate (they lose access immediately)

### Managing Agencies

- **Add a new shelter:** Admin → Agencies → New Agency
- **Edit a shelter's name or contacts:** Admin → Agencies → find the agency → Edit

### Managing Contacts and Notifications

Contacts control who receives email notifications for each program. To update:

1. Go to **Admin → Contacts**
2. Find the contact and update their program assignments

### Adding a New Staff Member at a Shelter

1. Go to **Admin → Users → Invite User**
2. Set their role to **Shelter Agency**
3. Assign them to the correct agency

They'll only see clients from their own shelter.

---

## Reports

| Report | Use it to |
|--------|-----------|
| **Dashboard** | See how many matches are in progress and how many vouchers are open |
| **Parked Clients** | Review who's unavailable and why — re-activate when they're ready |
| **Match Progress** | Spot bottlenecks (e.g., a shelter that's slow to respond) |
| **Housed** | Track successful placements over time |
