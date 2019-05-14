-- Deploy sead_change_control:CS_DATA_TYPE_20170517_ADD_TYPES to pg

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
        
        with new_data_types("data_type_id", "data_type_group_id", "data_type_name", "date_updated", "definition") as (values
            (18, 7, 'Categorical & Scaled (0-5', '2017-05-17 13:23:57.600695+02',
                    'Mix of data specified on a scale of 0 to 5 where 0 is absence and 5 is maximum amount of property, and data classified on the presence of a property (e.g. Granite = tempering by granite present)'),
            (19, 3, 'Categorical', '2017-05-17 13:27:13.612876+02', 'Data classified according to a set of predefined categories (e.g. temperature classes; tempering material classes)'),
            (20, 5, 'Percentage', '2017-05-17 13:28:56.394909+02', 'Data expressed as a percentage (i.e. out x of 100)')
        )
            insert into "public"."tbl_data_types"("data_type_id", "data_type_group_id", "data_type_name", "date_updated", "definition")
            select n."data_type_id", n."data_type_group_id", n."data_type_name", n."date_updated", n."definition"
            from new_data_types n
            left join tbl_data_types x using (data_type_id)
            where not x.data_type_id is null;
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
