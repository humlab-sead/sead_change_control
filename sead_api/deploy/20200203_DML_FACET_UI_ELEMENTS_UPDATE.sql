-- Deploy sead_api: 20200203_DML_FACET_UI_ELEMENTS_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-02-03
  Description   Change displayed name and sort order
  Issue         https://github.com/humlab-sead/sead_change_control/issues/37
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update facet.facet set display_title = 'Magnetic sus.', description = 'Magnetic sus.' where facet_code = 'tbl_denormalized_measured_values_33_0';
    update facet.facet set display_title = 'Loss of Ignition', description = 'Loss of Ignition' where facet_code = 'tbl_denormalized_measured_values_32';
    update facet.facet set display_title = 'Phosphates', description = 'Phosphates' where facet_code = 'tbl_denormalized_measured_values_37';
    update facet.facet set display_title = 'Taxon' where facet_code = 'species';
    update facet.facet set display_title = 'Countries' where facet_code = 'country';
    update facet.facet set display_title = 'Site' where facet_code = 'site';
    update facet.facet set display_title = 'Sample groups' where facet_code = 'sample_groups';

end $$;
commit;
