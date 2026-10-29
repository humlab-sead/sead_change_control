-- Check that the target ID blocks are unoccupied
select count(*) from tbl_sites where site_id between 2101 and 3402;

-- Check the second target ID block is exactly 133 rows
select count(*) from tbl_sites where site_id between 5532 and 5644;

-- Check that the child tables not found in submission are unoccupied in the 4235–5644 range
select count(*) from tbl_site_natgridrefs where site_id between 4235 and 5644;
select count(*) from tbl_site_images where site_id between 4235 and 5644;
select count(*) from tbl_site_preservation_status where site_id between 4235 and 5644;

-- Check whether one site holds both 2278 and 4412, or whether either ID is assigned to a different site
select * from tbl_sites where site_id in (2278, 4412);

select count(*)
from bugs_import.bugs_trace b
join tbl_sites s on s.site_id = b.sead_reference_id
where sead_table = 'tbl_sites';

