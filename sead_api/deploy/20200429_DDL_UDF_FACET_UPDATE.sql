-- Deploy sead_api:20200429_DDL_UDF_FACET_UPDATE to pg

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

        create or replace function facet.create_or_update_facet(j_facet jsonb)
        returns json
        as $body$
            declare j_tables json;
            declare j_clauses json;
            declare i_facet_id int;
            declare s_facet_code text;
            declare s_aggregate_facet_code text;
            declare i_aggregate_facet_id int = 0;
        begin

            j_tables = j_facet -> 'tables';
            j_clauses = j_facet -> 'clauses';

            i_facet_id = (j_facet ->> 'facet_id')::int;
            s_facet_code = (j_facet ->> 'facet_code')::int;
            if i_facet_id is null then
                i_facet_id = (select coalesce(max(facet_id),0)+1 from facet.facet);
            else

                delete from facet.facet_children
                    where  s_facet_code in (facet_code, child_facet_code);

                delete from facet.facet
                    where facet_id = i_facet_id;

            end if;

            s_aggregate_facet_code = (j_facet ->> 'aggregate_facet_code')::text;

            if  s_aggregate_facet_code is null then
                i_aggregate_facet_id = 0;
            else
                i_aggregate_facet_id = (select facet_id from facet.facet where facet_code = s_aggregate_facet_code);
                if i_aggregate_facet_id is null then
                    raise notice 'aggregate_facet_id not found for "%" - "%"', (j_facet ->> 'facet_code')::text, s_aggregate_facet_code;
                end if;
            end if;

            insert into facet.facet (facet_id, facet_code, display_title, description, facet_group_id, facet_type_id, category_id_expr, category_name_expr, sort_expr, is_applicable, is_default, aggregate_type, aggregate_title, aggregate_facet_id)
                (values (
                    i_facet_id,
                    (j_facet ->> 'facet_code')::text,
                    (j_facet ->> 'display_title')::text,
                    (j_facet ->> 'description')::text,
                    (j_facet ->> 'facet_group_id')::int,
                    (j_facet ->> 'facet_type_id')::text::int,
                    (j_facet ->> 'category_id_expr')::text,
                    (j_facet ->> 'category_name_expr')::text,
                    (j_facet ->> 'sort_expr')::text,
                    (j_facet ->> 'is_applicable')::boolean,
                    (j_facet ->> 'is_default')::boolean,
                    (j_facet ->> 'aggregate_type')::text,
                    (j_facet ->> 'aggregate_title')::text,
                    i_aggregate_facet_id
                ))
            on conflict (facet_id)
                do update set
                    facet_code = excluded.facet_code,
                    display_title = excluded.display_title,
                    description = excluded.description,
                    facet_group_id = excluded.facet_group_id,
                    facet_type_id = excluded.facet_type_id,
                    category_id_expr = excluded.category_id_expr,
                    category_name_expr = excluded.category_name_expr,
                    sort_expr = excluded.sort_expr,
                    is_applicable = excluded.is_applicable,
                    is_default = excluded.is_default,
                    aggregate_type = excluded.aggregate_type,
                    aggregate_title = excluded.aggregate_title,
                    aggregate_facet_id = excluded.aggregate_facet_id;

            insert into facet.facet_table (facet_id, sequence_id, table_id, udf_call_arguments, alias)
                select i_facet_id, sequence_id, table_id, udf_call_arguments, alias
                from (
                    select  (v ->> 'sequence_id')::int           as sequence_id,
                            (v ->> 'table_name')::text           as table_or_udf_name,
                            (v ->> 'udf_call_arguments')::text as udf_call_arguments,
                            (v ->> 'alias')                       as alias
                    from jsonb_array_elements(j_facet -> 'tables') as v
                ) as v(sequence_id, table_or_udf_name, udf_call_arguments, alias)
                left join facet.table t using (table_or_udf_name);

            insert into facet.facet_clause (facet_id, clause, enforce_constraint)
                select i_facet_id,
                        (v ->> 'clause')::text,
                        (v ->> 'enforce_constraint')::bool
                from jsonb_array_elements(j_facet -> 'clauses') as v;

            return j_facet;

        end $body$ language plpgsql;

    create or replace function facet.export_facets_to_json()
        returns text as $body$

        declare json_template text;
        declare json_table_template text;
        declare json_clause_template text;
        declare json_facet text;
        declare json_facets text;
        declare json_table text;
        declare json_clause text;
        declare r_facet record;
        declare r_facet_table record;
        declare r_facet_clause record;

        begin

            json_template = $_$
            {
                "facet_id": %s,
                "facet_code": "%s",
                "display_title": "%s",
                "description": "%s",
                "facet_group_id":"%s",
                "facet_type_id": %s,
                "category_id_expr": "%s",
                "category_name_expr": "%s",
                "sort_expr": "%s",
                "is_applicable": %s,
                "is_default": %s,
                "aggregate_type": "%s",
                "aggregate_title": "%s",
                "aggregate_facet_code": %s,
                "tables": [ %s ],
                "clauses": [ %s ]
            }$_$;

            json_table_template = $_$
                    {
                        "sequence_id": %s,
                        "table_name": "%s",
                        "udf_call_arguments": %s,
                        "alias":  %s
                    }$_$;

            json_clause_template = $_$
                    {
                        "clause": "%s",
                        "enforce_constraint": %s
                    }$_$;

            json_facets = null;

            FOR r_facet in
                SELECT f.*, af.facet_code as aggregate_facet_code
                FROM facet.facet f
                LEFT JOIN facet.facet af
                  ON af.facet_id = f.aggregate_facet_id
                ORDER BY f.facet_id
            LOOP

                SELECT string_agg(
                    format(json_table_template,
                        ft.sequence_id,
                        t.table_or_udf_name,
                        coalesce('"' || ft.udf_call_arguments || '"', 'null'),
                        coalesce('"' || ft.alias || '"', 'null')), ','
                        ORDER BY sequence_id
                )
                    INTO json_table
                FROM facet.facet_table ft
                JOIN facet.table t using (table_id)
                WHERE facet_id = r_facet.facet_id
                GROUP BY facet_id;

                SELECT string_agg(
                            format(json_clause_template,
                                clause,
                                case when enforce_constraint = TRUE then 'true' else 'false' end
                            ), ',')
                    INTO json_clause
                FROM facet.facet_clause
                WHERE facet_id = r_facet.facet_id
                GROUP BY facet_id;

                json_facet = format(json_template,
                    r_facet.facet_id,
                    r_facet.facet_code,
                    r_facet.display_title,
                    r_facet.description,
                    r_facet.facet_group_id,
                    r_facet.facet_type_id,
                    r_facet.category_id_expr,
                    r_facet.category_name_expr,
                    r_facet.sort_expr,
                    case when r_facet.is_applicable = TRUE then 'true' else 'false' end,
                    case when r_facet.is_default = TRUE then 'true' else 'false' end,
                    r_facet.aggregate_type,
                    r_facet.aggregate_title,
                    coalesce('"' || r_facet.aggregate_facet_code || '"', 'null'),
                    json_table,
                    json_clause
                );

                json_facets = coalesce(json_facets || ', ', '') || json_facet;
            END LOOP;
            json_facets = '[' || json_facets || ']';
            raise notice '%', json_facets;
            return json_facets;
        end $body$ language plpgsql;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
