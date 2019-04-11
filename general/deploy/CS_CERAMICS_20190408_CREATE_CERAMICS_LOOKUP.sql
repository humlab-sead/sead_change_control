-- Deploy sead_db_change_control:CSR_20190408_CREATE_TABLE_CERAMICS_LOOKUP to pg

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
    
        if sead_utility.table_exists('public'::text, 'tbl_ceramics_lookup'::text) = FALSE THEN

            CREATE TABLE IF NOT EXISTS tbl_ceramics_lookup
            (
                ceramics_lookup_id SERIAL PRIMARY KEY,
                method_id integer NOT NULL,
                description text COLLATE pg_catalog."default",
                name character varying COLLATE pg_catalog."default" NOT NULL,
                date_updated timestamp(6) with time zone DEFAULT now(),
                CONSTRAINT fk_ceramics_lookup_method_id FOREIGN KEY (method_id)
                    REFERENCES tbl_methods (method_id) MATCH SIMPLE
                    ON UPDATE NO ACTION
                    ON DELETE NO ACTION
            );

            ALTER TABLE tbl_ceramics_lookup OWNER to sead_master;

            GRANT ALL    ON TABLE tbl_ceramics_lookup TO sead_master;
            GRANT SELECT ON TABLE tbl_ceramics_lookup TO humlab_read, clearinghouse_worker, mattias;

            COMMENT ON TABLE tbl_ceramics_lookup IS 'Type=lookup';

        end if;

        if sead_utility.column_exists('public'::text, 'tbl_ceramics'::text, 'ceramics_lookup_id'::text) = FALSE THEN

            ALTER TABLE tbl_ceramics
                DROP CONSTRAINT IF EXISTS "fk_ceramics_ceramics_measurement_id",
                ADD COLUMN "ceramics_lookup_id" int4 NOT NULL,
                DROP COLUMN IF EXISTS  "ceramics_measurement_id",
                ADD CONSTRAINT "fk_ceramics_ceramics_lookup_id" FOREIGN KEY ("ceramics_lookup_id")
                    REFERENCES tbl_ceramics_lookup (ceramics_lookup_id)
                    ON DELETE NO ACTION ON UPDATE NO ACTION;

            DROP TABLE IF EXISTS "public"."tbl_ceramics_measurement_lookup";
            
        end if;
        
    exception when SQLSTATE 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;

ROLLBACK;
--COMMIT;
