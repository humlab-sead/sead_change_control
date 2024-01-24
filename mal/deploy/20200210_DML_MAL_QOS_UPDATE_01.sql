-- Deploy archaeobotany: 20200210_DML_MAL_QOS_UPDATE_01

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
declare d_current_timestamp timestamp with time zone;
begin
    begin

        d_current_timestamp = '2020-02-09 11:31:48.779767+00';

        /* tbl_abundances abundance update of MAL macrofossil dataset */

        UPDATE public.tbl_abundances
        	SET abundance=4, date_updated=d_current_timestamp
        	WHERE abundance_id = 264;

        UPDATE public.tbl_abundances
        	SET abundance=12, date_updated=d_current_timestamp
        	WHERE abundance_id = 8481;

        UPDATE public.tbl_abundances
        	SET abundance=30, date_updated=d_current_timestamp
        	WHERE abundance_id = 8411;

        UPDATE public.tbl_abundances
        	SET abundance=50, date_updated=d_current_timestamp
        	WHERE abundance_id = 8260;

        UPDATE public.tbl_abundances
        	SET abundance=18, date_updated=d_current_timestamp
        	WHERE abundance_id = 2948;

        UPDATE public.tbl_abundances
        	SET abundance=1, date_updated=d_current_timestamp
        	WHERE abundance_id = 4878;

        UPDATE public.tbl_abundances
        	SET abundance=100, date_updated=d_current_timestamp
        	WHERE abundance_id = 5680;

        /* tbl_abundances taxon correction of MAL macrofossil dataset */

        UPDATE public.tbl_abundances
        	SET taxon_id=18008, date_updated=d_current_timestamp
        	WHERE abundance_id = 1551;

        UPDATE public.tbl_abundances
        	SET taxon_id=18025, date_updated=d_current_timestamp
        	WHERE abundance_id = 5030;

        UPDATE public.tbl_abundances
        	SET taxon_id=18010, date_updated=d_current_timestamp
        	WHERE abundance_id = 4426;

        UPDATE public.tbl_abundances
        	SET taxon_id=17995, date_updated=d_current_timestamp
        	WHERE abundance_id = 3134;

        UPDATE public.tbl_abundances
        	SET taxon_id=4211, date_updated=d_current_timestamp
        	WHERE abundance_id = 3287;

        UPDATE public.tbl_abundances
        	SET taxon_id=39582, date_updated=d_current_timestamp
        	WHERE abundance_id = 2486;

        UPDATE public.tbl_abundances
        	SET taxon_id=18018, date_updated=d_current_timestamp
        	WHERE abundance_id = 3742;

        UPDATE public.tbl_abundances
        	SET taxon_id=18070, date_updated=d_current_timestamp
        	WHERE abundance_id = 4809;

        UPDATE public.tbl_abundances
        	SET taxon_id=18086, date_updated=d_current_timestamp
        	WHERE abundance_id = 4451;

        UPDATE public.tbl_abundances
        	SET taxon_id=18012, date_updated=d_current_timestamp
        	WHERE abundance_id = 3459;

        UPDATE public.tbl_abundances
        	SET taxon_id=4901, date_updated=d_current_timestamp
        	WHERE abundance_id = 4759;

        UPDATE public.tbl_abundances
        	SET taxon_id=4901, date_updated=d_current_timestamp
        	WHERE abundance_id = 3424;

        UPDATE public.tbl_abundances
        	SET taxon_id=4610, date_updated=d_current_timestamp
        	WHERE abundance_id = 5727;

        UPDATE public.tbl_abundances
        	SET taxon_id=4610, date_updated=d_current_timestamp
        	WHERE abundance_id = 5568;

        UPDATE public.tbl_abundances
        	SET taxon_id=4610, date_updated=d_current_timestamp
        	WHERE abundance_id = 8115;

        UPDATE public.tbl_abundances
        	SET taxon_id=4610, date_updated=d_current_timestamp
        	WHERE abundance_id = 6694;

        UPDATE public.tbl_abundances
        	SET taxon_id=18108, date_updated=d_current_timestamp
        	WHERE abundance_id = 7210;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 5934;

        UPDATE public.tbl_abundances
        	SET taxon_id=18108, date_updated=d_current_timestamp
        	WHERE abundance_id = 6801;

        UPDATE public.tbl_abundances
        	SET taxon_id=3972, date_updated=d_current_timestamp
        	WHERE abundance_id = 8524;

        UPDATE public.tbl_abundances
        	SET taxon_id=18191, date_updated=d_current_timestamp
        	WHERE abundance_id = 8676;

        UPDATE public.tbl_abundances
        	SET taxon_id=18191, date_updated=d_current_timestamp
        	WHERE abundance_id = 8419;

        UPDATE public.tbl_abundances
        	SET taxon_id=39575, date_updated=d_current_timestamp
        	WHERE abundance_id = 7544;

        UPDATE public.tbl_abundances
        	SET taxon_id=39575, date_updated=d_current_timestamp
        	WHERE abundance_id = 6928;

        UPDATE public.tbl_abundances
        	SET taxon_id=39575, date_updated=d_current_timestamp
        	WHERE abundance_id = 5878;

        UPDATE public.tbl_abundances
        	SET taxon_id=39575, date_updated=d_current_timestamp
        	WHERE abundance_id = 6467;

        UPDATE public.tbl_abundances
        	SET taxon_id=39575, date_updated=d_current_timestamp
        	WHERE abundance_id = 7530;

        UPDATE public.tbl_abundances
        	SET taxon_id=4196, date_updated=d_current_timestamp
        	WHERE abundance_id = 6750;

        UPDATE public.tbl_abundances
        	SET taxon_id=4196, date_updated=d_current_timestamp
        	WHERE abundance_id = 6984;

        UPDATE public.tbl_abundances
        	SET taxon_id=3972, date_updated=d_current_timestamp
        	WHERE abundance_id = 7875;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 5485;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 5489;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7550;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7365;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7796;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7703;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7802;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7896;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7929;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8045;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8168;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8071;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8179;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8183;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8120;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8570;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8351;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 8586;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 5513;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 5709;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 6108;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 6285;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 6562;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 6624;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7035;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 6326;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7043;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 6397;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7119;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7169;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7230;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7447;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7501;

        UPDATE public.tbl_abundances
        	SET taxon_id=39573, date_updated=d_current_timestamp
        	WHERE abundance_id = 7336;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 5511;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 7507;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 5672;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 5679;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 6453;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 5900;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 6471;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 7156;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 7936;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 7563;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 6702;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 6819;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 7420;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 7621;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 8379;

        UPDATE public.tbl_abundances
        	SET taxon_id=39574, date_updated=d_current_timestamp
        	WHERE abundance_id = 8028;

        /* tbl_physical_samples sample name correction */

        UPDATE public.tbl_physical_samples
        	SET sample_name='MP 4', date_updated=d_current_timestamp
        	WHERE physical_sample_id=7176;

        UPDATE public.tbl_physical_samples
        	SET sample_name='MP 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=16030;

        UPDATE public.tbl_physical_samples
        	SET sample_name='MP 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=17628;

        UPDATE public.tbl_physical_samples
        	SET sample_name='MP 3', date_updated=d_current_timestamp
        	WHERE physical_sample_id=17987;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Jp 3', date_updated=d_current_timestamp
        	WHERE physical_sample_id=6012;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Jp 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=8420;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Jp 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=11643;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 3', date_updated=d_current_timestamp
        	WHERE physical_sample_id=7042;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=13568;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=13685;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 6', date_updated=d_current_timestamp
        	WHERE physical_sample_id=14309;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 5', date_updated=d_current_timestamp
        	WHERE physical_sample_id=15917;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 4', date_updated=d_current_timestamp
        	WHERE physical_sample_id=16688;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Prov 1', date_updated=d_current_timestamp, date_sampled=1994
        	WHERE physical_sample_id=8078;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=10065;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 6', date_updated=d_current_timestamp
        	WHERE physical_sample_id=10472;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 5', date_updated=d_current_timestamp
        	WHERE physical_sample_id=15007;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 3', date_updated=d_current_timestamp
        	WHERE physical_sample_id=16945;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=17244;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 4', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18117;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 5', date_updated=d_current_timestamp
        	WHERE physical_sample_id=10571;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 7', date_updated=d_current_timestamp
        	WHERE physical_sample_id=15251;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 3', date_updated=d_current_timestamp
        	WHERE physical_sample_id=15794;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 6', date_updated=d_current_timestamp
        	WHERE physical_sample_id=15902;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=17094;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 9', date_updated=d_current_timestamp
        	WHERE physical_sample_id=17942;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 8', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18241;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18248;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 4', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18264;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 4', date_updated=d_current_timestamp
        	WHERE physical_sample_id=10802;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 3', date_updated=d_current_timestamp
        	WHERE physical_sample_id=12794;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=14272;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=14602;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Jp 13', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18428;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Jp 5', date_updated=d_current_timestamp
        	WHERE physical_sample_id=20136;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Jp 4', date_updated=d_current_timestamp
        	WHERE physical_sample_id=22599;

        UPDATE public.tbl_physical_samples
        	SET sample_name='A 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=23749;

        UPDATE public.tbl_physical_samples
        	SET sample_name='A 5', date_updated=d_current_timestamp
        	WHERE physical_sample_id=25452;

        UPDATE public.tbl_physical_samples
        	SET sample_name='4100', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18496;

        UPDATE public.tbl_physical_samples
        	SET sample_name='9479', date_updated=d_current_timestamp
        	WHERE physical_sample_id=21992;

        UPDATE public.tbl_physical_samples
        	SET sample_name='3683', date_updated=d_current_timestamp
        	WHERE physical_sample_id=24814;

        UPDATE public.tbl_physical_samples
        	SET sample_name='7239', date_updated=d_current_timestamp
        	WHERE physical_sample_id=25583;

        UPDATE public.tbl_physical_samples
        	SET sample_name='1109', date_updated=d_current_timestamp
        	WHERE physical_sample_id=21539;

        UPDATE public.tbl_physical_samples
        	SET sample_name='1071', date_updated=d_current_timestamp
        	WHERE physical_sample_id=24371;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Prov 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=18938;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Prov 2', date_updated=d_current_timestamp
        	WHERE physical_sample_id=25812;

        UPDATE public.tbl_physical_samples
        	SET sample_name='J27', date_updated=d_current_timestamp, date_sampled=2008
        	WHERE physical_sample_id=19242;

        UPDATE public.tbl_physical_samples
        	SET sample_name='J10', date_updated=d_current_timestamp, date_sampled=2008
        	WHERE physical_sample_id=20317;

        UPDATE public.tbl_physical_samples
        	SET sample_name='J25', date_updated=d_current_timestamp, date_sampled=2008
        	WHERE physical_sample_id=20649;

        UPDATE public.tbl_physical_samples
        	SET sample_name='J3', date_updated=d_current_timestamp, date_sampled=2008
        	WHERE physical_sample_id=22479;

        UPDATE public.tbl_physical_samples
        	SET sample_name='J22', date_updated=d_current_timestamp, date_sampled=2008
        	WHERE physical_sample_id=22721;

        UPDATE public.tbl_physical_samples
        	SET sample_name='J29', date_updated=d_current_timestamp, date_sampled=2008
        	WHERE physical_sample_id=23017;

        UPDATE public.tbl_physical_samples
        	SET sample_name='Sample 1', date_updated=d_current_timestamp
        	WHERE physical_sample_id=5775;

        /* tbl_sites MAL geografical dataset updated to contain correct coordinates */

        UPDATE public.tbl_sites
        	SET altitude=15, latitude_dd=56.8882889, longitude_dd=12.5898222, date_updated=d_current_timestamp
        	WHERE site_id=57;

        UPDATE public.tbl_sites
        	SET latitude_dd=55.5672222226, longitude_dd=12.9844444, date_updated=d_current_timestamp
        	WHERE site_id=78;

        UPDATE public.tbl_sites
        	SET latitude_dd=55.5638888889, longitude_dd=12.9794444, date_updated=d_current_timestamp
        	WHERE site_id=84;

        UPDATE public.tbl_sites
        	SET latitude_dd=68.6027777778, longitude_dd=19.8483333, date_updated=d_current_timestamp
        	WHERE site_id=85;

        UPDATE public.tbl_sites
        	SET latitude_dd=57.4808833337, longitude_dd=12.6857750, date_updated=d_current_timestamp
        	WHERE site_id=90;

        UPDATE public.tbl_sites
        	SET latitude_dd=70.4894444441, longitude_dd=29.2500000, date_updated=d_current_timestamp
        	WHERE site_id=97;

        UPDATE public.tbl_sites
        	SET latitude_dd=70.3221555559, longitude_dd=25.1738639, date_updated=d_current_timestamp
        	WHERE site_id=100;

        UPDATE public.tbl_sites
        	SET latitude_dd=55.5611111111, longitude_dd=12.9716667, date_updated=d_current_timestamp
        	WHERE site_id=105;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.2238444448, longitude_dd=11.4983500, date_updated=d_current_timestamp
        	WHERE site_id=111;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.1138888889, longitude_dd=9.7980556, date_updated=d_current_timestamp
        	WHERE site_id=119;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.2758333337, longitude_dd=11.6069444, date_updated=d_current_timestamp
        	WHERE site_id=121;

        UPDATE public.tbl_sites
        	SET latitude_dd=55.9519444444, longitude_dd=11.8752778, date_updated=d_current_timestamp
        	WHERE site_id=122;

        UPDATE public.tbl_sites
        	SET latitude_dd=70.6983333330, longitude_dd=23.6280556, date_updated=d_current_timestamp
        	WHERE site_id=123;

        UPDATE public.tbl_sites
        	SET latitude_dd=58.4809444448, longitude_dd=13.4798472, date_updated=d_current_timestamp
        	WHERE site_id=124;

        UPDATE public.tbl_sites
        	SET latitude_dd=55.1130555556, longitude_dd=14.8705556, date_updated=d_current_timestamp
        	WHERE site_id=128;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.2220416670, longitude_dd=11.4927944, date_updated=d_current_timestamp
        	WHERE site_id=132;

        UPDATE public.tbl_sites
        	SET latitude_dd=70.9619444444, longitude_dd=26.6700000, date_updated=d_current_timestamp
        	WHERE site_id=135;

        UPDATE public.tbl_sites
        	SET latitude_dd=63.5861750, longitude_dd=19.7208000, date_updated=d_current_timestamp
        	WHERE site_id=139;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.3736111114, longitude_dd=11.5144444, date_updated=d_current_timestamp
        	WHERE site_id=143;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.3844444441, longitude_dd=11.5433333, date_updated=d_current_timestamp
        	WHERE site_id=153;

        UPDATE public.tbl_sites
        	SET latitude_dd=70.0669444445, longitude_dd=27.5586111, date_updated=d_current_timestamp
        	WHERE site_id=159;

        UPDATE public.tbl_sites
        	SET latitude_dd=58.1368305552, longitude_dd=12.9879639, date_updated=d_current_timestamp
        	WHERE site_id=163;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.2266527781, longitude_dd=11.4976694, date_updated=d_current_timestamp
        	WHERE site_id=165;

        UPDATE public.tbl_sites
        	SET latitude_dd=63.5844444441, longitude_dd=19.5839944, date_updated=d_current_timestamp
        	WHERE site_id=176;

        UPDATE public.tbl_sites
        	SET latitude_dd=60.5190944448, longitude_dd=15.4388000, date_updated=d_current_timestamp
        	WHERE site_id=178;

        UPDATE public.tbl_sites
        	SET altitude=36, latitude_dd=63.8449999997, longitude_dd=20.1447222, date_updated=d_current_timestamp
        	WHERE site_id=186;

        UPDATE public.tbl_sites
        	SET latitude_dd=63.7231278, longitude_dd=20.1977083, date_updated=d_current_timestamp
        	WHERE site_id=193;

        UPDATE public.tbl_sites
        	SET latitude_dd=63.6594167, longitude_dd=19.9786472, date_updated=d_current_timestamp
        	WHERE site_id=203;

        UPDATE public.tbl_sites
        	SET latitude_dd=63.2226500, longitude_dd=18.0569333, date_updated=d_current_timestamp
        	WHERE site_id=209;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.3803250, longitude_dd=15.6283583, date_updated=d_current_timestamp
        	WHERE site_id=213;

        UPDATE public.tbl_sites
        	SET latitude_dd=58.3846361108, longitude_dd=13.8942833, date_updated=d_current_timestamp
        	WHERE site_id=241;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.3833333330, longitude_dd=11.5288889, date_updated=d_current_timestamp
        	WHERE site_id=243;

        UPDATE public.tbl_sites
        	SET altitude=20, latitude_dd=63.3916194, longitude_dd=19.2470694, date_updated=d_current_timestamp
        	WHERE site_id=254;

        UPDATE public.tbl_sites
        	SET latitude_dd=55.5647222222, longitude_dd=12.9733333, date_updated=d_current_timestamp
        	WHERE site_id=257;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.5261111, longitude_dd=18.9977778, date_updated=d_current_timestamp
        	WHERE site_id=258;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.5927222219, longitude_dd=16.4485111, date_updated=d_current_timestamp
        	WHERE site_id=268;

        UPDATE public.tbl_sites
        	SET altitude=44, latitude_dd=66.0204306, longitude_dd=22.6298389, date_updated=d_current_timestamp
        	WHERE site_id=288;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.5347222, longitude_dd=18.5644444, date_updated=d_current_timestamp
        	WHERE site_id=289;

        UPDATE public.tbl_sites
        	SET latitude_dd=65.9296833337, longitude_dd=22.8561528, date_updated=d_current_timestamp
        	WHERE site_id=291;

        UPDATE public.tbl_sites
        	SET altitude=50, latitude_dd=66.0250167, longitude_dd=22.6166667, date_updated=d_current_timestamp
        	WHERE site_id=292;

        UPDATE public.tbl_sites
        	SET latitude_dd=65.9783861114, longitude_dd=19.1512028, date_updated=d_current_timestamp
        	WHERE site_id=294;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.6830555559, longitude_dd=18.9266667, date_updated=d_current_timestamp
        	WHERE site_id=305;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.5152777778, longitude_dd=18.7777778, date_updated=d_current_timestamp
        	WHERE site_id=320;

        UPDATE public.tbl_sites
        	SET altitude=25, latitude_dd=59.6732250, longitude_dd=17.8628361, date_updated=d_current_timestamp
        	WHERE site_id=328;

        UPDATE public.tbl_sites
        	SET altitude=15, latitude_dd=59.6973222, longitude_dd=18.4795028, date_updated=d_current_timestamp
        	WHERE site_id=337;

        UPDATE public.tbl_sites
        	SET latitude_dd=61.1331666670, longitude_dd=16.9196917, date_updated=d_current_timestamp
        	WHERE site_id=345;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.5775000, longitude_dd=18.9636111, date_updated=d_current_timestamp
        	WHERE site_id=350;

        UPDATE public.tbl_sites
        	SET altitude=5, latitude_dd=58.7519722, longitude_dd=17.0113527778, date_updated=d_current_timestamp
        	WHERE site_id=354;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.6833333330, longitude_dd=18.9552778, date_updated=d_current_timestamp
        	WHERE site_id=358;

        UPDATE public.tbl_sites
        	SET latitude_dd=62.5760694448, longitude_dd=12.5677750, date_updated=d_current_timestamp
        	WHERE site_id=373;

        UPDATE public.tbl_sites
        	SET latitude_dd=59.5655555556, longitude_dd=18.9725000, date_updated=d_current_timestamp
        	WHERE site_id=374;

        UPDATE public.tbl_sites
        	SET altitude=45, latitude_dd=66.0217556, longitude_dd=22.6267111, date_updated=d_current_timestamp
        	WHERE site_id=384;

        UPDATE public.tbl_sites
        	SET latitude_dd=64.9952583, longitude_dd=21.3126556, date_updated=d_current_timestamp
        	WHERE site_id=386;

        /* tbl_sites, tbl_locations, tbl_taxa_tree_master typos correction */

        UPDATE public.tbl_sites
        	SET national_site_identifier='Tanum RAÄ 1892', date_updated=d_current_timestamp
        	WHERE site_id=290;

        UPDATE public.tbl_sites
        	SET national_site_identifier='Sundsvall RAÄ 5:1', date_updated=d_current_timestamp
        	WHERE site_id=342;

        UPDATE public.tbl_locations
        	SET location_name='Ovansjö socken', date_updated=d_current_timestamp
        	WHERE location_id=1045;

        UPDATE public.tbl_taxa_tree_master
        	SET species='sceleratus', date_updated=d_current_timestamp
        	WHERE taxon_id=4534;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
