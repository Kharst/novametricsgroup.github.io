-- ════════════════════════════════════════════════════════════════════
-- Solar Intelligence — Billing Infrastructure Migration
-- Run in: https://supabase.com/dashboard/project/zloxcqrhkcohheeixfns/editor
-- ════════════════════════════════════════════════════════════════════

-- ── 1. Add billing columns to installers ──────────────────────────────────
ALTER TABLE installers
  ADD COLUMN IF NOT EXISTS subscription_plan       TEXT      DEFAULT 'trial',
  ADD COLUMN IF NOT EXISTS billing_status          TEXT      DEFAULT 'trialing',
  ADD COLUMN IF NOT EXISTS trial_ends_at           TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '60 days'),
  ADD COLUMN IF NOT EXISTS plan_activated_at       TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS last_payment_at         TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS next_billing_date       DATE,
  ADD COLUMN IF NOT EXISTS proposal_count_this_month INT     DEFAULT 0,
  ADD COLUMN IF NOT EXISTS billing_cycle_start     DATE      DEFAULT CURRENT_DATE,
  ADD COLUMN IF NOT EXISTS payfast_subscription_token TEXT,
  ADD COLUMN IF NOT EXISTS payfast_payment_id      TEXT;

-- ── 2. Nova Metrics (installer_id = 1) — permanently active Professional ──
UPDATE installers
SET subscription_plan = 'professional',
    billing_status    = 'active',
    plan_activated_at = NOW(),
    trial_ends_at     = NULL
WHERE installer_id = 1;

-- ── 3. All other existing installers — 60-day trial ───────────────────────
-- Generous: they are already using the platform; gives them time to upgrade.
UPDATE installers
SET subscription_plan = 'trial',
    billing_status    = 'trialing',
    trial_ends_at     = COALESCE(trial_ends_at, NOW() + INTERVAL '60 days')
WHERE installer_id != 1;

-- ── 4. check_billing_status — called by frontend on every login ────────────
CREATE OR REPLACE FUNCTION check_billing_status(p_installer_id INT)
RETURNS JSON LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE inst RECORD;
BEGIN
  SELECT installer_id, subscription_plan, billing_status,
         trial_ends_at, plan_activated_at, last_payment_at,
         next_billing_date, proposal_count_this_month
  INTO inst FROM installers WHERE installer_id = p_installer_id;

  IF NOT FOUND THEN
    RETURN json_build_object('allowed', false, 'reason', 'not_found');
  END IF;

  -- Nova Metrics admin always passes through
  IF p_installer_id = 1 THEN
    RETURN json_build_object('allowed', true, 'plan', 'professional', 'status', 'active');
  END IF;

  -- ── TRIALING ──
  IF inst.billing_status = 'trialing' THEN
    IF inst.trial_ends_at IS NOT NULL AND inst.trial_ends_at < NOW() THEN
      RETURN json_build_object(
        'allowed', false, 'reason', 'trial_expired',
        'plan', 'trial', 'status', 'trialing'
      );
    END IF;
    IF COALESCE(inst.proposal_count_this_month, 0) >= 5 THEN
      RETURN json_build_object(
        'allowed', false, 'reason', 'trial_limit_reached',
        'plan', 'trial', 'status', 'trialing',
        'proposals_used', inst.proposal_count_this_month,
        'proposals_limit', 5
      );
    END IF;
    RETURN json_build_object(
      'allowed', true, 'plan', 'trial', 'status', 'trialing',
      'trial_ends_at',   inst.trial_ends_at,
      'days_remaining',  GREATEST(0, EXTRACT(DAY FROM (inst.trial_ends_at - NOW()))::INT),
      'proposals_used',  COALESCE(inst.proposal_count_this_month, 0),
      'proposals_limit', 5
    );
  END IF;

  -- ── ACTIVE ──
  IF inst.billing_status = 'active' THEN
    RETURN json_build_object(
      'allowed', true,
      'plan',   inst.subscription_plan,
      'status', 'active',
      'proposals_used',    COALESCE(inst.proposal_count_this_month, 0),
      'next_billing_date', inst.next_billing_date
    );
  END IF;

  -- ── GRACE (payment failed but within grace window) ──
  IF inst.billing_status = 'grace' THEN
    RETURN json_build_object(
      'allowed', true,
      'plan',    inst.subscription_plan,
      'status',  'grace',
      'warning', 'Payment overdue — please update your payment details'
    );
  END IF;

  -- ── OVERDUE / CANCELLED ──
  RETURN json_build_object(
    'allowed', false,
    'reason',  'billing_' || inst.billing_status,
    'plan',    inst.subscription_plan,
    'status',  inst.billing_status
  );
END;
$$;

-- ── 5. increment_proposal_count — call after every successful proposal gen ─
CREATE OR REPLACE FUNCTION increment_proposal_count(p_installer_id INT)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Auto-reset if we've entered a new billing month
  UPDATE installers
  SET proposal_count_this_month = 0,
      billing_cycle_start       = CURRENT_DATE
  WHERE installer_id = p_installer_id
    AND billing_cycle_start < date_trunc('month', CURRENT_DATE);

  -- Increment
  UPDATE installers
  SET proposal_count_this_month = COALESCE(proposal_count_this_month, 0) + 1
  WHERE installer_id = p_installer_id;
END;
$$;

-- ── 6. Grant RPC access ────────────────────────────────────────────────────
GRANT EXECUTE ON FUNCTION check_billing_status(INT)    TO anon, authenticated;
GRANT EXECUTE ON FUNCTION increment_proposal_count(INT) TO anon, authenticated;

-- ── 7. Verify result ───────────────────────────────────────────────────────
SELECT installer_id, installer_name, subscription_plan, billing_status, trial_ends_at
FROM installers
ORDER BY installer_id;
