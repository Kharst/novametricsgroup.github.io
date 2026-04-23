-- ============================================================
-- Solar Intelligence — Job Execution Schema
-- Run in Supabase SQL Editor (safe to re-run: IF NOT EXISTS)
-- ============================================================

-- ── 1. Extend ai_results with execution-phase timestamps ────
ALTER TABLE ai_results
  ADD COLUMN IF NOT EXISTS site_visit_completed_at    timestamptz,
  ADD COLUMN IF NOT EXISTS installation_scheduled_at  timestamptz,
  ADD COLUMN IF NOT EXISTS installation_started_at    timestamptz,
  ADD COLUMN IF NOT EXISTS installation_completed_at  timestamptz;

-- ── 2. Site Visit Results ──────────────────────────────────
CREATE TABLE IF NOT EXISTS site_visit_results (
  id                         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  ai_id                      bigint      NOT NULL,
  installer_id               integer     NOT NULL,
  completed_at               timestamptz DEFAULT now(),
  final_system_kw            numeric(8,2),
  roof_condition             text        CHECK (roof_condition IN ('excellent','good','fair','poor','complex')),
  installation_complexity    text        CHECK (installation_complexity IN ('low','medium','high')),
  changes_required           boolean     DEFAULT false,
  change_notes               text,
  updated_hardware_notes     text,
  photos_placeholder         jsonb       DEFAULT '[]',
  proposal_revision_required boolean     DEFAULT false,
  created_at                 timestamptz DEFAULT now(),
  updated_at                 timestamptz DEFAULT now()
);

-- ── 3. Proposal Versions (audit trail for revisions) ───────
CREATE TABLE IF NOT EXISTS proposal_versions (
  id                         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  ai_id                      bigint      NOT NULL,
  version_number             integer     NOT NULL DEFAULT 1,
  version_label              text,
  changes_summary            text,
  financials_changed         boolean     DEFAULT false,
  client_acceptance_required boolean     DEFAULT false,
  snapshot                   jsonb,
  created_at                 timestamptz DEFAULT now(),
  accepted_at                timestamptz
);

-- ── 4. Installation Jobs ────────────────────────────────────
CREATE TABLE IF NOT EXISTS installation_jobs (
  id                      uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  ai_id                   bigint      NOT NULL,
  installer_id            integer     NOT NULL,
  scheduled_date          date,
  expected_duration_days  integer     DEFAULT 1,
  lead_technician         text,
  crew_members            text,
  crew_notes              text,
  status                  text        DEFAULT 'scheduled'
                          CHECK (status IN ('scheduled','in_progress','completed','cancelled')),
  actual_start_date       timestamptz,
  actual_end_date         timestamptz,
  final_system_kw         numeric(8,2),
  final_panel_count       integer,
  final_inverter          text,
  final_battery           text,
  deviations_from_plan    text,
  completion_notes        text,
  progress_log            jsonb       DEFAULT '[]',
  handover_generated_at   timestamptz,
  created_at              timestamptz DEFAULT now(),
  updated_at              timestamptz DEFAULT now()
);

-- ── 5. Indexes ──────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_svr_ai_id    ON site_visit_results(ai_id);
CREATE INDEX IF NOT EXISTS idx_svr_inst     ON site_visit_results(installer_id);
CREATE INDEX IF NOT EXISTS idx_pv_ai_id     ON proposal_versions(ai_id);
CREATE INDEX IF NOT EXISTS idx_ij_ai_id     ON installation_jobs(ai_id);
CREATE INDEX IF NOT EXISTS idx_ij_installer ON installation_jobs(installer_id);
CREATE INDEX IF NOT EXISTS idx_ij_status    ON installation_jobs(status);
CREATE INDEX IF NOT EXISTS idx_ai_status    ON ai_results(status);

-- ── 6. Row Level Security ───────────────────────────────────
ALTER TABLE site_visit_results  ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_versions   ENABLE ROW LEVEL SECURITY;
ALTER TABLE installation_jobs   ENABLE ROW LEVEL SECURITY;

-- Auth users: full access
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='site_visit_results'  AND policyname='auth_all_svr') THEN
    CREATE POLICY auth_all_svr ON site_visit_results  FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='proposal_versions'   AND policyname='auth_all_pv')  THEN
    CREATE POLICY auth_all_pv  ON proposal_versions   FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='installation_jobs'   AND policyname='auth_all_ij')  THEN
    CREATE POLICY auth_all_ij  ON installation_jobs   FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  -- Anon read (portal boot)
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='site_visit_results'  AND policyname='anon_read_svr') THEN
    CREATE POLICY anon_read_svr ON site_visit_results FOR SELECT TO anon USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='installation_jobs'   AND policyname='anon_read_ij')  THEN
    CREATE POLICY anon_read_ij  ON installation_jobs  FOR SELECT TO anon USING (true);
  END IF;
END $$;

-- ── 7. Pipeline status reference ────────────────────────────
-- ai_results.status progression:
--   accepted → site_visit_scheduled → site_visit_completed
--   → installation_scheduled → installation_in_progress → completed
--
-- Enforcement rules (applied in job-portal.html frontend):
--   • site_visit_completed   requires status = site_visit_scheduled
--   • installation_scheduled requires status = site_visit_completed
--   • installation_in_progress requires status = installation_scheduled
--   • completed              requires status = installation_in_progress
