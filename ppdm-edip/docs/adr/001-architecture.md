# ADR 001: EDIP three-layer and PPDM Lite as consumption contract

## Status

Accepted.

## Context

PPDM Lite 1.1 is a rolled-up, warehouse-style model for decision support and GIS browsing, not a transactional master. Source-of-truth lives upstream (PPDM 3.7 or other systems).

## Decision

- **Bronze**: raw landing (append-only), schema `bronze`.
- **Silver**: conformed, validated staging, schema `silver`.
- **Gold**: PPDM Lite 1.1 consumption layer, schema `ppdm_lite`. Populated only by automated jobs; no direct UI edits.
- **Meta**: operational tables (sources, runs, mapping_registry, essential_policy, dq_table_score), schema `meta`.

Data quality is scored per PPDM Lite table: 60 points essential tranche, 40 optional. If essential coverage &lt; 90%, overall score is capped at 59 and the table is not certified.

## Consequences

- All ingestion must flow Bronze → Silver → ppdm_lite.
- Lineage is recorded in `L_PPDM_ORIGIN`, exceptions in `L_PPDM_EXCEPTION`.
- Contract catalog (`L_PPDM_TABLE`, `L_PPDM_COLUMN`) drives DQ scoring and coverage reporting.
