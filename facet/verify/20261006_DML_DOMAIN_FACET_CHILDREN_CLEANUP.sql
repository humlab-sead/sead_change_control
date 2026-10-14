-- Verify facet:20261006_DML_DOMAIN_FACET_CHILDREN_CLEANUP on pg

BEGIN;

-- Removed filters are no longer children of their domain.
select 1 / (1 - count(*))
from facet.facet_children fc
join (values
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
  on fc.facet_code = x.facet_code
 and fc.child_facet_code = x.child_facet_code;

-- Added filters are children of their domain.
select 1 / (case when count(*) = 3 then 1 else 0 end)
from facet.facet_children fc
join (values
    ('dendrochronology', 'constructions'),
    ('geoarchaeology',   'dataset_methods'),
    ('ceramic',          'dataset_methods')
) as x(facet_code, child_facet_code)
  on fc.facet_code = x.facet_code
 and fc.child_facet_code = x.child_facet_code;

ROLLBACK;
