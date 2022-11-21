-- Deploy sead_api:20221121_DDL_DELETE_FACET_UDF to pg

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

        -- insert your DDL code here

    Create or replace function facet.delete_facet(i_facet_id integer)
    returns boolean
    language plpgsql
    as $function$
        declare j_tables json;
        declare j_clauses json;
        declare s_facet_code text;
        declare i_aggregate_facet_id int = 0;
    begin

        s_facet_code = (select max(facet_code) from facet.facet where facet_id = i_facet_id);
        raise notice 'facet code: %', i_facet_id;

        if s_facet_code is null then
            raise notice 'facet not found %', i_facet_id;
            return false;
        end if;

        delete from facet.facet_clause where facet_id = i_facet_id;
        delete from facet.facet_table where facet_id = i_facet_id;
        delete from facet.facet_children where s_facet_code in (facet_code, child_facet_code);
        delete from facet.facet_dependency where i_facet_id in (facet_id, dependency_facet_id);
        delete from facet.facet where facet_id = i_facet_id;

	return true;

end
$function$
;
ALTER FUNCTION "facet"."delete_facet"(integer) OWNER TO humlab_admin;
GRANT EXECUTE ON FUNCTION "facet"."delete_facet"(integer) TO humlab_admin; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON FUNCTION "facet"."delete_facet"(integer)  IS NULL;
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
