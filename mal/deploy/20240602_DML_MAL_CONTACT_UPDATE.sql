-- Deploy mal: 20240602_DML_MAL_CONTACT_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-06-02
  Description   Update phil's contact information.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/108
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    update tbl_dataset_masters set url = 'https://www.umu.se/forskning/infrastruktur/mal/' where master_set_id = 2;

    update tbl_contacts
        set email = 'phil.buckland@arke.umu.se',
            url = 'https://www.umu.se/en/staff/philip-buckland/'
    where contact_id = 1;

    update tbl_contacts
        set url = 'https://www.umu.se/en/staff/mattias-sjolander/'
    where contact_id = 67;
    
end $$;
commit;
