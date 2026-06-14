# Deprecated: MVP-only table definitions

These files were used when the platform used only a **subset** of PPDM Lite 1.1 tables (meta + production + spatial MVP).

They are **no longer run** in init. The platform now uses **full PPDM Lite 1.1 DDL** (`03_ppdm_lite_full_ddl.sql`) plus catalog column and contract seed steps.

- `03_ppdm_lite_meta.sql` — old L_PPDM_TABLE, L_PPDM_COLUMN, L_PPDM_ORIGIN, L_PPDM_EXCEPTION (subset).
- `04_ppdm_lite_production_spatial.sql` — old L_PDEN, L_PDEN_VOL_SUMMARY, L_SP_COMPONENT, edip_feature_geom.

For **Option B** (new environment): run 01 → 02 → 03 (full DDL) → 04 (catalog columns) → 05 → 06 (contract from information_schema) → 07. To migrate existing MVP data into the full schema, use one-time ETL from the old DB into the new one after full DDL is applied.
