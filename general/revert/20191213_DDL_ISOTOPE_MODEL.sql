-- Revert sead_change_control:20191012_DDL_ISOTOPE_MODEL from pg

BEGIN;

    drop table if exists public.tbl_isotope_standards;
    drop table if exists public.tbl_isotopes;
    drop table if exists public.tbl_isotope_types;
    drop table if exists public.tbl_isotope_measurments;

COMMIT;
