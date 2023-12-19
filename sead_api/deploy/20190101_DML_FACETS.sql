-- Deploy sead_api: 20190101_DML_FACETS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Reviewer
  Approver rollback
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
declare s_facets text;
declare s_aggregate_facets text;
declare j_facets jsonb;
begin

    begin

        set search_path = facet, pg_catalog;
        set client_encoding = 'UTF8';

        if current_database() not like 'sead_staging%' then
            raise exception 'This script must be run in sead_staging!';
        end if;

        s_aggregate_facets = $aggregate_facets$
        [
            {
                "facet_id": 1,
                "facet_code": "result_facet",
                "display_title": "Analysis entities",
                "description": "Analysis entities",
                "facet_group_id":"99",
                "facet_type_id": 1,
                "category_id_expr": "tbl_analysis_entities.analysis_entity_id",
                "category_name_expr": "tbl_physical_samples.sample_name||' '||tbl_datasets.dataset_name",
                "sort_expr": "tbl_datasets.dataset_name",
                "is_applicable": false,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": null,
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_analysis_entities",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_physical_samples",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 3,
                        "table_name": "tbl_datasets",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 32,
                "facet_code": "abundances_all_helper",
                "display_title": "Abundances",
                "description": "Abundances",
                "facet_group_id":"4",
                "facet_type_id": 2,
                "category_id_expr": "facet.view_abundance.abundance",
                "category_name_expr": "facet.view_abundance.abundance",
                "sort_expr": "facet.view_abundance.abundance",
                "is_applicable": false,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.view_abundance",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [
                    {
                        "clause": "facet.view_abundance.abundance is not null"
                    } ]
            },
            {
                "facet_id": 40,
                "facet_code": "result_facet_dataset",
                "display_title": "Datasets",
                "description": "Datasets",
                "facet_group_id":"99",
                "facet_type_id": 1,
                "category_id_expr": "tbl_datasets.dataset_id",
                "category_name_expr": "tbl_datasets.dataset_name",
                "sort_expr": "tbl_datasets.dataset_name",
                "is_applicable": false,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of datasets",
                "aggregate_facet_code": null,
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_datasets",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 19,
                "facet_code": "sites_helper",
                "display_title": "Site",
                "description": "Report helper",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_sites.site_id",
                "category_name_expr": "tbl_sites.site_name",
                "sort_expr": "tbl_sites.site_name",
                "is_applicable": false,
                "is_default": true,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            }
        ]
$aggregate_facets$;


		s_facets = $facets$
        [
            {
                "facet_id": 3,
                "facet_code": "tbl_denormalized_measured_values_33_0",
                "display_title": "MS ",
                "description": "MS ",
                "facet_group_id":"5",
                "facet_type_id": 2,
                "category_id_expr": "method_values_33.measured_value",
                "category_name_expr": "method_values_33.measured_value",
                "sort_expr": "method_values_33.measured_value",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.method_measured_values(33,0)",
                        "udf_call_arguments": null,
                        "alias":  "method_values_33"
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 4,
                "facet_code": "tbl_denormalized_measured_values_33_82",
                "display_title": "MS Heating 550",
                "description": "MS Heating 550",
                "facet_group_id":"5",
                "facet_type_id": 2,
                "category_id_expr": "method_values_33_82.measured_value",
                "category_name_expr": "method_values_33_82.measured_value",
                "sort_expr": "method_values_33_82.measured_value",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.method_measured_values(33,82)",
                        "udf_call_arguments": null,
                        "alias":  "method_values_33_82"
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 5,
                "facet_code": "tbl_denormalized_measured_values_32",
                "display_title": "LOI",
                "description": "Loss of ignition",
                "facet_group_id":"5",
                "facet_type_id": 2,
                "category_id_expr": "method_values_32.measured_value",
                "category_name_expr": "method_values_32.measured_value",
                "sort_expr": "method_values_32.measured_value",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.method_measured_values(32,0)",
                        "udf_call_arguments": null,
                        "alias":  "method_values_32"
                    } ],
                    "clauses": [  ]
            },
            {
                "facet_id": 6,
                "facet_code": "tbl_denormalized_measured_values_37",
                "display_title": "P° ",
                "description": "P°",
                "facet_group_id":"5",
                "facet_type_id": 2,
                "category_id_expr": "method_values_37.measured_value",
                "category_name_expr": "method_values_37.measured_value",
                "sort_expr": "method_values_37.measured_value",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.method_measured_values(37,0)",
                        "udf_call_arguments": null,
                        "alias":  "method_values_37"
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 9,
                "facet_code": "map_result",
                "display_title": "Site",
                "description": "Site",
                "facet_group_id":"99",
                "facet_type_id": 1,
                "category_id_expr": "tbl_sites.site_id",
                "category_name_expr": "tbl_sites.site_name",
                "sort_expr": "tbl_sites.site_name",
                "is_applicable": false,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 10,
                "facet_code": "geochronology",
                "display_title": "Geochronology",
                "description": "Sample ages as retrieved through absolute methods such as radiocarbon dating or other radiometric methods (in method based years before present - e.g. 14C years)",
                "facet_group_id":"2",
                "facet_type_id": 2,
                "category_id_expr": "tbl_geochronology.age",
                "category_name_expr": "tbl_geochronology.age",
                "sort_expr": "tbl_geochronology.age",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_geochronology",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 11,
                "facet_code": "relative_age_name",
                "display_title": "Time periods",
                "description": "Age of sample as defined by association with a (often regionally specific) cultural or geological period (in years before present)",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_relative_ages.relative_age_id",
                "category_name_expr": "tbl_relative_ages.relative_age_name",
                "sort_expr": "tbl_relative_ages.relative_age_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_relative_ages",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 12,
                "facet_code": "record_types",
                "display_title": "Proxy types",
                "description": "Proxy types",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_record_types.record_type_id",
                "category_name_expr": "tbl_record_types.record_type_name",
                "sort_expr": "tbl_record_types.record_type_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_record_types",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 13,
                "facet_code": "sample_groups",
                "display_title": "Sample group",
                "description": "A collection of samples, usually defined by the excavator or collector",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_sample_groups.sample_group_id",
                "category_name_expr": "tbl_sample_groups.sample_group_name",
                "sort_expr": "tbl_sample_groups.sample_group_name",
                "is_applicable": true,
                "is_default": true,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_sample_groups",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 18,
                "facet_code": "sites",
                "display_title": "Site",
                "description": "General name for the excavation or sampling location",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_sites.site_id",
                "category_name_expr": "tbl_sites.site_name",
                "sort_expr": "tbl_sites.site_name",
                "is_applicable": true,
                "is_default": true,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 21,
                "facet_code": "country",
                "display_title": "Country",
                "description": "The name of the country, at the time of collection, in which the samples were collected",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "countries.location_id",
                "category_name_expr": "countries.location_name ",
                "sort_expr": "countries.location_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_locations",
                        "udf_call_arguments": null,
                        "alias":  "countries"
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_site_locations",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [
                    {
                        "clause": "countries.location_type_id=1"
                    } ]
            },
            {
                "facet_id": 22,
                "facet_code": "ecocode",
                "display_title": "Eco code",
                "description": "Ecological category (trait) or cultural relevance of organisms based on a classification system",
                "facet_group_id":"4",
                "facet_type_id": 1,
                "category_id_expr": "tbl_ecocode_definitions.ecocode_definition_id",
                "category_name_expr": "tbl_ecocode_definitions.name",
                "sort_expr": "tbl_ecocode_definitions.name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_ecocode_definitions",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_ecocode_definitions",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 23,
                "facet_code": "family",
                "display_title": "Family",
                "description": "Taxonomic family",
                "facet_group_id":"6",
                "facet_type_id": 1,
                "category_id_expr": "tbl_taxa_tree_families.family_id",
                "category_name_expr": "tbl_taxa_tree_families.family_name ",
                "sort_expr": "tbl_taxa_tree_families.family_name ",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_taxa_tree_families",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_taxa_tree_families",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 24,
                "facet_code": "genus",
                "display_title": "Genus",
                "description": "Taxonomic genus (under family)",
                "facet_group_id":"6",
                "facet_type_id": 1,
                "category_id_expr": "tbl_taxa_tree_genera.genus_id",
                "category_name_expr": "tbl_taxa_tree_genera.genus_name",
                "sort_expr": "tbl_taxa_tree_genera.genus_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_taxa_tree_genera",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_taxa_tree_genera",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 25,
                "facet_code": "species",
                "display_title": "Taxa",
                "description": "Taxonomic species (under genus)",
                "facet_group_id":"6",
                "facet_type_id": 1,
                "category_id_expr": "tbl_taxa_tree_master.taxon_id",
                "category_name_expr": "concat_ws(' ', tbl_taxa_tree_genera.genus_name, tbl_taxa_tree_master.species, tbl_taxa_tree_authors.author_name)",
                "sort_expr": "tbl_taxa_tree_genera.genus_name||' '||tbl_taxa_tree_master.species",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "sum",
                "aggregate_title": "sum of Abundance",
                "aggregate_facet_code": "abundances_all_helper",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_taxa_tree_master",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_taxa_tree_genera",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 3,
                        "table_name": "tbl_taxa_tree_authors",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 4,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [
                    {
                        "clause": "tbl_sites.site_id is not null"
                    } ]
            },
            {
                "facet_id": 28,
                "facet_code": "species_author",
                "display_title": "Author",
                "description": "Authority of the taxonomic name (not used for all species)",
                "facet_group_id":"6",
                "facet_type_id": 1,
                "category_id_expr": "tbl_taxa_tree_authors.author_id ",
                "category_name_expr": "tbl_taxa_tree_authors.author_name ",
                "sort_expr": "tbl_taxa_tree_authors.author_name ",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_taxa_tree_authors",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_taxa_tree_authors",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 29,
                "facet_code": "feature_type",
                "display_title": "Feature type",
                "description": "Feature type",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_feature_types.feature_type_id ",
                "category_name_expr": "tbl_feature_types.feature_type_name",
                "sort_expr": "tbl_feature_types.feature_type_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_feature_types",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_physical_sample_features",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 30,
                "facet_code": "ecocode_system",
                "display_title": "Eco code system",
                "description": "Ecological or cultural organism classification system (which groups items in the ecological/cultural category filter)",
                "facet_group_id":"4",
                "facet_type_id": 1,
                "category_id_expr": "tbl_ecocode_systems.ecocode_system_id ",
                "category_name_expr": "tbl_ecocode_systems.name",
                "sort_expr": "tbl_ecocode_systems.definition",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_ecocode_systems",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_ecocode_systems",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 31,
                "facet_code": "abundance_classification",
                "display_title": "abundance classification",
                "description": "abundance classification",
                "facet_group_id":"4",
                "facet_type_id": 1,
                "category_id_expr": "facet.view_abundance.elements_part_mod ",
                "category_name_expr": "facet.view_abundance.elements_part_mod ",
                "sort_expr": "facet.view_abundance.elements_part_mod ",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.view_abundance",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 33,
                "facet_code": "abundances_all",
                "display_title": "Abundances",
                "description": "Abundances",
                "facet_group_id":"4",
                "facet_type_id": 2,
                "category_id_expr": "facet.view_abundance.abundance",
                "category_name_expr": "facet.view_abundance.abundance",
                "sort_expr": "facet.view_abundance.abundance",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.view_abundance",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [
                    {
                        "clause": "facet.view_abundance.abundance is not null"
                    } ]
            },
            {
                "facet_id": 34,
                "facet_code": "activeseason",
                "display_title": "Seasons",
                "description": "Seasons",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_seasons.season_id",
                "category_name_expr": "tbl_seasons.season_name",
                "sort_expr": "tbl_seasons.season_type ",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_seasons",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 35,
                "facet_code": "tbl_biblio_modern",
                "display_title": "Bibligraphy modern",
                "description": "Bibligraphy modern",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "facet.view_taxa_biblio.biblio_id",
                "category_name_expr": "tbl_biblio.title||'  '||tbl_biblio.authors ",
                "sort_expr": "tbl_biblio.authors",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "count of species",
                "aggregate_facet_code": "sites_helper",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "facet.view_taxa_biblio",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_biblio",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 36,
                "facet_code": "tbl_biblio_sample_groups",
                "display_title": "Bibligraphy sites/Samplegroups",
                "description": "Bibligraphy sites/Samplegroups",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_biblio.biblio_id",
                "category_name_expr": "tbl_biblio.title||'  '||tbl_biblio.authors",
                "sort_expr": "tbl_biblio.authors",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_biblio",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "facet.view_sample_group_references",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [
                    {
                        "clause": "facet.view_sample_group_references.biblio_id is not null"
                    } ]
            },
            {
                "facet_id": 37,
                "facet_code": "tbl_biblio_sites",
                "display_title": "Bibligraphy sites",
                "description": "Bibligraphy sites",
                "facet_group_id":"1",
                "facet_type_id": 1,
                "category_id_expr": "tbl_biblio.biblio_id",
                "category_name_expr": "tbl_biblio.title||'  '||tbl_biblio.authors",
                "sort_expr": "tbl_biblio.authors",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_biblio",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "facet.view_site_references",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [
                    {
                        "clause": "facet.view_site_references.biblio_id is not null"
                    } ]
            },
            {
                "facet_id": 38,
                "facet_code": "dataset_master",
                "display_title": "Master datasets",
                "description": "Master datasets",
                "facet_group_id": "2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_dataset_masters.master_set_id ",
                "category_name_expr": "tbl_dataset_masters.master_name",
                "sort_expr": "tbl_dataset_masters.master_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_dataset_masters",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
                "clauses": [  ]
            },
            {
                "facet_id": 39,
                "facet_code": "dataset_methods",
                "display_title": "Dataset methods",
                "description": "Dataset methods",
                "facet_group_id": "2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_methods.method_id ",
                "category_name_expr": "tbl_methods.method_name",
                "sort_expr": "tbl_methods.method_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of datasets",
                "aggregate_facet_code": "result_facet_dataset",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_dataset_masters",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_datasets",
                        "udf_call_arguments": null,
                        "alias":  null
                    }
                ],
                "clauses": [  ]
            },
            {
                "facet_id": 41,
                "facet_code": "region",
                "display_title": "Region",
                "description": "Region",
                "facet_group_id": "2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_locations.location_id ",
                "category_name_expr": "tbl_locations.location_name || '  ' || tbl_sites.site_name",
                "sort_expr": "tbl_locations.location_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_locations",
                        "udf_call_arguments": null,
                        "alias":  "null"
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_site_locations",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 3,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    } ],
	            "clauses": [ {
		            "clause": "tbl_locations.location_type_id in (2, 7, 14, 16, 18)"
	} ]
}
]

$facets$;

        /* Add aggregate facets */
        j_facets = s_aggregate_facets::jsonb;
        perform facet.create_or_update_facet(v.facet::jsonb)
            from jsonb_array_elements(j_facets) as v(facet);

        /* Add normal facets */
        j_facets = s_facets::jsonb;

        perform facet.create_or_update_facet(v.facet::jsonb)
            from jsonb_array_elements(j_facets) as v(facet);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
