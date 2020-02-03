-- Deploy sead_change_control:20200203_DML_ADD_YEAR_TYPES to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

do $$
begin

    insert into public.tbl_years_types (years_type_id, name, description)
    	values
         	(0, 'Unknown', 'Unknown years type (either to be defined or unspecified in source)'),
         	(1, 'Calendar', 'Calendar years'),
         	(2, 'C14', 'Radiocarbon years'),
         	(3, 'Radiometric', 'Radiometric years (but not C14)')
    on conflict (years_type_id) do nothing;

end $$;

commit;
