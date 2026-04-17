-- ============================================================
-- 02_INSTALLER_BATTERIES_TEMPLATE.SQL
-- Nova Metrics — Installer Battery Pricelist Upload
--
-- HOW TO USE:
--   1. Replace every YOUR_INSTALLER_ID with your installer_id.
--   2. Delete brands/models you don't carry.
--   3. Update unit_price_r to YOUR cost price per single unit.
--   4. Run DELETE first, then INSERT.
--
-- COLUMN GUIDE:
--   installer_id     : your installer ID
--   battery_model    : exact model name as on datasheet / invoice
--   brand            : manufacturer
--   battery_chemistry: 'LiFePO4' (most modern batteries) | 'Li-Ion' | 'Lead-Acid'
--   usable_kwh       : usable (not nominal) capacity per unit in kWh
--                      e.g. Pylontech US3000C = 3.36 kWh usable
--   nominal_kw       : continuous power output per unit in kW
--                      (this is the POWER, not energy)
--   warranty_years   : product warranty in years
--   unit_price_r     : YOUR buy price per single unit (excl. VAT)
--
-- NOTE ON usable_kwh vs nominal_kWh:
--   Most datasheets show NOMINAL capacity. Usable = Nominal × DoD%.
--   LiFePO4 typical DoD = 90-95%. Example:
--   Pylontech US3000C: Nominal 3.55 kWh × 0.95 = 3.37 kWh usable
-- ============================================================

-- Step 1: Clear old data
-- DELETE FROM installer_batteries WHERE installer_id = YOUR_INSTALLER_ID;

-- Step 2: Insert your battery pricelist
INSERT INTO installer_batteries
  (installer_id, battery_model, brand, battery_chemistry, usable_kwh, nominal_kw, warranty_years, unit_price_r)
VALUES

-- ── PYLONTECH ────────────────────────────────────────────────────────────
-- The most widely installed LiFePO4 brand in SA.
-- US series is 48V rack-mount. Stack up to 16 units per inverter bank.
(YOUR_INSTALLER_ID, 'Pylontech US2000C',  'Pylontech', 'LiFePO4', 2.28, 2.5,  10,  8500.00),
(YOUR_INSTALLER_ID, 'Pylontech US3000C',  'Pylontech', 'LiFePO4', 3.36, 3.5,  10, 10500.00),
(YOUR_INSTALLER_ID, 'Pylontech US5000',   'Pylontech', 'LiFePO4', 4.75, 4.0,  10, 14500.00),
(YOUR_INSTALLER_ID, 'Pylontech UP5000',   'Pylontech', 'LiFePO4', 4.75, 5.0,  10, 15000.00),
(YOUR_INSTALLER_ID, 'Pylontech H48074',   'Pylontech', 'LiFePO4', 7.00, 5.0,  10, 21000.00),

-- ── BYD ──────────────────────────────────────────────────────────────────
-- Premium quality. Battery-Box Premium LVS/LVL series.
-- LVS = low-voltage (48V). LVL = low-voltage large (up to 256V stack).
(YOUR_INSTALLER_ID, 'BYD Battery-Box Premium LVS 4.0',  'BYD', 'LiFePO4', 3.84, 3.0, 10, 14000.00),
(YOUR_INSTALLER_ID, 'BYD Battery-Box Premium LVS 8.0',  'BYD', 'LiFePO4', 7.68, 5.0, 10, 26000.00),
(YOUR_INSTALLER_ID, 'BYD Battery-Box Premium LVL 15.4', 'BYD', 'LiFePO4',14.33, 7.5, 10, 48000.00),

-- ── BSL ──────────────────────────────────────────────────────────────────
-- Locally assembled. Very popular in the SA residential market.
(YOUR_INSTALLER_ID, 'BSL 100Ah 5.12kWh 48V',  'BSL', 'LiFePO4', 4.60, 5.0, 5,  9800.00),
(YOUR_INSTALLER_ID, 'BSL 200Ah 10.24kWh 48V', 'BSL', 'LiFePO4', 9.20, 5.0, 5, 18500.00),

-- ── REVOV ────────────────────────────────────────────────────────────────
-- South African brand. Good value. R9 is a popular high-capacity unit.
(YOUR_INSTALLER_ID, 'Revov 2nd LiFe 100Ah', 'Revov', 'LiFePO4', 4.80, 5.0,  5,  8800.00),
(YOUR_INSTALLER_ID, 'Revov R9 9.6kWh',      'Revov', 'LiFePO4', 9.12, 5.0,  5, 16500.00),

-- ── HUBBLE ───────────────────────────────────────────────────────────────
-- SA brand. AM series is compatible with most hybrid inverters.
(YOUR_INSTALLER_ID, 'Hubble AM-2 2.4kWh', 'Hubble', 'LiFePO4', 2.28, 2.5,  5,  8000.00),
(YOUR_INSTALLER_ID, 'Hubble AM-5 5.5kWh', 'Hubble', 'LiFePO4', 5.22, 5.0,  5, 13000.00),
(YOUR_INSTALLER_ID, 'Hubble Lithium AM-10', 'Hubble','LiFePO4',  9.50, 5.0,  5, 20500.00),

-- ── DYNESS ───────────────────────────────────────────────────────────────
-- Growing brand. Tower series popular for residential.
(YOUR_INSTALLER_ID, 'Dyness B4850 4.8kWh',  'Dyness', 'LiFePO4', 4.56, 5.0,  5,  9500.00),
(YOUR_INSTALLER_ID, 'Dyness Tower T10 9.6kWh','Dyness','LiFePO4', 9.12, 5.0, 10, 18000.00),

-- ── SHOTO ────────────────────────────────────────────────────────────────
-- Reliable mid-range. SDA10 series is common.
(YOUR_INSTALLER_ID, 'Shoto SDA10-48100', 'Shoto', 'LiFePO4', 4.60, 5.0, 5,  9200.00),
(YOUR_INSTALLER_ID, 'Shoto SDA10-48200', 'Shoto', 'LiFePO4', 9.20, 5.0, 5, 17500.00)

; -- end of INSERT

-- Verify your upload
SELECT
  battery_model,
  brand,
  battery_chemistry,
  usable_kwh   || ' kWh usable' AS capacity,
  nominal_kw   || ' kW output'  AS power,
  warranty_years || ' yr warranty' AS warranty,
  'R' || unit_price_r            AS your_cost_price
FROM installer_batteries
WHERE installer_id = YOUR_INSTALLER_ID
ORDER BY brand, usable_kwh;
