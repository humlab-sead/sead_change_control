-- Deploy sead_api:20200507_DDL_FACET_ABUNDANCE_UPDATE to pg

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

    begin

        /* Review/rewrite of facet helper view */
        drop view facet.view_abundance;

        create or replace facet.view_abundance
            with analysis as (
                select analysis_entity_id, method_name
                from tbl_analysis_entities
                join tbl_datasets using (dataset_id)
                join tbl_methods using (method_id)
            ), modification as (
                select abundance_id, modification_type_name
                from tbl_abundance_modifications
                join tbl_modification_types using (modification_type_id)
            )
            select analysis_entity_id,
                    abundance.taxon_id,
                    format('%s %s', analysis.method_name, coalesce(modification.modification_type_name, '')) AS elements_part_mod,
                    abundance.abundance
            from tbl_abundances as abundance
            join analysis using (analysis_entity_id)
            left join modification using (abundance_id);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
