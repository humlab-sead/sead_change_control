import os, sys
import shutil
import regex

sqitch_folders  = [ 'deploy', 'verify', 'revert' ]

def rename_change(project, cr_name, new_cr_name, dry_run=True, plan_name='sqitch.plan'):

    for folder in sqitch_folders:

        path_from = os.path.join('.', project, folder, cr_name + '.sql')
        path_to = os.path.join('.', project, folder, new_cr_name + '.sql')

        assert os.path.isfile(path_from), 'File {} not found'.format(path_from)
        assert not os.path.isfile(path_to), 'File {} exists'.format(path_to)

        if not dry_run:
            shutil.move(path_from, path_to)

    plan = os.path.join('.', project, plan_name)

    with open(plan, 'r') as f:
        content = f.read()

    if not dry_run:
        content = content.replace(cr_name, new_cr_name)
        with open(plan, 'w') as f:
            f.write(content)

def delete_change(project, cr_name, dry_run=True, plan_name='sqitch.plan'):

    for folder in sqitch_folders:

        path = os.path.join('.', project, folder, cr_name + '.sql')

        assert os.path.isfile(path), 'File {} not found'.format(path)

        if not dry_run:
            os.remove(path)

    plan_path = os.path.join('.', project, plan_name)

    with open(plan_path, 'r') as f:
        lines = f.readlines()

    if not dry_run:
        lines = [ line for line in lines if not line.startswith(cr_name + ' ')]
        with open(plan_path, 'w') as f:
            f.write(''.join(lines))

delete_change('general', '20190513_DML_ECOCODE_DELETE_SYSTEMS', dry_run=False)
#rename_change('general', '20190313_DML_ECOCODE_DELETE_SYSTEMS', '20190513_DML_ECOCODE_DELETE_SYSTEMS', dry_run=False)

#rename_change('general', '20170814_DML_ECOCODE_ADD_SYSTEM_2', '20170814_DML_ECOCODE_ADD_BUGS_SYSTEMS', dry_run=False)
#delete_change('general', '20170814_DML_ECOCODE_ADD_SYSTEM_3', dry_run=False)

#rename_change('general', '20190408_DDL_ECOCODE_ALTER_TYPE_ECOCODE_GROUPS', '20190408_DDL_ECOCODE_REFACTOR_MODEL', dry_run=False)
#delete_change('general', '20190411_DDL_ECOCODE_RENAME_COLUMNS', dry_run=False)

#rename_change('general', '20180607_DDL_SAMPLE_GROUP_ALTER_SAMPLING_CONTEXT', '20180607_DDL_SAMPLE_ALTER_TYPES', dry_run=False)
#delete_change('general', '20190408_DDL_SAMPLE_ALTER_TYPE_DATE_SAMPLED', dry_run=False)

#rename_change('general', '20190408_DDL_DENDRO_ALTER_DENDRO_DATES_ALLOW_NULL', '20180612_DDL_DENDRO_ALTER_DENDRO_DATES_ALLOW_NULL', False)
#rename_change('general', '20190408_DDL_RELATIVE_DATES_ALTER_RELATION', '20170906_DDL_RELATIVE_DATES_ALTER_RELATION', False)
#rename_change('general', '20190408_DDL_CHRONOLOGIES_REFACTOR_MODEL', '20170911_DDL_CHRONOLOGIES_REFACTOR_MODEL', False)

#rename_change('general', '20120921_DML_DATA_TYPE_UPDATE_DESCRIPTION', '20120921_DML_DATATYPE_UPDATE_DESCRIPTION', False)
#rename_change('general', '20170517_DML_DATA_TYPE_ADD_TYPES', '20170517_DML_DATATYPE_ADD_TYPES', False)

# rename_change('general', '20180601_DDL_DEPRECATE_DROP_RADIOCARBON_CALIBRATION', '20180601_DDL_DROP_RADIOCARBON_CALIBRATION', False)
# rename_change('general', '20190408_DDL_SAMPLE_ALTER_SAMPLE_COORDINATES', '_DEPRECATED_1', False)
# rename_change('general', '20190408_DDL_TAXA_ALTER_SPECIES_ASSOCIATION_TYPES', '_DEPRECATED_2', False)
# rename_change('general', '20190408_DML_PROJECT_ALTER_PROJECT_STAGES', '_DEPRECATED_3', False)
# rename_change('general', '20190411_DDL_SAMPLE_ASSIGN_SEQUENCE', '20190411_DDL_ASSIGN_SEQUENCES', False)

# import glob

# deploy_pattern = os.path.join('.', 'bugs', 'deploy', 'CS_*.sql')
# cr_names = [ os.path.splitext(x)[0] for x in [ os.path.split(x)[1] for x in glob.glob(deploy_pattern) ] ]

# for x in cr_names:
#     eight_digits = regex.match(r'.*(\d{8}_).*',x).groups()[0]
#     new_name = eight_digits + 'DDL_' + x[3:].replace(eight_digits, '')
#     print("rename_change('bugs', '{}', '{}', False)".format(x, new_name))

# rename_change('bugs', 'CS_BUGS_20190503_ADD_TRANSLATIONS', '20190503_DDL_BUGS_ADD_TRANSLATIONS', False)
# rename_change('bugs', 'CS_BUGS_20190503_SETUP_SCHEMA', '20190503_DDL_BUGS_SETUP_SCHEMA', False)

# rename_change('sead_api', 'CS_DATAARC_20170810_DATASRC_API', '20170810_DDL_DATAARC_DATASRC_API', False)
# rename_change('sead_api', 'CS_RESTAPI_20180501_CREATE_SAMPLE_AGE_RANGES', '20180501_DDL_RESTAPI_CREATE_SAMPLE_AGE_RANGES', False)
# rename_change('sead_api', 'CS_RESTAPI_20180501_GENERATE_SCHEMA', '20180501_DDL_RESTAPI_GENERATE_SCHEMA', False)

# rename_change('utility', 'CS_AUDIT_20180613_DEPLOY_AUDIT_SYSTEM', '20180613_DDL_AUDIT_DEPLOY_AUDIT_SYSTEM', False)
# rename_change('utility', 'CS_STAGING_20190517_CREATE_DATABASE', '20190517_DDL_STAGING_CREATE_DATABASE', False)
# rename_change('utility', 'CS_UTILITY_20190407_ADD_UUID_SUPPORT', '20190407_DDL_UTILITY_ADD_UUID_SUPPORT', False)
# rename_change('utility', 'CS_UTILITY_20190407_CONVERT_SEQUENCES_TO_SERIAL', '20190407_DDL_UTILITY_CONVERT_SEQUENCES_TO_SERIAL', False)
# rename_change('utility', 'CS_UTILITY_20190407_CREATE_TABLE_DEPENDENCY_VIEW', '20190407_DDL_UTILITY_CREATE_TABLE_DEPENDENCY_VIEW', False)
# rename_change('utility', 'CS_UTILITY_20190407_CREATE_UTILITY_SCHEMA', '20190407_DDL_UTILITY_CREATE_UTILITY_SCHEMA', False)
# rename_change('utility', 'CS_UTILITY_20190407_SYNC_ALL_SEQUENCES', '20190407_DDL_UTILITY_SYNC_ALL_SEQUENCES', False)
# rename_change('utility', 'CS_UTILITY_20190411_ENABLE_PGCRYPTO', '20190411_DDL_UTILITY_ENABLE_PGCRYPTO', False)
# rename_change('utility', 'CS_UTILITY_20190411_ENABLE_TABLEFUNC', '20190411_DDL_UTILITY_ENABLE_TABLEFUNC', False)

# rename_change('general', 'DML_20170911_ANALYSIS_ENTITY_ADD_AGES',    '20170911_DML_ANALYSIS_ENTITY_ADD_AGES', False)
# rename_change('general', 'CS_ANALYSIS_ENTITY_20170911_ALTER_AGES_PRECISION',    '20170911_DDL_ANALYSIS_ENTITY_ALTER_AGES_PRECISION', False)
# rename_change('general', 'CS_BIBLIO_20170101_REFACTOR_MODEL',                   '20170101_DDL_BIBLIO_REFACTOR_MODEL', False)
# rename_change('general', 'CS_BIBLIO_20180222_ADD_RECORD',                       '20180222_DML_BIBLIO_ADD_RECORD', False)
# rename_change('general', 'CS_CERAMICS_20190408_CREATE_CERAMICS_LOOKUP',         '20190408_DDL_CERAMICS_CREATE_CERAMICS_LOOKUP', False)
# rename_change('general', 'CS_CHRONOLOGIES_20190408_REFACTOR_MODEL',             '20190408_DDL_CHRONOLOGIES_REFACTOR_MODEL', False)
# rename_change('general', 'CS_COMMENTS_20190410_UPDATE_COMMENTS',                '20190410_DDL_COMMENTS_UPDATE_COMMENTS', False)
# rename_change('general', 'CS_DATASET_20190408_CREATE_TABLE_DATASET_METHODS',    '20190408_DDL_DATASET_CREATE_TABLE_DATASET_METHODS', False)
# rename_change('general', 'CS_DATA_TYPE_20120921_UPDATE_DESCRIPTION',            '20120921_DML_DATA_TYPE_UPDATE_DESCRIPTION', False)
# rename_change('general', 'CS_DATA_TYPE_20170517_ADD_TYPES',                     '20170517_DML_DATA_TYPE_ADD_TYPES', False)
# rename_change('general', 'CS_DATA_TYPE_20190513_ADD_TYPES_CALENDER_DATES',      '20190513_DML_DATA_TYPE_ADD_TYPES_CALENDER_DATES', False)
# rename_change('general', 'CS_DATINGLAB_20190503_ADD_UNKNOWN_LAB',               '20190503_DML_DATINGLAB_ADD_UNKNOWN_LAB', False)
# rename_change('general', 'CS_DENDRO_20180520_CREATE_DENDRO_LOOKUP',             '20180520_DDL_DENDRO_CREATE_DENDRO_LOOKUP', False)
# rename_change('general', 'CS_DENDRO_20180521_ADD_LOOKUP_DATA',                  '20180521_DML_DENDRO_ADD_LOOKUP_DATA', False)
# rename_change('general', 'CS_DENDRO_20180521_REFACTOR_MODEL',                   '20180521_DDL_DENDRO_REFACTOR_MODEL', False)
# rename_change('general', 'CS_DENDRO_20190408_ALTER_DENDRO_DATES_ALLOW_NULL',    '20190408_DDL_DENDRO_ALTER_DENDRO_DATES_ALLOW_NULL', False)
# rename_change('general', 'CS_DEPRECATE_20180601_DROP_RADIOCARBON_CALIBRATION',  '20180601_DDL_DEPRECATE_DROP_RADIOCARBON_CALIBRATION', False)
# rename_change('general', 'CS_ECOCODE_20170814_ADD_SYSTEM_2',                    '20170814_DML_ECOCODE_ADD_SYSTEM_2', False)
# rename_change('general', 'CS_ECOCODE_20170814_ADD_SYSTEM_3',                    '20170814_DML_ECOCODE_ADD_SYSTEM_3', False)
# rename_change('general', 'CS_ECOCODE_20180222_ADD_SYSTEM_4',                    '20180222_DML_ECOCODE_ADD_SYSTEM_4', False)
# rename_change('general', 'CS_ECOCODE_20180222_DELETE_SYSTEMS',                  '20180222_DML_ECOCODE_DELETE_SYSTEMS', False)
# rename_change('general', 'CS_ECOCODE_20190408_ALTER_TYPE_ECOCODE_GROUPS',       '20190408_DDL_ECOCODE_ALTER_TYPE_ECOCODE_GROUPS', False)
# rename_change('general', 'CS_ECOCODE_20190411_RENAME_COLUMNS',                  '20190411_DDL_ECOCODE_RENAME_COLUMNS', False)
# rename_change('general', 'CS_ECOCODE_20190513_ADD_GROUP_UPDATE_SYSTEM',         '20190513_DML_ECOCODE_ADD_GROUP_UPDATE_SYSTEM', False)
# rename_change('general', 'CS_HORIZON_20121220_UPDATE_DESCRIPTION',              '20121220_DML_HORIZON_UPDATE_DESCRIPTION', False)
# rename_change('general', 'CS_LOCATION_20190408_UPDATE_LOCATION_RECORD',         '20190408_DML_LOCATION_UPDATE_LOCATION_RECORD', False)
# rename_change('general', 'CS_META_20190411_VIEW_UPDATES',                       '20190411_DDL_META_VIEW_UPDATES', False)
# rename_change('general', 'CS_METHOD_20140417_ADD_METHOD_GEOLPER',               '20140417_DML_METHOD_ADD_METHOD_GEOLPER', False)
# rename_change('general', 'CS_METHOD_20180502_UPDATE_METHOD_TL',                 '20180502_DML_METHOD_UPDATE_METHOD_TL', False)
# rename_change('general', 'CS_METHOD_20190503_ADD_BUGS_METHODS',                 '20190503_DML_METHOD_ADD_BUGS_METHODS', False)
# rename_change('general', 'CS_PROJECT_20190408_ALTER_PROJECT_STAGES',            '20190408_DML_PROJECT_ALTER_PROJECT_STAGES', False)
# rename_change('general', 'CS_RECORD_TYPE_20120921_UPDATE_PLANTS_POLLEN',        '20120921_DML_RECORD_TYPE_UPDATE_PLANTS_POLLEN', False)
# rename_change('general', 'CS_RELATIVE_AGE_20140417_ADD_DATA',                   '20140417_DML_RELATIVE_AGE_ADD_DATA', False)
# rename_change('general', 'CS_RELATIVE_DATES_20190408_ALTER_RELATION',           '20190408_DDL_RELATIVE_DATES_ALTER_RELATION', False)
# rename_change('general', 'CS_RELATIVE_DATING_20190410_RENAME_COLUMN',           '20190410_DDL_RELATIVE_DATING_RENAME_COLUMN', False)
# rename_change('general', 'CS_SAMPLE_20190408_ALTER_SAMPLE_COORDINATES',         '20190408_DDL_SAMPLE_ALTER_SAMPLE_COORDINATES', False)
# rename_change('general', 'CS_SAMPLE_20190408_ALTER_TYPE_DATE_SAMPLED',          '20190408_DDL_SAMPLE_ALTER_TYPE_DATE_SAMPLED', False)
# rename_change('general', 'CS_SAMPLE_20190410_CREATE_INDEX',                     '20190410_DDL_SAMPLE_CREATE_INDEX', False)
# rename_change('general', 'CS_SAMPLE_20190411_ASSIGN_SEQUENCE',                  '20190411_DDL_SAMPLE_ASSIGN_SEQUENCE', False)
# rename_change('general', 'CS_SAMPLE_GROUP_20180607_ALTER_SAMPLING_CONTEXT',     '20180607_DDL_SAMPLE_GROUP_ALTER_SAMPLING_CONTEXT', False)
# rename_change('general', 'CS_SCHEMA_20190425_ADD_MISSING_FOREIGN_KEYS',         '20190425_DDL_SCHEMA_ADD_MISSING_FOREIGN_KEYS', False)
# rename_change('general', 'CS_SITE_20131113_UPDATE_LAT_LONG',                    '20131113_DML_SITE_UPDATE_LAT_LONG', False)
# rename_change('general', 'CS_SITE_20180601_ADD_LOCATION_ACCURACY',              '20180601_DDL_SITE_ADD_LOCATION_ACCURACY', False)
# rename_change('general', 'CS_SITE_20180601_ALTER_TYPE',                         '20180601_DDL_SITE_ALTER_TYPE', False)
# rename_change('general', 'CS_SPECIES_20190415_DELETE_DUPLICATES',               '20190415_DML_SPECIES_DELETE_DUPLICATES', False)
# rename_change('general', 'CS_TAXA_20150522_ADD_GENERA_SPHAGNUM',                '20150522_DML_TAXA_ADD_GENERA_SPHAGNUM', False)
# rename_change('general', 'CS_TAXA_20180601_DROP_VIEWS',                         '20180601_DDL_TAXA_DROP_VIEWS', False)
# rename_change('general', 'CS_TAXA_20190408_ALTER_SPECIES_ASSOCIATION_TYPES',    '20190408_DDL_TAXA_ALTER_SPECIES_ASSOCIATION_TYPES', False)
# rename_change('general', 'CS_TAXA_20190410_CREATE_VIEW_ALPHABETICALLY',         '20190410_DDL_TAXA_CREATE_VIEW_ALPHABETICALLY', False)
# rename_change('general', 'CS_TAXA_20190503_ADD_SPECIES_ASSOC_TYPES',            '20190503_DML_TAXA_ADD_SPECIES_ASSOC_TYPES', False)
# rename_change('general', 'CS_TAXA_20190503_ATTRIBUTE_TYPE_LENGTH',              '20190503_DDL_TAXA_ATTRIBUTE_TYPE_LENGTH', False)
