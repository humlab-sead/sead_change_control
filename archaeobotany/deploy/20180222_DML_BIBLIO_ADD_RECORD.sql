-- Deploy archaeobotany: 20180222_DML_BIBLIO_ADD_RECORD

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-15
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

        if sead_utility.column_exists('public'::text, 'tbl_biblio'::text, 'authors'::text) = FALSE then
            raise exception 'patch dependency error';
        end if;

        if (select count(*) from public.tbl_biblio where biblio_id = 5576) = 1 then
            raise exception SQLSTATE 'GUARD';
        end if;

        -- FIXME: #165 Updates by serial identity should be prohibited
        insert into public.tbl_biblio(biblio_id, authors, bugs_reference, date_updated, doi, isbn, notes, title, year, full_reference, url)
            values (5576, 'Arnolds & E. van der Maarel (1979)', NULL, '2018-02-22 10:55:13.214984+01', NULL, NULL, '', 'De oecologische groepen in de Standaardlijst van de Nederlandse flora 1975. Gorteria 9.', '1970', '', NULL);

        perform sead_utility.sync_sequence('public', 'tbl_biblio');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
