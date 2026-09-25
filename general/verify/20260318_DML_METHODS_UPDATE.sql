-- Verify general:20260318_DML_METHODS_UPDATE

BEGIN;

-- method 32: description contains "550C for three hours"
select 1/count(*) from tbl_methods
where method_id = 32
  and description like '%550C for three hours%';

-- method 33: description contains "volume specific"
select 1/count(*) from tbl_methods
where method_id = 33
  and description like '%volume specific%';

-- method 35: abbrev = MS-lf
select 1/count(*) from tbl_methods
where method_id = 35
  and method_abbrev_or_alt_name = 'MS-lf';

-- method 36: abbrev = MS-hf
select 1/count(*) from tbl_methods
where method_id = 36
  and method_abbrev_or_alt_name = 'MS-hf';

-- method 37: abbrev = CitP
select 1/count(*) from tbl_methods
where method_id = 37
  and method_abbrev_or_alt_name = 'CitP';

-- method 74: abbrev = CitPOI
select 1/count(*) from tbl_methods
where method_id = 74
  and method_abbrev_or_alt_name = 'CitPOI';

-- method 94: abbrev = CitP HCl
select 1/count(*) from tbl_methods
where method_id = 94
  and method_abbrev_or_alt_name = 'CitP HCl';

ROLLBACK;
