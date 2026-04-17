-- ============================================================
-- 01_INSTALLER_INVERTERS_TEMPLATE.SQL
-- Nova Metrics — Installer Inverter Pricelist Upload
--
-- HOW TO USE:
--   1. Replace every occurrence of YOUR_INSTALLER_ID with
--      your actual installer_id from the installers table.
--      (Ask Nova Metrics support if you don't know it.)
--   2. Delete rows for models you don't stock.
--   3. Update unit_price_r to YOUR cost price (excl. VAT).
--   4. Add rows for any models not listed.
--   5. Run the DELETE first to clear old data, then the INSERTs.
--
-- COLUMN GUIDE:
--   installer_id     : your installer ID (integer)
--   inverter_model   : exact model name as on the datasheet
--   brand            : manufacturer name
--   inverter_type    : 'Hybrid' | 'Grid-Tied' | 'Off-Grid'
--   ac_continuous_kw : continuous AC output in kW (from datasheet)
--   dc_max_kw        : max DC input power in kW (from datasheet)
--   mppt_count       : number of MPPT inputs (from datasheet)
--   efficiency_pct   : peak efficiency % (from datasheet, usually 97-98)
--   unit_price_r     : YOUR buy price in Rands (excl. VAT)
-- ============================================================

-- Step 1: Clear existing inverters for this installer
-- (remove the comment dashes when ready to run)
-- DELETE FROM installer_inverters WHERE installer_id = YOUR_INSTALLER_ID;

-- Step 2: Insert your inverter pricelist
INSERT INTO installer_inverters
  (installer_id, inverter_model, brand, inverter_type, ac_continuous_kw, dc_max_kw, mppt_count, efficiency_pct, unit_price_r)
VALUES

-- ── SUNSYNK ──────────────────────────────────────────────────────────────
-- Most popular hybrid inverter brand in SA. Works with any 48V LiFePO4 battery.
(YOUR_INSTALLER_ID, 'Sunsynk 3.6kW Hybrid',  'Sunsynk', 'Hybrid', 3.6,  4.5,  2, 97.0,  9500.00),
(YOUR_INSTALLER_ID, 'Sunsynk 5kW Hybrid',    'Sunsynk', 'Hybrid', 5.0,  6.2,  2, 97.6, 13500.00),
(YOUR_INSTALLER_ID, 'Sunsynk 8kW Hybrid',    'Sunsynk', 'Hybrid', 8.0, 10.0,  2, 97.6, 19500.00),
(YOUR_INSTALLER_ID, 'Sunsynk 12kW Hybrid',   'Sunsynk', 'Hybrid',12.0, 15.0,  2, 97.6, 29500.00),
(YOUR_INSTALLER_ID, 'Sunsynk 15kW Hybrid',   'Sunsynk', 'Hybrid',15.0, 18.75, 2, 97.6, 36000.00),

-- ── DEYE ─────────────────────────────────────────────────────────────────
-- Popular alternative to Sunsynk — very similar hardware, lower price point.
(YOUR_INSTALLER_ID, 'Deye SUN-3.6K-SG04LP1', 'Deye', 'Hybrid',  3.6,  4.5, 1, 97.7,  8800.00),
(YOUR_INSTALLER_ID, 'Deye SUN-5K-SG04LP1',   'Deye', 'Hybrid',  5.0,  6.5, 1, 97.7, 12800.00),
(YOUR_INSTALLER_ID, 'Deye SUN-8K-SG04LP3',   'Deye', 'Hybrid',  8.0, 12.0, 2, 97.7, 18500.00),
(YOUR_INSTALLER_ID, 'Deye SUN-12K-SG04LP3',  'Deye', 'Hybrid', 12.0, 15.0, 2, 97.7, 27500.00),
(YOUR_INSTALLER_ID, 'Deye SUN-16K-SG04LP3',  'Deye', 'Hybrid', 16.0, 20.0, 2, 97.7, 34000.00),

-- ── VICTRON ENERGY ───────────────────────────────────────────────────────
-- Premium brand. MultiPlus-II is widely used for off-grid & backup.
-- Requires a separate MPPT solar charge controller (SmartSolar).
(YOUR_INSTALLER_ID, 'Victron MultiPlus-II 3kVA/48V',   'Victron', 'Hybrid',  2.4,  3.5, 1, 96.0, 14500.00),
(YOUR_INSTALLER_ID, 'Victron MultiPlus-II 5kVA/48V',   'Victron', 'Hybrid',  4.0,  5.5, 1, 96.0, 19500.00),
(YOUR_INSTALLER_ID, 'Victron MultiPlus-II 10kVA/48V',  'Victron', 'Hybrid',  8.0, 10.0, 1, 96.0, 34000.00),

-- ── GROWATT ──────────────────────────────────────────────────────────────
-- Budget-friendly. SPF series is common for small residential.
(YOUR_INSTALLER_ID, 'Growatt SPF 3000TL LVM-48',  'Growatt', 'Hybrid', 3.0, 4.5, 1, 93.0,  7500.00),
(YOUR_INSTALLER_ID, 'Growatt SPF 5000TL LVM-48',  'Growatt', 'Hybrid', 5.0, 6.5, 1, 93.0, 10500.00),
(YOUR_INSTALLER_ID, 'Growatt MIN 3000TL-XH',      'Growatt', 'Hybrid', 3.0, 4.5, 2, 97.5,  9200.00),
(YOUR_INSTALLER_ID, 'Growatt MIN 6000TL-XH',      'Growatt', 'Hybrid', 6.0, 9.0, 2, 97.5, 15500.00),

-- ── GOODWE ───────────────────────────────────────────────────────────────
-- Reliable mid-range. ET series handles both on- and off-grid.
(YOUR_INSTALLER_ID, 'GoodWe GW3648-ET',  'GoodWe', 'Hybrid',  3.6,  4.6, 2, 97.6,  9800.00),
(YOUR_INSTALLER_ID, 'GoodWe GW5048-ET',  'GoodWe', 'Hybrid',  5.0,  6.5, 2, 97.6, 14200.00),
(YOUR_INSTALLER_ID, 'GoodWe GW10K-ET',   'GoodWe', 'Hybrid', 10.0, 12.0, 2, 97.6, 24500.00),

-- ── HUAWEI ───────────────────────────────────────────────────────────────
-- Commercial favourite. SUN2000 range dominates C&I market.
(YOUR_INSTALLER_ID, 'Huawei SUN2000-3KTL-L1',  'Huawei', 'Grid-Tied',  3.0,  4.0, 2, 98.6, 11000.00),
(YOUR_INSTALLER_ID, 'Huawei SUN2000-5KTL-L1',  'Huawei', 'Grid-Tied',  5.0,  6.5, 2, 98.6, 15000.00),
(YOUR_INSTALLER_ID, 'Huawei SUN2000-10KTL-M1', 'Huawei', 'Grid-Tied', 10.0, 12.0, 3, 98.6, 24000.00),
(YOUR_INSTALLER_ID, 'Huawei SUN2000-20KTL-M3', 'Huawei', 'Grid-Tied', 20.0, 24.0, 3, 98.7, 42000.00),

-- ── SOLIS ────────────────────────────────────────────────────────────────
-- Solid mid-range hybrid. RHI series is common for residential.
(YOUR_INSTALLER_ID, 'Solis RHI-3K-48ES',  'Solis', 'Hybrid',  3.0,  4.0, 1, 97.7,  8500.00),
(YOUR_INSTALLER_ID, 'Solis RHI-5K-48ES',  'Solis', 'Hybrid',  5.0,  6.5, 2, 97.7, 13000.00),
(YOUR_INSTALLER_ID, 'Solis RHI-10K-48ES', 'Solis', 'Hybrid', 10.0, 12.5, 2, 97.7, 23500.00)

; -- end of INSERT

-- Verify your upload
SELECT
  inverter_model,
  brand,
  inverter_type,
  ac_continuous_kw || ' kW AC' AS ac_output,
  dc_max_kw        || ' kW DC' AS dc_input,
  mppt_count       || ' MPPT'  AS mppts,
  'R' || unit_price_r           AS your_cost_price
FROM installer_inverters
WHERE installer_id = YOUR_INSTALLER_ID
ORDER BY brand, ac_continuous_kw;
