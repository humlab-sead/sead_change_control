-- Deploy sead_api:20200203_DDL_ADD_DOMAIN_TABLE to pg

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

        if sead_utility.column_exists('facet'::text, 'facet_children'::text, 'facet_code'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;


    	drop table if exists facet.facet_children;

    	create table facet.facet_children (
    		facet_code character varying not null,
    		child_facet_code character varying not null,
    		position int not null default(0),
    		constraint fk_facet_children_facet_code_facet_code foreign key (facet_code)
    			references facet.facet (facet_code) match simple on update no action on delete no action,
    		constraint fk_facet_children_child_facet_code_facet_code foreign key (child_facet_code)
    			references facet.facet (facet_code) match simple on update no action on delete no action,
    		constraint child_facet_pkey primary key (facet_code, child_facet_code)
    	);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
