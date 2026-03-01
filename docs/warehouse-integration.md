# Getting Your Clients into the CAS

← [Back to Getting Started](../GETTING_STARTED.md)

There are two ways to get clients into the system. Start with whichever fits where you are today.

---

## Phase 1: Get Running Today (CSV Import)

If your clients are currently tracked in a spreadsheet, you can be matching within hours — no HMIS connection required.

### Step 1: Download the template

Download [migration-template.csv](migration-template.csv) and open it in Excel or Google Sheets.

The template has two example rows. Delete them before importing.

### Step 2: Fill it in from your spreadsheet

Map your existing spreadsheet columns to the template. The table below shows what each column means and what values are accepted.

**Required columns** — the import will fail if these are blank:

| Template Column | What to enter |
|-----------------|---------------|
| **Last Name (Head of Household)** | Client's last name |
| **First Name (Head of Household)** | Client's first name |
| **Email Address** | The caseworker's email (used to identify who submitted the record) |
| **Household is currently:** | Use one of the values in the housing status list below |
| **Cumulative number of days in the last three years** | Total days homeless in the past 3 years (0–1096) |
| **Name of shelter where household resides.** | Exact name of their current shelter |
| **Date household entered above mentioned shelter.** | Entry date in MM/DD/YYYY format |
| **Head of household phone number** | Client's phone number |

**Accepted values for "Household is currently:"**

Use any combination of these, separated by commas:
- `A.1 Literally Homeless` — living on the street or in an emergency shelter
- `A.2 Fleeing / Attempting to flee DV` — fleeing domestic violence
- `A.3 Residing in Boston` — in transitional housing or other temporary arrangement

Most clients will be `A.1 Literally Homeless`. Clients fleeing DV should include both `A.1 Literally Homeless, A.2 Fleeing / Attempting to flee DV`.

**Optional columns** — leave blank if you don't have the data:

| Template Column | What to enter |
|-----------------|---------------|
| **Timestamp** | Date/time of intake (MM/DD/YYYY HH:MM:SS) |
| **Head of Household Year of Birth** | 4-digit birth year (e.g., 1985) |
| **What is the estimated annual income for your household next year?** | Dollar amount (e.g., 12000) |
| **Do you currently have a tenant-based housing choice voucher?** | Yes or No |
| **Voucher administering housing authority/agency** | Required only if voucher = Yes |
| **Are you a veteran?** | Yes or No |
| **Are you seeking any of the following due to a disability?** | `wheelchair`, `elevator`, `other accessibility`, or blank |
| **If you are an individual, would you consider living in a studio?** | Yes or No |
| **If you are an individual, would you consider living in an SRO (single room occupancy)?** | Yes or No |
| **Neighborhood Preference** | Neighborhood name — must match exactly a neighborhood in the system |
| **Case manager/shelter provider contact name** | Caseworker's full name |
| **Case manager/shelter provider contact phone number** | Caseworker's phone |
| **Case manager/shelter provider email address** | Caseworker's email |

Leave all other columns blank.

### Step 3: Import

1. Save the file as CSV (not Excel format)
2. Log into the CAS
3. Go to **Clients → Import**
4. Upload the file

The system will show you how many clients were added and flag any rows that couldn't be imported (with the reason). Fix those rows and re-import — existing clients won't be duplicated.

### Step 4: Review imported clients

Go to **Clients → Imported Clients** and review the list. Each client defaults to **Available**, meaning they can be matched immediately. If any client shouldn't be active yet, open their record and park them.

---

## Phase 2: Connect the HMIS Warehouse (Recommended for Ongoing Use)

The CSV import gets you running fast, but it's a manual process — you'll need to re-import whenever data changes. Once your operation is stable, connecting the HMIS Warehouse eliminates that work.

With the Warehouse connected:
- Client records stay current automatically from your HMIS
- Assessment scores, enrollment history, and eligibility update on a nightly sync
- Consent form status is tracked in one place
- You never touch a spreadsheet again

### What the Warehouse needs

To send a client to the CAS, the Warehouse requires three things:

**1. A client record in your HMIS**
Basic demographics (name, DOB, SSN) plus enrollment records showing shelter stays, outreach contacts, or coordinated entry participation. This is what your HMIS already contains.

**2. Homelessness history**
Calculated automatically from HMIS enrollment records — the Warehouse adds up service dates across all projects. If your HMIS data is complete, this is automatic.

**3. A signed housing release on file**
A staff member uploads the scanned consent form to the Warehouse, tags it with the release type (e.g., "Full Housing Release"), and sets an effective date. Without this, the client will not be sent to the CAS — by design.

### Setting up the Warehouse connection

**This is an IT task.** Have your IT contact:

1. Export HUD-standard CSV files from your HMIS (most HMIS systems support this natively)
2. Upload the ZIP to the Warehouse: **Admin → Data Sources → Upload**
3. Verify clients appear in the Warehouse after import
4. Upload consent forms for active clients: open each client → **Files → Upload** → tag as "Full Housing Release"
5. Run a manual sync: **Admin → CAS Sync → Run Now**
6. Verify clients appear in the CAS

Ongoing: set up a nightly automated HMIS export and upload schedule with your HMIS administrator.

### Assessment scores

If your assessment scores (VI-SPDAT, Pathways, etc.) are stored in your HMIS, they import automatically. If not, enter them manually in the Warehouse:

1. Open the client's record
2. Go to **Assessments → Add Assessment**
3. Enter the score and collection date

### Transitioning from CSV import to Warehouse

Once the Warehouse is connected, imported clients and Warehouse clients can coexist. Over time, as Warehouse data becomes your primary source, you can retire the CSV import process. Clients matched via the Warehouse will have richer, automatically-updated data — assessment scores, current enrollment status, and days homeless stay current without manual updates.

---

## Comparison

| | CSV Import | Warehouse Connection |
|--|-----------|---------------------|
| **Setup time** | Hours | Days to weeks (IT setup) |
| **Data stays current** | No — manual re-import | Yes — nightly sync |
| **Requires HMIS** | No | Yes |
| **Assessment scores** | Manual entry | Auto-imported from HMIS |
| **Consent tracking** | Not tracked | Tracked via file uploads |
| **Recommended for** | Getting started quickly | Ongoing operations |

Both methods work with the same matching engine. There is no difference in how clients are prioritized or matched — only in how their data gets into the system.
