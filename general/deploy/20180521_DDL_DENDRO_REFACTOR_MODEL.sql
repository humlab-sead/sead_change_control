-- Deploy sead_db_change_control:CSR_20180521_ADD_DENDROCHRONOLOGY_DATING to pg


BEGIN;

DO $$
BEGIN
	BEGIN
    
        if sead_utility.table_exists('public'::text, 'tbl_age_types'::text) = TRUE THEN
            RAISE EXCEPTION SQLSTATE 'GUARD';
        end if;
        
        DROP VIEW IF EXISTS postgrest_default_api.dendro_date;
        DROP VIEW IF EXISTS clearing_house.view_dendro_dates;

        CREATE TABLE IF NOT EXISTS public.tbl_age_types (
            age_type_id serial PRIMARY KEY,
            age_type character varying(150) NOT NULL,
            description text,
            date_updated timestamp with time zone DEFAULT now()
        );

        CREATE TABLE IF NOT EXISTS public.tbl_error_uncertainties (
            error_uncertainty_id serial PRIMARY KEY,
            error_uncertainty_type character varying(150) NOT NULL,
            description text,
            date_updated timestamp with time zone DEFAULT now()
        );

        CREATE TABLE IF NOT EXISTS public.tbl_season_or_qualifier (
            season_or_qualifier_id serial PRIMARY KEY,
            season_or_qualifier_type character varying(150) NOT NULL,
            description text,
            date_updated timestamp with time zone DEFAULT now()
        );
        
        if (select count(*) from public.tbl_dendro_dates) > 0 then
            RAISE EXCEPTION 'Cannot delete tbl_dendro_dates since it''s not empty';
        end if;
        
        DROP TABLE IF EXISTS public.tbl_dendro_dates;
        
        CREATE TABLE IF NOT EXISTS public.tbl_dendro_dates
        (
            dendro_date_id serial PRIMARY KEY,
            analysis_entity_id integer NOT NULL,
            age_older integer,
            age_younger integer,
            dating_uncertainty_id integer,
            season_or_qualifier_id integer,
            date_updated timestamp with time zone DEFAULT now(),
            error_plus integer,
            error_minus integer,
            dendro_lookup_id integer NOT NULL,
            error_uncertainty_id integer,
            age_type_id integer NOT NULL,
            CONSTRAINT fk_dendro_dates_analysis_entity_id FOREIGN KEY (analysis_entity_id)
                REFERENCES public.tbl_analysis_entities (analysis_entity_id) MATCH SIMPLE
                ON UPDATE NO ACTION
                ON DELETE NO ACTION,
            CONSTRAINT fk_dendro_dates_dating_uncertainty_id FOREIGN KEY (dating_uncertainty_id)
                REFERENCES public.tbl_dating_uncertainty (dating_uncertainty_id) MATCH SIMPLE
                ON UPDATE NO ACTION
                ON DELETE NO ACTION,
            CONSTRAINT fk_dendro_lookup_dendro_lookup_id FOREIGN KEY (dendro_lookup_id)
                REFERENCES public.tbl_dendro_lookup (dendro_lookup_id) MATCH SIMPLE
                ON UPDATE NO ACTION
                ON DELETE NO ACTION,
            CONSTRAINT fk_tbl_age_types_age_type_id FOREIGN KEY (age_type_id)
                REFERENCES public.tbl_age_types (age_type_id) MATCH SIMPLE
                ON UPDATE NO ACTION
                ON DELETE NO ACTION,
            CONSTRAINT fk_tbl_error_uncertainties_error_uncertainty_id FOREIGN KEY (error_uncertainty_id)
                REFERENCES public.tbl_error_uncertainties (error_uncertainty_id) MATCH SIMPLE
                ON UPDATE NO ACTION
                ON DELETE NO ACTION
        );

        COMMENT ON TABLE public.tbl_dendro_dates
            IS '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
        20130722PIB: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';

        ALTER TABLE public.tbl_dendro_dates OWNER to sead_master;
        ALTER TABLE public.tbl_age_types OWNER to sead_master;
        ALTER TABLE public.tbl_error_uncertainties OWNER to sead_master;
        ALTER TABLE public.tbl_season_or_qualifier OWNER to sead_master;

        GRANT ALL ON TABLE public.tbl_dendro_dates TO sead_read, mattias, postgres;
        GRANT SELECT ON TABLE public.tbl_dendro_dates TO humlab_read, johan;

        GRANT ALL ON TABLE public.tbl_age_types, public.tbl_error_uncertainties, public.tbl_season_or_qualifier
            TO sead_read, humlab_admin, mattias, postgres;

        GRANT SELECT ON TABLE public.tbl_age_types, public.tbl_error_uncertainties, public.tbl_season_or_qualifier TO humlab_read;

        RAISE NOTICE 'Please re-create: postgrest_default_api.dendro_date';
        RAISE NOTICE 'Please re-create: clearing_house.view_dendro_dates;';
        
    EXCEPTION WHEN SQLSTATE 'GUARD' THEN
        RAISE NOTICE 'ALREADY EXECUTED';
    END;
    
END $$;

ROLLBACK;

