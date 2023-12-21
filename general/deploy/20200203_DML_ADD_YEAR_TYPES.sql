-- Deploy general: 20200203_DML_ADD_YEAR_TYPES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-02-03
  Description   New year types
  Issue         https://github.com/humlab-sead/sead_change_control/issues/39
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

do $$
begin

    insert into public.tbl_years_types (years_type_id, name, description, date_updated)
    	values
         	(0, 'Unknown', 'Unknown years type (either to be defined or unspecified in source)', '2020-02-09 11:31:15.327791+00'),
         	(1, 'Calendar', 'Calendar years', '2020-02-09 11:31:15.327791+00'),
         	(2, 'C14', 'Radiocarbon years', '2020-02-09 11:31:15.327791+00'),
         	(3, 'Radiometric', 'Radiometric years (but not C14)', '2020-02-09 11:31:15.327791+00')
    on conflict (years_type_id) do nothing;

end $$;

commit;
