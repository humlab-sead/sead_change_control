-- Deploy sead_change_control:CS_TAXA_20190503_ATTRIBUTE_TYPE_LENGTH to pg

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
        
        alter table tbl_taxa_measured_attributes
           alter column attribute_type type character varying(255);
           
        alter table tbl_taxa_measured_attributes
           alter column attribute_measure type character varying(255);
   
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
