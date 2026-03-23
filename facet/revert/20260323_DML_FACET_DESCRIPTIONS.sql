-- Revert facet:20260323_DML_FACET_DESCRIPTIONS

BEGIN;

set search_path = facet, pg_catalog;

update facet.facet set description = 'Magnetic sus.'                          where facet_id = 3;
update facet.facet set description = 'MS Heating 550'                         where facet_id = 4;
update facet.facet set description = 'Loss of Ignition'                       where facet_id = 5;
update facet.facet set description = 'Phosphates'                             where facet_id = 6;
update facet.facet set description = 'Proxy types'                            where facet_id = 12;
update facet.facet set description = 'Feature type'                           where facet_id = 29;
update facet.facet set description = 'abundance classification'               where facet_id = 31;
update facet.facet set description = 'Abundances'                             where facet_id = 33;
update facet.facet set description = 'Insect activity seasons'                where facet_id = 34;
update facet.facet set description = 'Bibliography modern'                    where facet_id = 35;
update facet.facet set description = 'Bibliography sites/Samplegroups'        where facet_id = 36;
update facet.facet set description = 'Bibliography sites'                     where facet_id = 37;
update facet.facet set description = 'Dataset provider'                       where facet_id = 38;
update facet.facet set description = 'Dataset methods'                        where facet_id = 39;
update facet.facet set description = 'Region'                                 where facet_id = 41;
update facet.facet set description = 'Data types'                             where facet_id = 42;
update facet.facet set description = 'RDB system'                             where facet_id = 43;
update facet.facet set description = 'RDB Code'                               where facet_id = 44;
update facet.facet set description = 'Modification Types'                     where facet_id = 45;
update facet.facet set description = 'Abundance Elements'                     where facet_id = 46;
update facet.facet set description = 'Sampling Contexts'                      where facet_id = 47;
update facet.facet set description = 'Constructions'                          where facet_id = 48;
update facet.facet set description = 'Type of location'                       where facet_id = 50;
update facet.facet set description = 'Analysis entity ages (intersects)'      where facet_id = 52;
update facet.facet set description = 'Generic age range filter for dendrchronology. Return both estimated felling year and outermost tree ring.' where facet_id = 53;
update facet.facet set description = 'Construction purpose'                   where facet_id = 54;

COMMIT;
