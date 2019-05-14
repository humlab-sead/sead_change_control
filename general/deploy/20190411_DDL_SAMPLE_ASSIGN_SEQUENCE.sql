-- Deploy sead_change_control:CS_SAMPLE__20190411_ASSIGN_SEQUENCE to pg

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
    
        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        alter table "public"."tbl_sample_location_type_sampling_contexts"
            drop constraint "tbl_sample_location_sampling_contexts_pkey";

        alter table "public"."tbl_sample_location_type_sampling_contexts" 
            alter column "sample_location_type_sampling_context_id" 
                set default nextval('tbl_sample_location_type_samp_sample_location_type_sampling_seq'::regclass);

        alter table "public"."tbl_sample_location_type_sampling_contexts"
            add constraint "tbl_sample_location_type_sampling_contexts_pkey"
                primary key ("sample_location_type_sampling_context_id");

        --alter table "public"."tbl_sample_location_type_sampling_contexts"
        --    alter column "sample_location_type_id"
        --        set default nextval('tbl_sample_location_type_sampling_c_sample_location_type_id_seq'::regclass);

        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
