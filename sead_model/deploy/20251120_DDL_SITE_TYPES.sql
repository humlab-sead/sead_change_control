-- Deploy sead_model: 20251120_DDL_SITE_TYPES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2025-11-20
  Description   Add tables for storing site types
  Issue         https://github.com/humlab-sead/sead_change_control/issues/403
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
    
        if sead_utility.table_exists('public'::text, 'tbl_site_type_groups'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        create table tbl_site_type_groups (
            "site_type_group_id"        serial primary key,
            "site_type_group_abbrev"    varchar(40) not null unique,     -- e.g. 'aue', 'siedl'
            "site_type_group"           varchar(255) not null,           -- alluvium / flood plain
            "description"               text not null default(''),
            "origin_code"               varchar(40),                     -- 'natur', 'anthro', 'natant', 'unbek'
            "origin_description"        text not null default('')        -- natural / anthropogenic / etc.
        );

        create table tbl_site_types (
            "site_type_id"         serial primary key,
            "site_type_group_id"   integer not null references tbl_site_type_groups(site_type_group_id) on update cascade on delete restrict,
            "site_type_abbrev"     varchar(40) not null unique,  -- e.g. 'siedl', 'meer', 'villa'
            "site_type"            varchar(256) not null unique,  -- name e.g. 'open settlement'
            "description"          text not null default('')
        );

        CREATE TABLE tbl_site_site_types (
            "site_site_type_id"    serial primary key,
            "site_id"              integer not null references tbl_sites(site_id) on update cascade on delete cascade,
            "site_type_id"         integer not null references tbl_site_types(site_type_id) on update cascade on delete restrict,
            "is_primary_type"      boolean not null default false,
            "confidence_code"      smallint,  -- 1=high, 2=medium, 3=low
            "notes"                text,
            constraint uq_site_type_per_site unique ("site_id", "site_type_id")
        );

        with new_data ("site_type_group_id", "site_type_group_abbrev", "site_type_group", "description", "origin_code", "origin_description") as (
            values
                (1,  'None',            /* '-99 */      'not chosen',                                '', '-99',    'not chosen'),
                (2,  'FloodPlain',      /* 'Aue', */    'alluvium / flood plain',                    '', 'Natur',  'natural'),
                (3,  'Mine',            /* 'Be', */     'mine / shaft / galleries',                  '', 'Anthro', 'anthropogenic'),
                (4,  'AnthroOther',     /* 'FuTySo', */ 'other anthropogenic deposit',               '', 'Anthro', 'anthropogenic'),
                (5,  'Workshop',        /* 'Ha', */     'workshop (incl. mill)',                     '', 'Anthro', 'anthropogenic'),
                (6,  'Harbour',         /* 'Haf', */    'harbour / landing',                         '', 'Anthro', 'anthropogenic'),
                (7,  'Cave',            /* 'Hö', */     'cave / rock shelter',                       '', 'Anthro', 'anthropogenic'),
                (8,  'Colluvium',       /* 'Kol', */    'colluvium',                                 '', 'NatAnt', 'natural-anthropogenic'),
                (9,  'Cult',            /* 'Kult', */   'places of cult and religious institutions', '', 'Anthro', 'anthropogenic'),
                (10, 'Sea',             /* 'Meer', */   'sea / ocean',                               '', 'Natur',  'natural'),
                (11, 'Charcoal_kiln',   /* 'Mei', */    'charcoal kiln / charburnery',               '', 'Anthro', 'anthropogenic'),
                (12, 'Swamp',           /* 'Moor', */   'swamp',                                     '', 'Natur',  'natural'),
                (13, 'Natural_other',   /* 'natSo', */  'other natural deposit',                     '', 'Natur',  'natural'),
                (14, 'Lake',            /* 'See', */    'lake / pond / basin',                       '', 'Natur',  'natural'),
                (15, 'Settlement',      /* 'Siedl', */  'settlement',                                '', 'Anthro', 'anthropogenic'),
                (16, 'Unknown',         /* 'unbek', */  'unknown',                                   '', 'unbek',  'unknown')
        )
            insert into tbl_site_type_groups ( "site_type_group_id", "site_type_group_abbrev", "site_type_group", "description", "origin_code", "origin_description" )
            select *
            from new_data;

        with new_data ("site_type_id", "site_type_group_id", "site_type_abbrev", "site_type", "description") AS (
            values
                (1,  1,  'None',                /* '-99' */      'not chosen',                                 'not chosen'),
                (2,  7,  'Abri',                /* 'Ab' */       'abri / rock shelter',                        'abri / rock shelter'),
                (3,  2,  'Oxbow',               /* 'Alt' */      'oxbow',                                      'oxbow'),
                (4,  2,  'Floodplain',          /* 'Aue' */      'alluvium / flood plain',                     'alluvium / flood plain'),
                (5,  3,  'MineSite',            /* 'Be' */       'mine / shaft / galleries',                   'mine / shaft / galleries'),
                (6,  15, 'FortHilltop',         /* 'befHöhS' */  'fortified hilltop settlement / enclosure',   'fortified hilltop settlement / enclosure'),
                (7,  15, 'FortSettlement',      /* 'befSied' */  'fortified settlement / enclosure',           'fortified settlement / enclosure'),
                (8,  15, 'Castle',              /* 'Burg' */     'castle / château',                           'castle / château'),
                (9,  4,  'AnthroOther',         /* 'FustelSo' */ 'other anthropogenic deposit',                'other anthropogenic deposit'),
                (10, 15, 'CommBuilding',        /* 'GemGeb' */   'communal building',                          'communal building'),
                (11, 9,  'Cemetery',            /* 'Grab' */     'burial ground / cemetery',                   'burial ground / cemetery'),
                (12, 5,  'Workshop',            /* 'Ha' */       'workshop (incl. mill)',                      'workshop (incl. mill)'),
                (13, 6,  'Harbour',             /* 'Haf' */      'harbour / landing',                          'harbour / landing'),
                (14, 7,  'Cave',                /* 'Hö' */       'cave',                                       'cave'),
                (15, 15, 'HillSettlement',      /* 'HöhS' */     'unfortified hilltop settlement',             'unfortified hilltop settlement'),
                (16, 15, 'FortMilitary',        /* 'Kas' */      'fortress / military camp / military context' ,'fortress / military camp / military context'),
                (17, 9,  'Church',              /* 'Kirche' */   'church / monastery / sanctuary',             'church / monastery / sanctuary'),
                (18, 8,  'Colluvium',           /* 'Kol' */      'colluvium',                                  'colluvium'),
                (19, 9,  'CultOther',           /* 'KultSo' */   'other place of cult',                        'other place of cult'),
                (20, 15, 'RuralOther',          /* 'LändSo' */   'other rural setting',                        'other rural setting'),
                (21, 10, 'SeaSite',             /* 'Meer' */     'sea',                                        'sea'),
                (22, 11, 'CharcoalKiln',        /* 'Mei' */      'charcoal kiln / charburnery',                'charcoal kiln / charburnery'),
                (23, 12, 'SwampSite',           /* 'Moor' */     'swamp',                                      'swamp'),
                (24, 13, 'NaturalOther',        /* 'natSo' */    'other natural sediment',                     'other natural sediment'),
                (25, 14, 'Channel',             /* 'Rin' */      'channel / waterway',                         'channel / waterway'),
                (26, 14, 'LakeSite',            /* 'See' */      'lake / pond / basin',                        'lake / pond / basin'),
                (27, 15, 'LakesideSettlement',  /* 'SeeMo' */    'lakeside dwelling',                          'lakeside dwelling'),
                (28, 15, 'SettlementOpen',      /* 'Siedl' */    'open settlement',                            'open settlement'),
                (29, 15, 'SettlementOther',     /* 'SiedSo' */   'other settlement',                           'other settlement'),
                (30, 15, 'Urban',               /* 'Stadt' */    'urban settlement',                           'urban settlement'),
                (31, 15, 'Tell',                /* 'Tell' */     'tell',                                       'tell'),
                (32, 16, 'Unknown',             /* 'unbek' */    'unknown type of site',                       'unknown type of site'),
                (33, 15, 'Vicus',               /* 'Vicus' */    'vicus',                                      'vicus'),
                (34, 15, 'VillaFarmstead',      /* 'Villa' */    'Villa rustica / farmstead',                  'Villa rustica / farmstead'),
                (35, 6,  'Shipwreck',           /* 'Wra' */      'shipwreck',                                  'shipwreck'),
                (36, 15, 'Wharf',               /* 'Wurt' */     'wharf / artificial mound',                   'wharf / artificial mound')
        )
        insert into tbl_site_types (
            "site_type_id",
            "site_type_group_id",
            "site_type_abbrev",
            "site_type",
            "description"
        )
        select *
        from new_data;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
