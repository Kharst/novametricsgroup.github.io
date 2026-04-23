# Solar Intelligence — Job Execution Schema Setup
## Run this ONE TIME in your Supabase SQL Editor

---

### Step 1 — Open Supabase
1. Go to **https://supabase.com**
2. Click **Sign In** and log into your account
3. Click on your **novametrics** project to open it

---

### Step 2 — Open the SQL Editor
1. In the left sidebar, click **SQL Editor** (it looks like a code icon `</>`)
2. Click **+ New Query** (top right)
3. A blank text area will appear

---

### Step 3 — Paste and Run the SQL
1. Open the file `job-execution-schema.sql` (it is in this same folder)
2. Select ALL the text inside it (Ctrl+A on Windows, Cmd+A on Mac)
3. Copy it (Ctrl+C / Cmd+C)
4. Click back in the Supabase SQL Editor blank area
5. Paste it (Ctrl+V / Cmd+V)
6. Click the green **Run** button (bottom right of the SQL editor)
7. You should see: **Success. No rows returned.**

If you see any red errors, read them carefully. Most can be ignored if they say `already exists`.

---

### Step 4 — Verify the tables were created
1. In the left sidebar, click **Table Editor**
2. You should now see these 3 new tables:
   - `site_visit_results`
   - `proposal_versions`
   - `installation_jobs`
3. You should also see that `ai_results` now has extra columns:
   - `site_visit_completed_at`
   - `installation_scheduled_at`
   - `installation_started_at`
   - `installation_completed_at`

If you see all of the above — you are done! ✅

---

### Pipeline Flow Reference

This is how a job moves through the system:

```
Proposal Portal                    Job Portal
─────────────────────────────────────────────────────
Client accepts proposal
  ↓
Installer books site visit         
  [saveBooking sets status = site_visit_scheduled]
  ↓                                 Job appears in Job Portal
                                     ↓
                                    Installer completes site visit
                                    [status → site_visit_completed]
                                     ↓
                                    Installer schedules installation
                                    [status → installation_scheduled]
                                     ↓
                                    Installer starts installation
                                    [status → installation_in_progress]
                                     ↓
                                    Installer marks complete
                                    [status → completed]
                                     ↓
                                    Handover document generated
```

---

### If something goes wrong
- The SQL is safe to run more than once — it uses `IF NOT EXISTS` so it will not break anything
- If a table already exists, the SQL will skip creating it
- Contact support with the exact error message shown in the SQL editor
