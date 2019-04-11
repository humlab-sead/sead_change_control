begin;

do $$
begin
	begin   

        IF sead_utility.column_exists('public'::text, 'tbl_relative_dates'::text, 'analysis_entity_id'::text) = FALSE THEN
            RAISE EXCEPTION SQLSTATE 'GUARD';
        END IF;

        IF (SELECT COUNT(*) FROM tbl_relative_dates) > 0 THEN
            RAISE EXCEPTION 'Table contains data. Cannot deploy requested action';
            -- TODO Update is not deterministic
        END IF;
        
        ALTER TABLE tbl_relative_dates
            ADD COLUMN analysis_entity_id int4 NOT NULL,
            ADD CONSTRAINT "fk_tbl_relative_dates_to_tbl_analysis_entities" FOREIGN KEY (analysis_entity_id) REFERENCES tbl_analysis_entities (analysis_entity_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

        ALTER TABLE tbl_relative_dates
            DROP CONSTRAINT IF EXISTS "fk_relative_dates_physical_sample_id",
            DROP COLUMN IF EXISTS "physical_sample_id";
            
        COMMENT ON TABLE "public"."tbl_relative_dates" IS '20120504PIB: Added method_id to store dating method used to attribute sample to period or calendar date (e.g. strategraphic dating, typological)
20130722PIB: added field dating_uncertainty_id to cater for "from", "to" and "ca." etc. especially from import of BugsCEP
20170906PIB: removed fk physical_samples_id and replaced with analysis_entity_id';

    exception when SQLSTATE 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
rollback;
--COMMIT;