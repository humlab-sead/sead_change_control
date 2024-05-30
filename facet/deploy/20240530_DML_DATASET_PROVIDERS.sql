-- Deploy facet: 20240530_DML_DATASET_PROVIDERS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   Rename of Master Datasets
  Issue         https://github.com/humlab-sead/sead_change_control/issues/131
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
    
        if exists (select 1 from facet.facet where facet_code = 'dataset_provider')  then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        delete from facet.facet_children where child_facet_code = 'dataset_master';

        update facet.facet
            set facet_code = 'dataset_provider',
                display_title = 'Dataset provider',
                description = 'Dataset provider'
        where facet_code = 'dataset_master';
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
