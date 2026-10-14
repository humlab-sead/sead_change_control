-- Revert facet:20261006_DML_DOMAIN_FACET_CHILDREN_CLEANUP from pg

BEGIN;

delete from facet.facet_children fc
using (values
    ('dendrochronology', 'constructions'),
    ('geoarchaeology',   'dataset_methods'),
    ('ceramic',          'dataset_methods')
) as x(facet_code, child_facet_code)
where fc.facet_code = x.facet_code
  and fc.child_facet_code = x.child_facet_code;

-- Removed filters are appended at the end of each domain; their original positions are not restored.
insert into facet.facet_children (facet_code, child_facet_code, position)
    select x.facet_code,
           x.child_facet_code,
           coalesce((select max(c.position) from facet.facet_children c where c.facet_code = x.facet_code), 0) + x.ordinal
    from (values
        ('palaeoentomology', 'feature_type', 1),
        ('palaeoentomology', 'geochronology', 2),
        ('palaeoentomology', 'relative_age_name', 3),
        ('archaeobotany',    'geochronology', 1),
        ('archaeobotany',    'relative_age_name', 2),
        ('archaeobotany',    'activeseason', 3),
        ('archaeobotany',    'tbl_biblio_modern', 4),
        ('geoarchaeology',   'geochronology', 1),
        ('geoarchaeology',   'relative_age_name', 2),
        ('geoarchaeology',   'tbl_biblio_modern', 3),
        ('dendrochronology', 'feature_type', 1),
        ('dendrochronology', 'geochronology', 2),
        ('dendrochronology', 'family', 3),
        ('dendrochronology', 'species_author', 4),
        ('dendrochronology', 'tbl_biblio_modern', 5),
        ('ceramic',          'geochronology', 1),
        ('ceramic',          'tbl_biblio_modern', 2),
        ('ceramic',          'sample_group_sampling_contexts', 3),
        ('adna',             'activeseason', 1),
        ('adna',             'feature_type', 2),
        ('adna',             'tbl_biblio_modern', 3),
        ('adna',             'constructions', 4),
        ('adna',             'record_types', 5),
        ('adna',             'dataset_provider', 6)
    ) as x(facet_code, child_facet_code, ordinal)
    on conflict (facet_code, child_facet_code) do nothing;

COMMIT;
