-- Deploy facet: 20261006_DML_DOMAIN_FACET_CHILDREN_CLEANUP

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-10-06
  Description   Align domain filters with the data in each domain: remove filters that are always empty (or
                single-valued) within a domain, and add filters that are populated but missing.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/457
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Replaces the per-domain filterBlacklist entries in the browser client's config.*.json, so that
                facet.facet_children is the single source of truth for domain membership.
                The pollen and isotope domains are deliberately left unchanged.
                Dating filters are removed from the biological domains until
                https://github.com/humlab-sead/sead_change_control/issues/453 is fixed, and family from
                dendrochronology until https://github.com/humlab-sead/sead_change_control/issues/454 is fixed.
*****************************************************************************************************************/

begin;

set client_encoding = 'UTF8';

delete from facet.facet_children fc
using (values
    ('palaeoentomology', 'feature_type'),
    ('palaeoentomology', 'geochronology'),
    ('palaeoentomology', 'relative_age_name'),

    ('archaeobotany',    'geochronology'),
    ('archaeobotany',    'relative_age_name'),
    ('archaeobotany',    'activeseason'),
    ('archaeobotany',    'tbl_biblio_modern'),

    ('geoarchaeology',   'geochronology'),
    ('geoarchaeology',   'relative_age_name'),
    ('geoarchaeology',   'tbl_biblio_modern'),

    ('dendrochronology', 'feature_type'),
    ('dendrochronology', 'geochronology'),
    ('dendrochronology', 'family'),
    ('dendrochronology', 'species_author'),
    ('dendrochronology', 'tbl_biblio_modern'),

    ('ceramic',          'geochronology'),
    ('ceramic',          'tbl_biblio_modern'),
    ('ceramic',          'sample_group_sampling_contexts'),

    ('adna',             'activeseason'),
    ('adna',             'feature_type'),
    ('adna',             'tbl_biblio_modern'),
    ('adna',             'constructions'),
    ('adna',             'record_types'),
    ('adna',             'dataset_provider')
) as x(facet_code, child_facet_code)
where fc.facet_code = x.facet_code
  and fc.child_facet_code = x.child_facet_code;

insert into facet.facet_children (facet_code, child_facet_code, position)
    select x.facet_code,
           x.child_facet_code,
           coalesce((select max(c.position) + 1 from facet.facet_children c where c.facet_code = x.facet_code), 0)
    from (values
        ('dendrochronology', 'constructions'),
        ('geoarchaeology',   'dataset_methods'),
        ('ceramic',          'dataset_methods')
    ) as x(facet_code, child_facet_code)
    on conflict (facet_code, child_facet_code) do nothing;

commit;
