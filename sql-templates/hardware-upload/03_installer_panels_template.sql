-- ============================================================
-- 03_INSTALLER_PANELS_TEMPLATE.SQL
-- Nova Metrics — Installer Solar Panel Pricelist Upload
--
-- HOW TO USE:
--   1. Replace every YOUR_INSTALLER_ID with your installer_id.
--   2. Delete panels you don't stock.
--   3. Update unit_price_r to YOUR cost price per panel.
--   4. Run DELETE first, then INSERT.
--
-- COLUMN GUIDE:
--   installer_id   : your installer ID
--   panel_model    : full model name as per datasheet
--   brand          : manufacturer name
--   watts          : peak watt (Wp) rating — the number in the panel name
--   area_sqm       : physical size of one panel in m²
--                    Typical: 450W ≈ 1.88 m², 530W ≈ 2.05 m², 550W ≈ 2.10 m²
--                    Half-cut 182mm cell: usually 2.10-2.18 m²
--                    Full-cell 210mm (G12): usually 2.55 m²
--   warranty_years : product + power warranty (typically 10-25 years)
--   unit_price_r   : YOUR buy price per single panel (excl. VAT)
--
-- TIP ON WATTAGE:
--   The sizing engine uses watts and price to select the best panel.
--   If you have multiple tiers (budget / premium) at the same wattage,
--   list them separately so the engine can offer both options.
-- ============================================================

-- Step 1: Clear old data
-- DELETE FROM installer_panels WHERE installer_id = YOUR_INSTALLER_ID;

-- Step 2: Insert your panel pricelist
INSERT INTO installer_panels
  (installer_id, panel_model, brand, watts, area_sqm, warranty_years, unit_price_r)
VALUES

-- ── JA SOLAR ─────────────────────────────────────────────────────────────
-- Most shipped brand globally. Excellent quality/price ratio. Very common in SA.
(YOUR_INSTALLER_ID, 'JA Solar JAM54S30-420/MR',  'JA Solar', 420, 1.88, 25, 1350.00),
(YOUR_INSTALLER_ID, 'JA Solar JAM72S30-545/MR',  'JA Solar', 545, 2.22, 25, 1750.00),
(YOUR_INSTALLER_ID, 'JA Solar JAM72D40-575/LB',  'JA Solar', 575, 2.55, 25, 1900.00),
(YOUR_INSTALLER_ID, 'JA Solar JAM54D40-435/GB',  'JA Solar', 435, 1.90, 25, 1400.00),

-- ── LONGI SOLAR ──────────────────────────────────────────────────────────
-- World's largest solar panel manufacturer. Hi-MO5/6 are their main SA lines.
(YOUR_INSTALLER_ID, 'LONGi Hi-MO5 LR4-72HIH-450M',  'LONGi', 450, 2.02, 25, 1450.00),
(YOUR_INSTALLER_ID, 'LONGi Hi-MO6 LR5-72HTH-545M',  'LONGi', 545, 2.19, 25, 1750.00),
(YOUR_INSTALLER_ID, 'LONGi Hi-MO6 LR5-72HTH-570M',  'LONGi', 570, 2.19, 25, 1850.00),

-- ── CANADIAN SOLAR ───────────────────────────────────────────────────────
-- Well-known brand. HiKu and BiHiKu series common in SA.
(YOUR_INSTALLER_ID, 'Canadian Solar CS6R-440MS',     'Canadian Solar', 440, 1.94, 25, 1400.00),
(YOUR_INSTALLER_ID, 'Canadian Solar CS7N-545MS',     'Canadian Solar', 545, 2.58, 25, 1780.00),
(YOUR_INSTALLER_ID, 'Canadian Solar CS6W-550MS',     'Canadian Solar', 550, 2.56, 25, 1800.00),

-- ── JINKO SOLAR ──────────────────────────────────────────────────────────
-- Cheetah / Tiger series. Very popular in SA commercial installs.
(YOUR_INSTALLER_ID, 'Jinko Tiger Neo JKM430N-54HL4R-V', 'Jinko', 430, 1.88, 25, 1380.00),
(YOUR_INSTALLER_ID, 'Jinko Tiger Neo JKM545N-72HL4-V',  'Jinko', 545, 2.59, 25, 1760.00),
(YOUR_INSTALLER_ID, 'Jinko Tiger Neo JKM580N-72HL4-V',  'Jinko', 580, 2.59, 25, 1920.00),

-- ── TRINA SOLAR ──────────────────────────────────────────────────────────
-- Vertex S and Vertex S+ are their popular SA residential range.
(YOUR_INSTALLER_ID, 'Trina Vertex S TSM-430NEG9RC.20',  'Trina', 430, 1.90, 25, 1380.00),
(YOUR_INSTALLER_ID, 'Trina Vertex TSM-545DE19MC.20',    'Trina', 545, 2.59, 25, 1760.00),
(YOUR_INSTALLER_ID, 'Trina Vertex TSM-580DE21AR.20',    'Trina', 580, 2.59, 25, 1900.00),

-- ── RISEN ENERGY ─────────────────────────────────────────────────────────
-- Budget-friendly. RSM series widely distributed through SA wholesalers.
(YOUR_INSTALLER_ID, 'Risen RSM40-8-410M',  'Risen', 410, 1.88, 25, 1250.00),
(YOUR_INSTALLER_ID, 'Risen RSM110-8-540M', 'Risen', 540, 2.19, 25, 1680.00),
(YOUR_INSTALLER_ID, 'Risen RSM110-8-570M', 'Risen', 570, 2.19, 25, 1820.00),

-- ── SUNTECH ──────────────────────────────────────────────────────────────
-- Budget entry-level. Common in cost-sensitive residential projects.
(YOUR_INSTALLER_ID, 'Suntech STP415S-C54/Umhf',  'Suntech', 415, 1.88, 10, 1200.00),
(YOUR_INSTALLER_ID, 'Suntech STP545S-C72/Uhfp',  'Suntech', 545, 2.18, 10, 1650.00)

; -- end of INSERT

-- Verify your upload
SELECT
  panel_model,
  brand,
  watts         || ' W'     AS panel_size,
  area_sqm      || ' m²'   AS panel_area,
  warranty_years || ' yr'   AS warranty,
  'R' || unit_price_r       AS your_cost_price,
  ROUND(unit_price_r / watts * 1000, 2) || ' R/Wp' AS cost_per_watt_peak
FROM installer_panels
WHERE installer_id = YOUR_INSTALLER_ID
ORDER BY brand, watts;
