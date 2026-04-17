# Nova Metrics — Hardware Upload SQL Templates

These files let you load your hardware pricelist directly into the Nova Metrics database. The sizing engine uses your prices to build accurate proposals.

## Files — run in this order

| File | What it does |
|------|--------------|
| `00_alter_installer_tables.sql` | Adds useful columns (brand, warranty, chemistry, inverter type). Run once. |
| `01_installer_inverters_template.sql` | Your inverter pricelist |
| `02_installer_batteries_template.sql` | Your battery pricelist |
| `03_installer_panels_template.sql` | Your solar panel pricelist |

## Quick steps

1. **Find your installer_id** — run this in the Supabase SQL editor:
   ```sql
   SELECT installer_id, installer_name FROM installers WHERE contact_email = 'you@yourdomain.com';
   ```
2. **Open each template** in the Supabase SQL editor.
3. **Find & replace** `YOUR_INSTALLER_ID` with the number you found.
4. **Delete models you don't stock.** Keep only what you actually sell.
5. **Update prices** to your actual cost price (excl. VAT).
6. **Uncomment the DELETE line** at the top of each file, then run.

## What the sizing engine uses

### Inverters
| Column | Why it matters |
|--------|----------------|
| `ac_continuous_kw` | Must be ≥ peak load × 1.3 (safety margin) |
| `dc_max_kw` | Must accommodate the solar array DC output |
| `mppt_count` | Determines string allocation |
| `brand` + `inverter_model` | Used to look up NRS 097-2-1 compliance status |
| `unit_price_r` | Used in cost breakdown & payback calculation |

### Batteries
| Column | Why it matters |
|--------|----------------|
| `usable_kwh` | Evening backup capacity per unit |
| `nominal_kw` | Must meet or exceed peak load |
| `unit_price_r` | Used in cost breakdown |

### Panels
| Column | Why it matters |
|--------|----------------|
| `watts` | DC array sizing |
| `area_sqm` | Roof footprint calculation |
| `unit_price_r` | Cost per Wp, total hardware cost |

## Notes
- All prices should be your **buy price excluding VAT**.
- The engine automatically calculates your sell price using the markup % the installer selects at design time.
- The compliance check runs against `master_inverters_compliance` (NRS 097-2-1). Make sure your inverter model names match the official NERSA register names.
