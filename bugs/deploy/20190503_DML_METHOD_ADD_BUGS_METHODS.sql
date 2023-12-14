-- Deploy bugs: 20190503_DML_METHOD_ADD_BUGS_METHODS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-03
  Description   New Bugs methods needed for bugs import
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

        perform sead_utility.sync_sequence('public', 'tbl_methods', 'method_id');

        with new_methods (method_id, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id, description) as (values
                (159, 'Cal',20,'Calibrated radiocarbon date (method unspecified)',null,8,'Calendar years date provided by the calibration of a radiocarbon age. Exact dating method unspecified.'),
                (163, 'CalAMS',20,'Calibrated AMS radiocarbon date',null,8,'Calendar years date provided by calibration of an AMS radiocarbon age.'),
                (156, 'GeolPer',19,'Geological period (unspecified years)',null,15,'Age determined to geological period using undefined (or possibly multiple) method(s).'),
                (167, 'Interp 14C',3,'Interpolated C14',19,7,'Dating using the interpolation of 14C dates from other samples (give details in dating notes)'),
                (169, 'ESR',21,'Electron Spin Resonance',19,15,'Dating based on the trapped charges of electrons, electron spin resonance dating.'),
                (170, 'He-U',3,'Helium-Uranium',19,15,'Dating based on the production of helium during the radioactive decay of uranium and thorium.'),
                (160, 'Cl36',3,'Chlorine 36',19,15,'Dating based on the radioactive decay of chlorine 36'),
                (168, 'U-Trend',3,'Uranium trend',19,15,'Dating utilizing disequilibrium in the decay of Uranium-238, Uranium-234 and Thorium 230.'),
                (157, 'Be10',3,'Berylium 10',19,15,'Dating based on the radioactive decay of berylium 10.'),
                (165, 'K-Ar',3,'Potassium-Argon',19,15,'Dating based on the radioactive decay of potassium into argon.'),
                (162, 'Orb-Tuning',21,'Orbital Tuning',19,15,'Dating through the synchronization of events according to Milankovitch cycles, casused by changes in the Earth''s orbit, and their expected effects on climate.'),
                (158, 'Pa231/U235',3,'U-Series Pa231/U235',19,15,'Dating based on the radioactive decay of uranium-series isotopes protactinium-231 and uranium-235.'),
                (166, 'Pb210',3,'Lead 210',19,15,'Dating based on the measurement of radioactive isotope lead-210, which is a product of uranium decay.'),
                (161, 'Th230/U234',3,'U-Series Th230/U234',19,15,'Dating based on the radioactive decay of uranium-234 to thorium-230, and the degree to which secular equilibrium has been restored between these'),
                (164, 'Fis-Track',3,'Fission-Track',19,15,'Dating based on the trails left in some glassy minerals as a result of the radioactive decay of uranium.')
        )
        insert into tbl_methods (method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id, description, date_updated)
            select n.method_abbrev_or_alt_name, n.method_group_id, n.method_name, n.record_type_id, n.unit_id, n.description, '2019-12-20 13:45:51.516907+00'
            from new_methods n
            /*left join tbl_methods x using (method_abbrev_or_alt_name)
            where x.method_name is null*/;

        -- insert into "public"."tbl_methods"("method_id", "biblio_id", "date_updated", "description", "method_abbrev_or_alt_name", "method_group_id", "method_name", "record_type_id", "unit_id")
        --     values (156, NULL, '2018-05-02 14:13:47.999285+02', 'Age determined to geological period using undefined (or possibly multiple) method(s).', 'GeolPer', 19, 'Geological period (unspecified)', 0, NULL)
        --         on conflict (method_id) do nothing;


        perform sead_utility.sync_sequence('public', 'tbl_methods', 'method_id');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
end $$;
commit;
