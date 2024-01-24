-- Deploy archaeobotany: 20200422_DML_MAL_TAXA_SP_SPP_QOS_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
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

        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        /* Source: SP SPP lookup table.xlsx */
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 4052;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 3692;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 4491;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 4277;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 3015;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 4605;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 4340;
        UPDATE tbl_abundances SET taxon_id = 18171 WHERE abundance_id = 4750;
        UPDATE tbl_abundances SET taxon_id = 18171 WHERE abundance_id = 5151;
        UPDATE tbl_abundances SET taxon_id = 18171 WHERE abundance_id = 3397;
        UPDATE tbl_abundances SET taxon_id = 18182 WHERE abundance_id = 3388;

         /* Source: SP SPP lookup table.xlsx */
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18260;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18244;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18091;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18008;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18252;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18142;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18076;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18098;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18239;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18183;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18176;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18202;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18100;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18109;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18024;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18026;
        UPDATE tbl_taxa_tree_master SET species = 'spp.' WHERE taxon_id = 18245;

         /* Source: https://github.com/humlab-sead/sead_change_control/issues/51#issuecomment-606533067 */
        DELETE FROM tbl_taxa_tree_master
            WHERE taxon_id in (
                18136,
                18119
            );

        /* Source: https://github.com/humlab-sead/sead_change_control/issues/51#issuecomment-603806701 */
        DELETE FROM tbl_taxa_tree_master
            WHERE taxon_id in (
                -- biblio_id, autor_id, date_updated, genus_id, species, genus_name
                18257, --   NULL	2014-02-19 14:28:44	778	sp	Alopecurus
                18094, --   NULL	2013-11-13 14:33:32	938	sp	Amelanchier
                18207, --   NULL	2014-02-19 14:28:44	485	sp	Arctostaphylos
                18068, --   NULL	2013-05-13 09:29:56	785	sp	Arrhenatherum
                18157, --   NULL	2013-11-13 14:33:32	400	sp	Atriplex
                18163, --   NULL	2013-11-13 14:33:32	299	sp	Brassica
                18051, --   NULL	2013-05-13 09:29:56	791	sp	Bromus
                18048, --   NULL	2013-05-13 09:29:56	303	sp	Camelina
                18187, --   NULL	2014-02-19 14:28:44	356	sp	Campanula
                18014, --   NULL	2013-05-13 09:29:56	454	sp	Carex
                18152, --   NULL	2013-11-13 14:33:32	9795	sp	Caryophyllaceae
                18125, --   NULL	2013-11-13 14:33:32	371	sp	Cerastium
                18013, --   NULL	2013-05-13 09:29:56	404	sp	Chenopodium
                18206, --   NULL	2014-02-19 14:28:44	147	sp	Cirsium
                18126, --   NULL	2013-11-13 14:33:32	947	sp	Crataegus
                18160, --   NULL	2013-11-13 14:33:32	805	sp	Danthonia
                18058, --   NULL	2013-05-13 09:29:56	810	sp	Echinochloa
                18015, --   NULL	2013-05-13 09:29:56	9777	sp	Echinochloa/Setaria
                18066, --   NULL	2013-05-13 09:29:56	457	sp	Eleocharis
                18237, --   NULL	2014-02-19 14:28:44	891	sp	Fallopia
                18080, --   NULL	2013-11-13 14:33:32	820	sp	Festuca
                18223, --   NULL	2014-02-19 14:28:44	558	sp	Fumaria
                18006, --   NULL	2013-05-13 09:29:56	613	sp	Galeopsis
                18022, --   NULL	2013-05-13 09:29:56	975	sp	Galium
                18041, --   NULL	2013-05-13 09:29:56	521	sp	Genista
                18158, --   NULL	2013-11-13 14:33:32	179	sp	Helianthus
                18145, --   NULL	2013-11-13 14:33:32	9794	sp	Hordeum/Avena
                18139, --   NULL	2013-11-13 14:33:32	9793	sp	Hordeum/Triticum
                18062, --   NULL	2013-05-13 09:29:56	1029	sp	Hyoscyamus
                18131, --   NULL	2013-11-13 14:33:32	603	sp	Juncus
                18137, --   NULL	2013-11-13 14:33:32	450	sp	Juniperus
                18141, --   NULL	2013-11-13 14:33:32	619	sp	Lamium
                18078, --   NULL	2013-05-16 08:39:58	837	sp	Lolium
                18038, --   NULL	2013-05-13 09:29:56	604	sp	Luzula
                18037, --   NULL	2013-05-13 09:29:56	741	sp	Melampyrum
                18113, --   NULL	2013-11-13 14:33:32	534	sp	Ononis
                18067, --   NULL	2013-05-13 09:29:56	894	sp	Persicaria
                18143, --   NULL	2013-11-13 14:33:32	763	sp	Picea
                18081, --   NULL	2013-11-13 14:33:32	764	sp	Pinus
                18149, --   NULL	2013-11-13 14:33:32	855	sp	Poa
                18140, --   NULL	2013-11-13 14:33:32	895	sp	Polygonum
                18090, --   NULL	2013-11-13 14:33:32	983	sp	Populus
                18133, --   NULL	2013-11-13 14:33:32	905	sp	Potamogeton
                17998, --   NULL	2013-05-13 09:29:56	959	sp	Potentilla
                18155, --   NULL	2013-11-13 14:33:32	634	sp	Prunella
                18112, --   NULL	2013-11-13 14:33:32	551	sp	Quercus
                18056, --   NULL	2013-05-13 09:29:56	746	sp	Rhinanthus
                18096, --   NULL	2013-11-13 14:33:32	342	sp	Rorippa
                18063, --   NULL	2013-05-13 09:29:56	964	sp	Rubus
                18029, --   NULL	2013-05-13 09:29:56	9780	sp	Rubus subg. Rubus
                18031, --   NULL	2013-05-13 09:29:56	897	sp	Rumex
                18099, --   NULL	2013-11-13 14:33:32	979	sp	Ruppia
                18057, --   NULL	2013-05-13 09:29:56	390	sp	Scleranthus
                18046, --   NULL	2013-05-13 09:29:56	863	sp	Secale
                18117, --   NULL	2013-11-13 14:33:32	9791	sp	Secale/Triticum
                18027, --   NULL	2013-05-13 09:29:56	865	sp	Setaria
                18216, --   NULL	2014-02-19 14:28:44	9805	sp	Setaria/Danthonia
                18204, --   NULL	2014-02-19 14:28:44	9799	sp	Setaria/Echinochloa
                18129, --   NULL	2013-11-13 14:33:32	391	sp	Silene
                18084, --   NULL	2013-11-13 14:33:32	1041	sp	Solanum
                18000, --   NULL	2013-05-13 09:29:56	392	sp	Spergula
                18110, --   NULL	2013-11-13 14:33:32	640	sp	Stachys
                18019, --   NULL	2013-05-13 09:29:56	545	sp	Trifolium
                18089, --   NULL	2013-11-13 14:33:32	1063	sp	Urtica
                18130, --   NULL	2013-11-13 14:33:32	1020	sp	Verbascum
                18101, --   NULL	2013-11-13 14:33:32	1021	sp	Veronica
                18004, --   NULL	2013-05-13 09:29:56	548	sp	Vicia
                18173, --   NULL	2014-02-19 14:28:44	9798	sp	Vicia/Pisum
                18042  --   NULL	2013-05-13 09:29:56	1070	sp	Viola
            );

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
