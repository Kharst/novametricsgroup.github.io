-- ════════════════════════════════════════════════════════════════════
-- Solar Intelligence — RLS + Schema Cleanup + Bug Fixes
-- Run in: https://supabase.com/dashboard/project/zloxcqrhkcohheeixfns/editor
-- Run each SECTION separately so you can verify each step before continuing.
-- ════════════════════════════════════════════════════════════════════


-- ════════════════════════════════════════════════════════════════════
-- SECTION A — HELPER FUNCTION
-- Run this first. All RLS policies below depend on it.
-- ════════════════════════════════════════════════════════════════════

-- Returns the installer_id for whoever is currently logged in via Supabase Auth.
-- Edge functions using the service role key bypass RLS entirely — they are unaffected.
CREATE OR REPLACE FUNCTION current_installer_id()
RETURNS INT STABLE LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT installer_id FROM installers
  WHERE auth_user_id = auth.uid()
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION current_installer_id() TO anon, authenticated;

-- Verify it works for your own session (should return your installer_id):
-- SELECT current_installer_id();


-- ════════════════════════════════════════════════════════════════════
-- SECTION B — ROW LEVEL SECURITY (POPIA compliance)
-- WARNING: Always create policies BEFORE or IN THE SAME STEP as enabling RLS.
-- Enabling RLS with no policy = no one can read anything. Do not separate them.
-- ════════════════════════════════════════════════════════════════════

-- ── clients (contains client PII: names, emails, phones, addresses) ──────────

DROP POLICY IF EXISTS "installer_sees_own_clients" ON clients;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "installer_sees_own_clients"
  ON clients FOR ALL
  USING (installer_id = current_installer_id());

-- ── ai_results (proposals — contains client data + commercial data) ───────

DROP POLICY IF EXISTS "installer_sees_own_proposals" ON ai_results;
ALTER TABLE ai_results ENABLE ROW LEVEL SECURITY;
CREATE POLICY "installer_sees_own_proposals"
  ON ai_results FOR ALL
  USING (installer_id = current_installer_id());

-- ── installer_inverters ────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "installer_sees_own_inverters" ON installer_inverters;
ALTER TABLE installer_inverters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "installer_sees_own_inverters"
  ON installer_inverters FOR ALL
  USING (installer_id = current_installer_id());

-- ── installer_batteries ───────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "installer_sees_own_batteries" ON installer_batteries;
ALTER TABLE installer_batteries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "installer_sees_own_batteries"
  ON installer_batteries FOR ALL
  USING (installer_id = current_installer_id());

-- ── installer_panels ─────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "installer_sees_own_panels" ON installer_panels;
ALTER TABLE installer_panels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "installer_sees_own_panels"
  ON installer_panels FOR ALL
  USING (installer_id = current_installer_id());

-- ── password_resets ──────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "installer_sees_own_resets" ON password_resets;
ALTER TABLE password_resets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "installer_sees_own_resets"
  ON password_resets FOR ALL
  USING (installer_id = current_installer_id());

-- ── Reference tables: public read-only (not PII, deliberate exposure) ───────

DROP POLICY IF EXISTS "public_read_locations" ON solar_locations;
ALTER TABLE solar_locations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_locations"
  ON solar_locations FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_inverter_compliance" ON master_inverters_compliance;
ALTER TABLE master_inverters_compliance ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_inverter_compliance"
  ON master_inverters_compliance FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_battery_models" ON "BatteryModels_DB";
ALTER TABLE "BatteryModels_DB" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_battery_models"
  ON "BatteryModels_DB" FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_panel_models" ON "PanelModels";
ALTER TABLE "PanelModels" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_panel_models"
  ON "PanelModels" FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_load_profiles" ON load_profiles;
ALTER TABLE load_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_load_profiles"
  ON load_profiles FOR SELECT USING (true);

-- Verify RLS is now enabled on all critical tables:
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('clients','ai_results','installer_inverters',
    'installer_batteries','installer_panels','password_resets')
ORDER BY tablename;
-- All rows should show rowsecurity = true


-- ════════════════════════════════════════════════════════════════════
-- SECTION C — SCHEMA CLEANUP
-- Drop the empty ghost proposals table.
-- ai_results is the canonical proposal store.
-- ════════════════════════════════════════════════════════════════════

-- Safety check: only drops if the table is truly empty
DO $$
DECLARE row_count INT;
BEGIN
  SELECT COUNT(*) INTO row_count FROM proposals;
  IF row_count = 0 THEN
    DROP TABLE IF EXISTS proposals CASCADE;
    RAISE NOTICE 'SUCCESS: proposals table dropped. ai_results is now the sole canonical proposal store.';
  ELSE
    RAISE WARNING 'SKIPPED: proposals table has % rows. Review manually before dropping.', row_count;
  END IF;
END $$;


-- ════════════════════════════════════════════════════════════════════
-- SECTION D — BUG FIXES
-- ════════════════════════════════════════════════════════════════════

-- Bug 1: proposal_generated always FALSE despite pdf_url being set
-- Backfill all 9 existing records that have a PDF but the flag is wrong.
UPDATE ai_results
SET
  proposal_generated    = true,
  proposal_generated_at = COALESCE(proposal_generated_at, updated_at, created_at, NOW())
WHERE pdf_url IS NOT NULL
  AND pdf_url <> ''
  AND (proposal_generated = false OR proposal_generated IS NULL);

-- Verify:
SELECT ai_id, proposal_generated, proposal_generated_at, pdf_url
FROM ai_results
ORDER BY created_at DESC
LIMIT 10;

-- Bug 2: Cape Installers (ID=8) has invalid hex color #0B1G1A
-- G is not a valid hex character. Falls back to black in PDF renderer.
UPDATE installers
SET primary_color = '#0B1F3A'   -- safe navy fallback
WHERE installer_id = 8
  AND primary_color = '#0B1G1A';

-- Verify:
SELECT installer_id, installer_name, primary_color FROM installers WHERE installer_id = 8;

-- Bug 3: client_approval_status = 'pending' on jobs where no design change occurred
-- When design_changed = false the approval flow never runs,
-- so 'pending' is misleading. Set to 'not_applicable' instead.
UPDATE jobs
SET client_approval_status = 'not_applicable'
WHERE design_changed = false
  AND client_approval_status = 'pending';

-- Verify:
SELECT job_id, design_changed, client_approval_status
FROM jobs
ORDER BY job_id;


-- ════════════════════════════════════════════════════════════════════
-- SECTION E — LEWIS NZIRA FULL ACCESS
-- (Run this only if you haven't already done it)
-- ════════════════════════════════════════════════════════════════════

UPDATE installers
SET
  subscription_plan = 'professional',
  billing_status    = 'active',
  plan_activated_at = NOW(),
  trial_ends_at     = NULL
WHERE installer_name ILIKE '%lewis%'
   OR installer_name ILIKE '%nzira%';
-- Note: uses ILIKE so it finds him regardless of exact name casing

-- Confirm:
SELECT installer_id, installer_name, contact_email, subscription_plan, billing_status
FROM installers
WHERE installer_name ILIKE '%lewis%' OR installer_name ILIKE '%nzira%';


-- ════════════════════════════════════════════════════════════════════
-- SECTION F — FINAL VERIFICATION
-- Run this after all sections to confirm everything is correct.
-- ════════════════════════════════════════════════════════════════════

-- 1. RLS enabled on all sensitive tables
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'clients','ai_results','installer_inverters',
    'installer_batteries','installer_panels','password_resets'
  )
ORDER BY tablename;

-- 2. All proposals now have correct flags
SELECT
  COUNT(*) FILTER (WHERE pdf_url IS NOT NULL AND proposal_generated = false) AS still_broken,
  COUNT(*) FILTER (WHERE pdf_url IS NOT NULL AND proposal_generated = true) AS fixed
FROM ai_results;
-- still_broken should be 0

-- 3. No pending jobs with no design change
SELECT COUNT(*) AS bad_pending
FROM jobs
WHERE design_changed = false
  AND client_approval_status = 'pending';
-- Should be 0

-- 4. Cape Installers color fixed
SELECT installer_id, installer_name, primary_color
FROM installers
WHERE installer_id = 8;
-- primary_color should be #0B1F3A

-- 5. Billing overview
SELECT subscription_plan, billing_status, COUNT(*) as count
FROM installers
GROUP BY subscription_plan, billing_status
ORDER BY subscription_plan;
