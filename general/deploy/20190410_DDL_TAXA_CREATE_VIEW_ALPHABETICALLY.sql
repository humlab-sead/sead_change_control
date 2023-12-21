-- Deploy general: 20190410_DDL_TAXA_CREATE_VIEW_ALPHABETICALLY

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-10
  Description   Create taxa helper view.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/175
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

        if sead_utility.table_exists('public'::text, 'view_taxa_alphabetically'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        create or replace view "public"."view_taxa_alphabetically" as
            select o.order_id,
                o.order_name as "order",
                f.family_id,
                f.family_name as family,
                g.genus_id,
                g.genus_name as genus,
                s.taxon_id,
                s.species,
                a.author_id,
                a.author_name as author
            from ((((tbl_taxa_tree_master s
                join tbl_taxa_tree_genera g on ((s.genus_id = g.genus_id)))
                join tbl_taxa_tree_families f on ((g.family_id = f.family_id)))
                join tbl_taxa_tree_orders o on ((f.order_id = o.order_id)))
                left join tbl_taxa_tree_authors a on ((s.author_id = a.author_id)))
            order by o.order_name, f.family_name, g.genus_name, s.species;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
