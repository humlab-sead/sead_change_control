-- Revert general: 20191213_DDL_ISOTOPE_MODEL

BEGIN;

    drop table if exists public.tbl_isotope_standards;
    drop table if exists public.tbl_isotopes;
    drop table if exists public.tbl_isotope_types;
    drop table if exists public.tbl_isotope_measurements;

COMMIT;
