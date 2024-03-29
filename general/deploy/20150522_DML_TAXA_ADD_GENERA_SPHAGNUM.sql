-- Deploy general: 20150522_DML_TAXA_ADD_GENERA_SPHAGNUM

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2015-05-22
  Description   Add genera Sphagnum. Origin is sead_master_8 consolidation.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/187
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

        insert into tbl_taxa_tree_orders(order_id, date_updated, order_name, record_type_id, sort_order)
            values (139, '2015-05-22', 'Sphagnales', 2, NULL)
                /*on conflict (order_id) do nothing*/;

        insert into tbl_taxa_tree_families(family_id, date_updated, family_name, order_id)
            values (1980, '2015-05-22', 'Sphagnaceae', 139)
                /*on conflict (family_id) do nothing*/;

        insert into tbl_taxa_tree_genera(genus_id, date_updated, family_id, genus_name)
            values (15468, '2015-05-22', 1980, 'Sphagnum')
                /*on conflict (genus_id) do nothing*/;

        perform sead_utility.sync_sequence('public', 'tbl_taxa_tree_orders');
        perform sead_utility.sync_sequence('public', 'tbl_taxa_tree_families');
        perform sead_utility.sync_sequence('public', 'tbl_taxa_tree_genera');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
