-- ============================================================
-- 00_ALTER_INSTALLER_TABLES.SQL
-- Nova Metrics — run this ONCE to add missing columns
-- that the system needs for compliance matching & display.
--
-- Safe to run multiple times (uses IF NOT EXISTS).
-- ============================================================

-- Add brand column to installer_inverters (already exists via migration)
-- Nothing needed here — brand was added in a previous fix.

-- Add brand column to installer_batteries
ALTER TABLE installer_batteries
  ADD COLUMN IF NOT EXISTS brand TEXT;

-- Add brand column to installer_panels
ALTER TABLE installer_panels
  ADD COLUMN IF NOT EXISTS brand TEXT;

-- Add warranty_years to installer_batteries (useful for proposals)
ALTER TABLE installer_batteries
  ADD COLUMN IF NOT EXISTS warranty_years INTEGER;

-- Add warranty_years to installer_panels
ALTER TABLE installer_panels
  ADD COLUMN IF NOT EXISTS warranty_years INTEGER;

-- Add inverter_type to installer_inverters
-- Values: 'Hybrid' | 'Grid-Tied' | 'Off-Grid'
ALTER TABLE installer_inverters
  ADD COLUMN IF NOT EXISTS inverter_type TEXT DEFAULT 'Hybrid';

-- Add battery_chemistry to installer_batteries
-- Values: 'LiFePO4' | 'Li-Ion' | 'Lead-Acid'
ALTER TABLE installer_batteries
  ADD COLUMN IF NOT EXISTS battery_chemistry TEXT DEFAULT 'LiFePO4';

-- Verify structure
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('installer_inverters','installer_batteries','installer_panels')
  AND table_schema = 'public'
ORDER BY table_name, ordinal_position;
