/*

    This file converts updates in ./UPDATE_BUGS_REFERENCES_YEAR.sql (original SQL) which identifies records by biblio_id
      into updates by reference_id. The reason is to avoid problem with changing identities.

    The resulting SQL is inserted in bugs/deploy/20200422_UPDATE_BUGS_REFERENCES_YEAR.sql

    Love's comment:

    Update erronous year in Bugs_references
    I'm not sure how this happened, it does not seem like systematic or offSET date_updated= DEFAULT, error

    This update consists of correcting year, adding DOI and URL
    This update does not remove URL/DOI from title or full_reference
*/

/* Source: Mail från Love */

drop table if exists  public.tbl_biblio_temp;

create table if not exists public.tbl_biblio_temp
(
    biblio_id integer not null,
    bugs_reference character varying(60) null,
    doi character varying(255) null,
    isbn character varying(128) null,
    notes text null,
    title character varying null,
    year character varying(255) null,
    authors character varying null,
    full_reference text null,
    url character varying null,
    constraint pk_biblio_temp primary key (biblio_id)
);

with biblio_ids(biblio_id) as (values
    (411),
    (416),
    (417),
    (424),
    (458),
    (468),
    (469),
    (491),
    (492),
    (512),
    (526),
    (536),
    (560),
    (566),
    (572),
    (574),
    (577),
    (609),
    (614),
    (618),
    (619),
    (625),
    (626),
    (628),
    (630),
    (631),
    (633),
    (643),
    (652),
    (671),
    (674),
    (686),
    (687),
    (691),
    (692),
    (694),
    (696),
    (698),
    (704),
    (705),
    (713),
    (714),
    (720),
    (735),
    (737),
    (749),
    (782),
    (784),
    (793),
    (796),
    (798),
    (799),
    (801),
    (806),
    (808),
    (815),
    (819),
    (820),
    (821),
    (829),
    (832),
    (836),
    (839),
    (849),
    (850),
    (852),
    (865),
    (879),
    (880),
    (882),
    (886),
    (898),
    (913),
    (917),
    (921),
    (922),
    (930),
    (936),
    (939),
    (944),
    (945),
    (964),
    (971),
    (974),
    (976),
    (993),
    (994),
    (995),
    (999),
    (1002),
    (1003),
    (1009),
    (1014),
    (1022),
    (1025),
    (1029),
    (1030),
    (1034),
    (1038),
    (1039),
    (1040),
    (1041),
    (1048),
    (1049),
    (1075),
    (1076),
    (1085),
    (1095),
    (1121),
    (1130),
    (1131),
    (1135),
    (1140),
    (1155),
    (1163),
    (1165),
    (1166),
    (1167),
    (1168),
    (1169),
    (1170),
    (1171),
    (1172),
    (1173),
    (1174),
    (1175),
    (1176),
    (1177),
    (1178),
    (1179),
    (1180),
    (1181),
    (1182),
    (1183),
    (1184),
    (1185),
    (1186),
    (1187),
    (1193),
    (1194),
    (1204),
    (1217),
    (1228),
    (1232),
    (1251),
    (1253),
    (1256),
    (1269),
    (1273),
    (1279),
    (1282),
    (1284),
    (1288),
    (1297),
    (1299),
    (1302),
    (1314),
    (1315),
    (1319),
    (1323),
    (1324),
    (1328),
    (1329),
    (1330),
    (1332),
    (1334),
    (1341),
    (1351),
    (1354),
    (1355),
    (1363),
    (1386),
    (1387),
    (1393),
    (1406),
    (1415),
    (1416),
    (1419),
    (1424),
    (1426),
    (1433),
    (1439),
    (1442),
    (1446),
    (1447),
    (1463),
    (1467),
    (1471),
    (1472),
    (1483),
    (1488),
    (1489),
    (1492),
    (1506),
    (1508),
    (1509),
    (1515),
    (1524),
    (1535),
    (1537),
    (1570),
    (1574),
    (1588),
    (1607),
    (1613),
    (1615),
    (1634),
    (1637),
    (1667),
    (1669),
    (1670),
    (1673),
    (1675),
    (1685),
    (1702),
    (1717),
    (1734),
    (1744),
    (1745),
    (1750),
    (1753),
    (1758),
    (1760),
    (1791),
    (1792),
    (1800),
    (1801),
    (1804),
    (1806),
    (1836),
    (1855),
    (1858),
    (1859),
    (1860),
    (1862),
    (1866),
    (1875),
    (1877),
    (1880),
    (1888),
    (1892),
    (1896),
    (1900),
    (1905),
    (1907),
    (1928),
    (1932),
    (1933),
    (1934),
    (1941),
    (1947),
    (1961),
    (1968),
    (1982),
    (2040),
    (2044),
    (2057),
    (2099),
    (2111),
    (2131),
    (2134),
    (2139),
    (2142),
    (2151),
    (2152),
    (2177),
    (2180),
    (2190),
    (2191),
    (2192),
    (2193),
    (2194),
    (2195),
    (2196),
    (2197),
    (2198),
    (2199),
    (2200),
    (2201),
    (2202),
    (2203),
    (2204),
    (2205),
    (2206),
    (2207),
    (2208),
    (2209),
    (2210),
    (2216),
    (2217),
    (2238),
    (2249),
    (2258),
    (2265),
    (2266),
    (2271),
    (2278),
    (2279),
    (2286),
    (2289),
    (2294),
    (2297),
    (2306),
    (2323),
    (2325),
    (2326),
    (2333),
    (2339),
    (2342),
    (2358),
    (2361),
    (2362),
    (2375),
    (2381),
    (2405),
    (2422),
    (2446),
    (2451),
    (2461),
    (2470),
    (2486),
    (2490),
    (2501),
    (2509),
    (2511),
    (2514),
    (2523),
    (2539),
    (2544),
    (2545),
    (2553),
    (2563),
    (2586),
    (2588),
    (2595),
    (2597),
    (2603),
    (2605),
    (2612),
    (2622),
    (2623),
    (2636),
    (2641),
    (2654),
    (2655),
    (2658),
    (2668),
    (2694),
    (2698),
    (2699),
    (2710),
    (2717),
    (2732),
    (2743),
    (2753),
    (2754),
    (2756),
    (2767),
    (2776),
    (2779),
    (2790),
    (2833),
    (2837),
    (2841),
    (2846),
    (2849),
    (2850),
    (2894),
    (2913),
    (2935),
    (2954),
    (2958),
    (2964),
    (2967),
    (2973),
    (2985),
    (3025),
    (3047),
    (3048),
    (3050),
    (3055),
    (3093),
    (3097),
    (3117),
    (3118),
    (3156),
    (3176),
    (3179),
    (3205),
    (3217),
    (3218),
    (3241),
    (3248),
    (3252),
    (3259),
    (3261),
    (3279),
    (3281),
    (3282),
    (3283),
    (3284),
    (3293),
    (3294),
    (3297),
    (3302),
    (3327),
    (3336),
    (3351),
    (3366),
    (3375),
    (3377),
    (3378),
    (3395),
    (3401),
    (3405),
    (3407),
    (3410),
    (3421),
    (3435),
    (3459),
    (3460),
    (3466),
    (3473),
    (3475),
    (3479),
    (3483),
    (3503),
    (3510),
    (3526),
    (3540),
    (3543),
    (3559),
    (3580),
    (3587),
    (3599),
    (3629),
    (3660),
    (3665),
    (3682),
    (3688),
    (3694),
    (3699),
    (3703),
    (3707),
    (3708),
    (3726),
    (3727),
    (3729),
    (3758),
    (3779),
    (3780),
    (3813),
    (3815),
    (3875),
    (3901),
    (3902),
    (3907),
    (3909),
    (3926),
    (3928),
    (3938),
    (3941),
    (3956),
    (3957),
    (3958),
    (3959),
    (3961),
    (3965),
    (3969),
    (3970),
    (3971),
    (3984),
    (4027),
    (4028),
    (4041),
    (4045),
    (4046),
    (4047),
    (4069),
    (4080),
    (4117),
    (4120),
    (4121),
    (4122),
    (4123),
    (4124),
    (4125),
    (4126),
    (4127),
    (4128),
    (4129),
    (4147),
    (4162),
    (4171),
    (4241),
    (4252),
    (4255),
    (4269),
    (4277),
    (4279),
    (4285),
    (4292),
    (4293),
    (4309),
    (4318),
    (4320),
    (4331),
    (4336),
    (4371),
    (4409),
    (4414),
    (4438),
    (4444),
    (4448),
    (4455),
    (4470),
    (4476),
    (4484),
    (4504),
    (4519),
    (4528),
    (4530),
    (4548),
    (4549),
    (4552),
    (4560),
    (4563),
    (4566),
    (4568),
    (4594),
    (4614),
    (4635),
    (4648),
    (4655),
    (4658),
    (4659),
    (4661),
    (4670),
    (4678),
    (4688),
    (4691),
    (4693),
    (4701),
    (4703),
    (4723),
    (4725),
    (4727),
    (4734),
    (4742),
    (4752),
    (4761),
    (4762),
    (4791),
    (4802),
    (4804),
    (4812),
    (4822),
    (4843),
    (4851),
    (4869),
    (4872),
    (4881),
    (4885),
    (4914),
    (4921),
    (4929),
    (4966),
    (4993),
    (4999),
    (5003),
    (5008),
    (5014),
    (5036),
    (5043),
    (5048),
    (5055),
    (5060),
    (5063),
    (5064),
    (5102),
    (5136),
    (5149),
    (5186),
    (5194),
    (5197),
    (5203),
    (5209),
    (5220),
    (5233),
    (5237),
    (5241),
    (5255),
    (5256),
    (5268),
    (5333),
    (5350),
    (5378),
    (5414),
    (5426),
    (5448),
    (5452),
    (5453),
    (5454),
    (5458),
    (5467),
    (5471),
    (5483),
    (5504),
    (5508),
    (5520),
    (5533),
    (5551),
    (5576),
    (6350),
    (6444),
    (6673),
    (6674),
    (6675),
    (6676),
    (6677),
    (6678),
    (6679),
    (6680),
    (6681),
    (6682),
    (6683),
    (6684),
    (6685),
    (6686),
    (6687),
    (6688),
    (6689),
    (6690),
    (6691),
    (6692),
    (6693),
    (6694),
    (6695),
    (6696),
    (6697),
    (6698),
    (6699),
    (6700),
    (6701),
    (6702),
    (6703),
    (6704),
    (6705),
    (6706),
    (6707),
    (6708),
    (6709),
    (6710),
    (6711),
    (6712),
    (6713),
    (6714),
    (6715),
    (6716),
    (6717),
    (6718),
    (6719),
    (6720),
    (6721),
    (6722),
    (6723),
    (6724),
    (6725),
    (6726),
    (6727),
    (6728),
    (6729),
    (6730),
    (6731),
    (6732),
    (6733),
    (6734),
    (6735),
    (6736),
    (6737),
    (6738),
    (6739),
    (6740),
    (6741),
    (6742),
    (6743),
    (6744),
    (6745),
    (6746),
    (6747),
    (6748),
    (6749),
    (6750),
    (6751),
    (6752),
    (6753),
    (6754),
    (6755),
    (6756),
    (6757),
    (6758),
    (6759),
    (6760),
    (6761),
    (6762),
    (6763),
    (6764),
    (6765),
    (6766),
    (6767),
    (6768),
    (6769),
    (6770),
    (6771),
    (6772),
    (6773),
    (6774),
    (6775),
    (6776),
    (6777),
    (6778),
    (6779),
    (6780),
    (6781),
    (6782),
    (6783),
    (6784),
    (6785),
    (6786),
    (6787),
    (6788),
    (6789),
    (6790),
    (6791),
    (6792),
    (6793),
    (6794),
    (6795),
    (6796),
    (6797),
    (6798),
    (6799),
    (6800),
    (6801),
    (6802),
    (6803),
    (6804),
    (6805),
    (6806),
    (6807),
    (6808),
    (6809),
    (6810),
    (6811),
    (6812),
    (6813),
    (6814),
    (6815),
    (6816),
    (6817),
    (6818),
    (6819),
    (6820),
    (6821),
    (6822),
    (6823),
    (6824),
    (6825),
    (6826),
    (6827),
    (6828),
    (6829),
    (6830),
    (6831),
    (6832),
    (6833),
    (6834),
    (6835),
    (6836),
    (6837),
    (6838),
    (6839),
    (6840),
    (6841),
    (6842),
    (6843),
    (6845),
    (6846),
    (6847),
    (6848),
    (6849),
    (6850),
    (6851),
    (6852),
    (6853),
    (6854),
    (6855),
    (6856),
    (6857),
    (6858),
    (6859),
    (6860),
    (6861),
    (6862),
    (6863),
    (6864),
    (6865),
    (6866),
    (6867),
    (6868),
    (6869),
    (6870),
    (6871),
    (6872),
    (6873),
    (6874),
    (6875),
    (6876),
    (6877),
    (6878),
    (6879),
    (6880),
    (6881),
    (6882),
    (6883),
    (6884),
    (6885),
    (6886),
    (6887),
    (6888),
    (6889),
    (6890),
    (6891),
    (6892),
    (6893),
    (6894),
    (6895),
    (6896),
    (6897),
    (6898),
    (6899),
    (6900),
    (6901),
    (6902),
    (6903),
    (6904),
    (6905),
    (6906),
    (6907),
    (6908),
    (6909),
    (6910),
    (6911),
    (6912),
    (6913),
    (6914),
    (6915),
    (6916),
    (6917),
    (6918),
    (6919),
    (6920),
    (6921),
    (6922),
    (6923),
    (6924),
    (6925),
    (6926),
    (6927),
    (6928),
    (6929),
    (6930),
    (6931),
    (6932),
    (6933),
    (6934),
    (6935),
    (6936),
    (6937),
    (6938),
    (6939),
    (6940),
    (6941),
    (6942),
    (6943),
    (6944),
    (6945),
    (6946),
    (6947),
    (6948),
    (6949),
    (6950),
    (6951),
    (6952),
    (6953),
    (6954),
    (6955),
    (6956),
    (6957),
    (6958),
    (6959),
    (6960),
    (6961),
    (6962),
    (6963),
    (6964),
    (6965),
    (6966),
    (6967),
    (6968),
    (6969),
    (6970),
    (6971),
    (6972),
    (6973),
    (6974),
    (6975),
    (6976),
    (6977),
    (6978),
    (6980),
    (6981),
    (6982),
    (6983),
    (6984),
    (6985),
    (6986),
    (6987),
    (6988),
    (6989),
    (6990),
    (6991),
    (6993),
    (6994),
    (6995),
    (6996),
    (6997),
    (6998),
    (6999),
    (7000),
    (7001),
    (7003),
    (7004),
    (7005),
    (7006),
    (7007),
    (7008),
    (7009),
    (7010),
    (7011),
    (7012),
    (7013),
    (7014),
    (7015),
    (7016),
    (7017),
    (7018),
    (7019),
    (7020),
    (7021),
    (7022),
    (7023),
    (7024),
    (7025),
    (7026),
    (7027),
    (7028),
    (7029),
    (7030),
    (7031),
    (7032),
    (7033),
    (7034),
    (7035),
    (7036),
    (7037),
    (7038),
    (7039),
    (7040),
    (7041),
    (7042),
    (7044),
    (7045),
    (7046),
    (7047),
    (7048),
    (7049),
    (7050),
    (7051),
    (7052),
    (7053),
    (7054),
    (7055),
    (7056),
    (7057),
    (7058),
    (7062),
    (7063),
    (7064),
    (7065),
    (7066),
    (7067),
    (7068),
    (7069),
    (7070),
    (7071),
    (7072),
    (7073),
    (7074),
    (7075),
    (7076),
    (7077),
    (7078),
    (7079),
    (7080),
    (7081),
    (7082),
    (7083),
    (7084),
    (7085),
    (7086),
    (7087),
    (7088),
    (7089),
    (7090),
    (7091),
    (7092),
    (7093),
    (7094),
    (7095),
    (7096),
    (7097),
    (7098),
    (7099),
    (7100),
    (7101),
    (7102),
    (7103),
    (7104),
    (7105),
    (7106),
    (7107),
    (7108),
    (7109),
    (7110),
    (7111),
    (7112),
    (7113),
    (7114),
    (7115),
    (7116),
    (7117),
    (7118),
    (7119),
    (7120),
    (7121),
    (7122),
    (7123),
    (7124),
    (7125),
    (7126),
    (7127),
    (7128),
    (7129),
    (7130),
    (7131),
    (7132),
    (7133),
    (7134),
    (7135),
    (7136),
    (7137),
    (7138),
    (7139),
    (7140),
    (7141),
    (7142),
    (7143),
    (7144),
    (7145),
    (7146),
    (7147),
    (7148),
    (7149),
    (7150),
    (7151),
    (7152),
    (7153),
    (7154),
    (7155),
    (7156),
    (7157),
    (7158),
    (7159),
    (7160),
    (7161),
    (7162),
    (7163),
    (7164),
    (7165),
    (7166),
    (7167),
    (7168),
    (7169),
    (7170),
    (7171),
    (7172),
    (7173),
    (7174),
    (7175),
    (7176),
    (7177),
    (7178),
    (7179),
    (7180),
    (7181),
    (7182),
    (7183),
    (7184),
    (7185),
    (7186),
    (7187),
    (7188),
    (7189),
    (7190),
    (7191),
    (7192),
    (7193),
    (7194),
    (7195),
    (7196),
    (7197),
    (7198),
    (7199),
    (7200),
    (7201),
    (7202),
    (7203),
    (7204),
    (7205),
    (7206),
    (7207),
    (7208),
    (7209),
    (7210),
    (7211),
    (7212),
    (7213),
    (7214),
    (7215),
    (7216),
    (7217),
    (7218),
    (7219),
    (7220),
    (7221),
    (7222),
    (7223),
    (7224),
    (7225),
    (7226),
    (7227),
    (7228),
    (7229),
    (7230),
    (7231),
    (7232),
    (7233),
    (7234),
    (7235),
    (7236),
    (7237),
    (7238),
    (7239),
    (7240),
    (7241),
    (7242),
    (7243),
    (7244),
    (7245),
    (7246),
    (7247),
    (7248),
    (7249),
    (7250),
    (7251),
    (7252),
    (7253),
    (7254),
    (7255),
    (7256),
    (7257),
    (7258),
    (7259),
    (7260),
    (7261),
    (7262),
    (7263),
    (7264),
    (7265),
    (7266),
    (7267),
    (7268),
    (7269),
    (7270),
    (7271),
    (7272),
    (7273),
    (7274),
    (7275),
    (7276),
    (7277),
    (7278),
    (7279),
    (7280),
    (7281),
    (7282),
    (7283),
    (7284),
    (7285),
    (7286),
    (7287),
    (7288),
    (7289),
    (7290),
    (7291),
    (7292),
    (7293),
    (7294),
    (7295),
    (7296),
    (7297),
    (7298),
    (7299),
    (7300),
    (7301),
    (7302),
    (7303),
    (7304),
    (7305),
    (7306),
    (7307),
    (7308),
    (7309),
    (7310),
    (7311),
    (7312),
    (7313),
    (7314),
    (7315),
    (7316),
    (7317),
    (7318),
    (7319),
    (7320),
    (7321),
    (7322),
    (7323),
    (7324),
    (7325),
    (7326),
    (7327),
    (7328),
    (7329),
    (7330),
    (7331),
    (7332),
    (7333),
    (7334),
    (7335),
    (7336),
    (7337),
    (7338),
    (7339),
    (7340),
    (7341),
    (7342),
    (7343),
    (7344),
    (7345),
    (7346),
    (7347),
    (7348),
    (7349),
    (7350),
    (7351),
    (7352),
    (7353),
    (7354),
    (7355),
    (7356),
    (7357),
    (7358),
    (7359),
    (7360),
    (7361),
    (7362),
    (7363),
    (7364),
    (7365),
    (7366),
    (7367),
    (7368),
    (7369),
    (7370),
    (7371),
    (7372),
    (7373),
    (7374),
    (7375),
    (7376),
    (7377),
    (7378),
    (7379),
    (7380),
    (7381),
    (7382),
    (7383),
    (7384),
    (7385),
    (7386),
    (7387),
    (7388),
    (7389),
    (7390),
    (7391),
    (7392),
    (7393),
    (7394),
    (7395),
    (7396),
    (7397),
    (7398),
    (7399),
    (7400),
    (7401),
    (7402),
    (7403),
    (7404),
    (7405),
    (7406),
    (7407),
    (7408),
    (7409),
    (7410),
    (7411),
    (7412),
    (7413),
    (7414),
    (7415),
    (7416),
    (7417),
    (7418),
    (7419),
    (7420),
    (7421),
    (7422),
    (7423),
    (7424),
    (7425),
    (7426),
    (7427),
    (7428),
    (7429),
    (7430),
    (7431),
    (7432),
    (7433),
    (7434),
    (7435),
    (7436),
    (7437),
    (7438),
    (7439),
    (7440),
    (7441),
    (7442),
    (7443),
    (7444),
    (7445),
    (7446),
    (7447),
    (7448),
    (7449),
    (7450),
    (7451),
    (7452),
    (7453),
    (7454),
    (7455),
    (7456),
    (7457),
    (7458),
    (7459),
    (7460),
    (7461),
    (7462),
    (7463),
    (7464),
    (7465),
    (7466),
    (7467),
    (7468),
    (7469),
    (7470),
    (7471),
    (7472),
    (7473),
    (7474),
    (7475),
    (7476),
    (7477),
    (7478),
    (7479),
    (7480),
    (7481),
    (7482),
    (7483),
    (7484),
    (7485),
    (7486),
    (7487),
    (7488),
    (7489),
    (7490),
    (7491),
    (7492),
    (7493),
    (7494),
    (7495),
    (7496),
    (7497),
    (7498),
    (7499),
    (7500),
    (7501),
    (7502),
    (7503),
    (7504),
    (7505),
    (7506),
    (7507),
    (7508),
    (7509),
    (7510),
    (7511),
    (7512),
    (7513),
    (7514),
    (7515),
    (7516),
    (7517),
    (7518),
    (7519),
    (7520),
    (7521),
    (7522),
    (7523),
    (7524),
    (7525),
    (7526),
    (7527),
    (7528),
    (7529),
    (7530),
    (7531),
    (7532),
    (7533),
    (7534),
    (7535),
    (7536),
    (7537),
    (7538),
    (7539),
    (7540),
    (7541),
    (7542),
    (7543),
    (7544),
    (7545),
    (7546),
    (7547),
    (7548),
    (7549),
    (7550),
    (7551),
    (7552),
    (7553),
    (7554),
    (7555),
    (7556),
    (7557),
    (7558),
    (7559),
    (7560),
    (7561),
    (7562),
    (7563),
    (7564),
    (7565),
    (7566),
    (7567),
    (7568),
    (7569),
    (7570),
    (7571),
    (7572),
    (7573),
    (7574),
    (7575),
    (7576),
    (7577),
    (7578),
    (7579),
    (7580),
    (7581),
    (7582),
    (7583),
    (7584),
    (7585),
    (7586),
    (7587),
    (7588),
    (7589),
    (7590),
    (7591),
    (7592),
    (7593),
    (7594),
    (7595),
    (7596),
    (7597),
    (7598),
    (7599),
    (7600),
    (7601),
    (7602),
    (7603),
    (7604),
    (7605),
    (7606),
    (7607),
    (7608),
    (7609),
    (7610),
    (7611),
    (7612),
    (7613),
    (7614),
    (7615),
    (7616),
    (7617),
    (7618),
    (7619),
    (7620),
    (7621),
    (7622),
    (7623),
    (7624),
    (7625),
    (7626),
    (7627),
    (7628),
    (7629),
    (7630),
    (7631),
    (7632),
    (7633),
    (7634),
    (7635),
    (7636),
    (7637),
    (7638),
    (7639),
    (7640),
    (7641),
    (7642),
    (7643),
    (7644),
    (7645),
    (7646),
    (7647),
    (7648),
    (7649),
    (7650),
    (7651),
    (7652),
    (7653),
    (7654),
    (7655),
    (7656),
    (7657),
    (7658),
    (7659),
    (7660),
    (7661),
    (7662),
    (7663),
    (7664),
    (7665),
    (7666),
    (7667),
    (7668),
    (7669),
    (7670),
    (7671),
    (7672),
    (7673),
    (7674),
    (7675),
    (7676),
    (7677),
    (7678),
    (7679),
    (7680),
    (7681),
    (7682),
    (7683),
    (7684),
    (7685),
    (7686),
    (7687),
    (7688),
    (7689),
    (7690),
    (7691),
    (7692),
    (7693),
    (7694),
    (7695),
    (7696),
    (7697),
    (7698),
    (7699),
    (7700),
    (7701),
    (7702),
    (7703),
    (7704),
    (7705),
    (7706),
    (7707),
    (7708),
    (7709),
    (7710),
    (7711),
    (7712),
    (7713),
    (7714),
    (7715),
    (7716),
    (7717),
    (7718),
    (7719),
    (7720),
    (7721),
    (7722),
    (7723),
    (7724),
    (7725),
    (7726),
    (7727),
    (7728),
    (7729),
    (7730),
    (7731),
    (7732),
    (7733),
    (7734),
    (7735),
    (7736),
    (7737),
    (7738),
    (7739),
    (7740),
    (7741),
    (7742),
    (7743),
    (7744),
    (7745),
    (7746),
    (7747),
    (7748),
    (7749),
    (7750),
    (7751),
    (7752),
    (7753),
    (7754),
    (7755),
    (7756),
    (7757),
    (7758),
    (7759),
    (7760),
    (7761),
    (7762),
    (7763),
    (7764),
    (7765),
    (7766),
    (7767),
    (7768),
    (7769),
    (7770),
    (7771),
    (7772),
    (7773),
    (7774),
    (7775),
    (7776),
    (7777),
    (7778),
    (7779),
    (7780),
    (7781),
    (7782),
    (7783),
    (7784),
    (7785),
    (7786),
    (7787),
    (7788),
    (7789),
    (7790),
    (7791),
    (7792),
    (7793),
    (7794),
    (7795),
    (7796),
    (7797),
    (7798),
    (7799),
    (7800),
    (7801),
    (7802),
    (7803),
    (7804),
    (7805),
    (7806),
    (7807),
    (7808),
    (7809),
    (7810),
    (7811),
    (7812),
    (7813),
    (7814),
    (7815),
    (7816),
    (7817),
    (7818),
    (7819),
    (7820),
    (7821),
    (7822),
    (7823),
    (7824),
    (7825),
    (7826),
    (7827),
    (7828),
    (7829),
    (7830),
    (7831),
    (7832),
    (7833),
    (7834),
    (7835),
    (7836),
    (7837),
    (7838),
    (7839),
    (7840),
    (7841),
    (7842),
    (7843),
    (7844),
    (7845),
    (7846),
    (7847),
    (7848),
    (7849),
    (7850),
    (7851),
    (7852),
    (7853),
    (7854),
    (7855),
    (7856),
    (7857),
    (7858),
    (7859),
    (7860),
    (7861),
    (7862),
    (7863),
    (7864),
    (7865),
    (7866),
    (7867),
    (7868),
    (7869),
    (7870),
    (7871),
    (7872),
    (7873),
    (7874),
    (7875)
  ) 
insert into tbl_biblio_temp(biblio_id, bugs_reference)
select distinct biblio_id, bugs_reference
  from biblio_ids as x
  join tbl_biblio using (biblio_id)
where bugs_reference is not null;
   
update public.tbl_biblio_temp set year= 1986 where biblio_id= 468;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 492;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 526;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 566;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 574;
update public.tbl_biblio_temp set year= 1960 where biblio_id= 609;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 633;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 652;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 411;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 692;
update public.tbl_biblio_temp set year= 2003, url= 'http://www.wessexarch.co.uk/files/projects/charter_quay/Environmental/insects.pdf' where biblio_id= 694;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 737;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 1334;
update public.tbl_biblio_temp set year= 1945 where biblio_id= 2461;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 2490;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 2846;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 2985;
update public.tbl_biblio_temp set year= 1962 where biblio_id= 3205;
update public.tbl_biblio_temp set year= 1919 where biblio_id= 4252;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 5268;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 5453;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 704;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 713;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 735;
update public.tbl_biblio_temp set year= 1931 where biblio_id= 793;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 799;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 806;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 815;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 849;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 865;
update public.tbl_biblio_temp set year= 1972 where biblio_id= 880;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 898;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 917;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 922;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 930;
update public.tbl_biblio_temp set year= 1940 where biblio_id= 939;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 945;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 974;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 994;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 999;
update public.tbl_biblio_temp set year= 1922 where biblio_id= 1002;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 1014;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 1022;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 1025;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 1029;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1030;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 1039;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 1048;
update public.tbl_biblio_temp set year= 1892 where biblio_id= 1121;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 1877;
update public.tbl_biblio_temp set year= 1849 where biblio_id= 1135;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 1155;
update public.tbl_biblio_temp set year= 2006, url='http://www.coleopterist.org.uk/latridiidae-list.htmll' where biblio_id= 1167;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 1204;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 1232;
update public.tbl_biblio_temp set year= 1948 where biblio_id= 1282;
update public.tbl_biblio_temp set year= 2003, url='http://www.bugs2000.org/' where biblio_id= 1299;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 1319;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1324;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 1351;
update public.tbl_biblio_temp set year= 1957 where biblio_id= 1433;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 1439;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 1447;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 1880;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 1363;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 1387;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 1415;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 1588;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1637;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 1492;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 1506;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1670;
update public.tbl_biblio_temp set year= 1937 where biblio_id= 1675;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 1734;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 1753;
update public.tbl_biblio_temp set year= 1945 where biblio_id= 1467;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 1483;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 1524;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 1537;
update public.tbl_biblio_temp set year= 1959 where biblio_id= 1760;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1791;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 1801;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1806;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1855;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 1858;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 1888;
update public.tbl_biblio_temp set year= 1981 where biblio_id= 1907;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 1933;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 1947;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 1961;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 1982;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 2044;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 2057;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 7860;
update public.tbl_biblio_temp set year= 1953 where biblio_id= 2217;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 2258;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 2266;
update public.tbl_biblio_temp set year= 1958 where biblio_id= 2271;
update public.tbl_biblio_temp set year= 1931 where biblio_id= 2294;
update public.tbl_biblio_temp set year= 1961 where biblio_id= 2297;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 2362;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 2588;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 2152;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 2180;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 2405;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 2446;
update public.tbl_biblio_temp set year= 1960 where biblio_id= 2470;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 2501;
update public.tbl_biblio_temp set year= 1963 where biblio_id= 2514;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 2544;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 2563;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 2586;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 2603;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 2605;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 2779;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 2658;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 2699;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 2710;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 2743;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 2756;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 2767;
update public.tbl_biblio_temp set year= 1961 where biblio_id= 2776;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 2837;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 2841;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 2958;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7861;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 3025;
update public.tbl_biblio_temp set year= 1945 where biblio_id= 3055;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 3097;
update public.tbl_biblio_temp set year= 1950 where biblio_id= 3179;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 3217;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 3248;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 3261;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 3281;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 3297;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 3375;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 3377;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 3405;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 3050;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7862;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 3466;
update public.tbl_biblio_temp set year= 1960 where biblio_id= 3503;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 3526;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 3543;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 3559;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 3580;
update public.tbl_biblio_temp set year= 1961 where biblio_id= 3599;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 3665;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 3682;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 3694;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 3707;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 3902;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 3926;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 3938;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 3941;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 3965;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 4147;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 4279;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 4292;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 4309;
update public.tbl_biblio_temp set year= 1960 where biblio_id= 4444;
update public.tbl_biblio_temp set notes='in lecture' where biblio_id= 4448;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 4476;
update public.tbl_biblio_temp set year= 1931 where biblio_id= 4552;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 4560;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 4568;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 4659;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 4678;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 4725;
update public.tbl_biblio_temp set year= 1957 where biblio_id= 4734;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 4791;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 4802;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 4843;
update public.tbl_biblio_temp set year= 1959 where biblio_id= 4872;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 4881;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 4885;
update public.tbl_biblio_temp set year='1827-35' where biblio_id= 5036;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 5055;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 5063;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 5136;
update public.tbl_biblio_temp set year= 1954 where biblio_id= 5203;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 5209;
update public.tbl_biblio_temp set year= 1839 where biblio_id= 5333;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 5458;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 5471;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 7863;
update public.tbl_biblio_temp set notes='pers. comm.', year= 2010 where biblio_id= 836;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 1426;
update public.tbl_biblio_temp set year= 2012, authors=NULL, url='http://www.faunaitalia.it/checklist/' where biblio_id= 2326;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 2381;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 3293;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 3327;
update public.tbl_biblio_temp set notes='pers. com.', title='pers. com.', year=NULL where biblio_id= 491;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7864;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7865;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 7866;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 577;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7867;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 628;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 630;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 643;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 674;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7754;
update public.tbl_biblio_temp set title='The occurrence in Britain of Ocalea concolor Kies. (Col., Staphylinidae)', authors='Entomologist''s Monthly Magazine, 124, 252.', year= 1988 where biblio_id= 687;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 7755;
update public.tbl_biblio_temp set url='http://www.doeni.gov.uk/niea/carabid.pdf' where biblio_id= 749;
update public.tbl_biblio_temp set doi='doi:10.1155/2012/321084', title='Declining Bark Beetle Densities (Ips typographus, Coleoptera: Scolytinae) from Infested Norway Spruce Stands and Possible Implications for Management. Psyche.' where biblio_id= 801;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 839;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 7756;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7757;
update public.tbl_biblio_temp set url='http://www.coleopterist.org.uk/tenebrionidae-list-htm' where biblio_id= 964;
update public.tbl_biblio_temp set url='http://www.coleopterist.org.uk/melandryidae-list.html' where biblio_id= 1178;
update public.tbl_biblio_temp set url='http://dx.doi.org/10.3402/polar.v31i0.18367', full_reference='Booth, R. (2006) Checklist of beetles of the British Isles, Melandryidae.' where biblio_id= 1131;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Bothrideridae. <http://www.coleopterist.org.uk/bothrideridae-list.html>.', url='http://www.coleopterist.org.uk/bothrideridae-list.html' where biblio_id= 1181;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles. Laemophloeidae. <www.coleopterist.org.uk/laemophloeidae-list.html>' , url='www.coleopterist.org.uk/laemophloeidae-list.html' where biblio_id= 1165;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Silvanidae. <http://www.coleopterist.org.uk/silvanidae-list.html>.', url='http://www.coleopterist.org.uk/silvanidae-list.html' where biblio_id= 1166;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Coccinellidae. <http://www.coleopterist.org.uk/coccinellidae-list.html>.', url='http://www.coleopterist.org.uk/coccinellidae-list.htmll' where biblio_id= 1169;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Kateretidae. <http://www.coleopterist.org.uk/kateretidae-list.html>.', url='http://www.coleopterist.org.uk/kateretidae-list.html' where biblio_id= 1171;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Phalacridae. <http://www.coleopterist.org.uk/phalacridae-list.html>.', url='http://www.coleopterist.org.uk/phalacridae-list.html' where biblio_id= 1174;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Erotylidae. <http://www.coleopterist.org.uk/erotylidae-list.html>.', url='http://www.coleopterist.org.uk/erotylidae-list.html' where biblio_id= 1176;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Byturidae. <http://www.coleopterist.org.uk/byturidae-list.html>.', url='http://www.coleopterist.org.uk/byturidae-list.html' where biblio_id= 1179;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Biphyllidae. <http://www.coleopterist.org.uk/biphyllidae-list.html>.', url='http://www.coleopterist.org.uk/biphyllidae-list.html' where biblio_id= 1180;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Sphindidae. <http://www.coleopterist.org.uk/sphindidae-list.html>.', url='http://www.coleopterist.org.uk/sphindidae-list.html' where biblio_id= 1183;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Corylophidae. <http://www.coleopterist.org.uk/corylophidae-list.html>.', url='http://www.coleopterist.org.uk/corylophidae-list.html' where biblio_id= 1185;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Mycteridae. <http://www.coleopterist.org.uk/mycteridae-list.html>.', url='http://www.coleopterist.org.uk/mycteridae-list.html' where biblio_id= 1187;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7868;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7869;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 1273;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 1330;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 1332;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 1355;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 1472;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 6674;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 1508;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 1535;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7758;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 1615;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 1968;
update public.tbl_biblio_temp set year= 1962 where biblio_id= 1744;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7759;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Leiodidae. <http://www.coleopterist.org.uk/leiodidae-list.html>', url='http://www.coleopterist.org.uk/leiodidae-list.html' where biblio_id= 1836;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles. Chrysomelidae. <www.coleopterist.org.uk/chrysomelidae-list.html>', url='http://www.coleopterist.org.uk/chrysomelidae-list.html' where biblio_id= 1859;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 1866;
update public.tbl_biblio_temp set notes='pers. comm.', title='pers. comm. 6.2008', year= 2008 where biblio_id= 2306;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7760;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 2139;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7761;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7762;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Lycidae. <www.coleopterist.org.uk/lycidae-list.html>', url='www.coleopterist.org.uk/lycidae-list.html' where biblio_id= 2190;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Scirtidae. <www.coleopterist.org.uk/scirtidae-list.html>', url='www.coleopterist.org.uk/scirtidae-list.html' where biblio_id= 2192;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Histeridae. <www.coleopterist.org.uk/histeridae-list.html>', url='www.coleopterist.org.uk/histeridae-list.html' where biblio_id= 2193;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Hydrophilidae. <http://www.coleopterist.org.uk/hydrophilidae-list.html>.', url='http://www.coleopterist.org.uk/hydrophilidae-list.html' where biblio_id= 2195;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Georissidae. <http://www.coleopterist.org.uk/georissidae-list.html>.', url='http://www.coleopterist.org.uk/georissidae-list.html' where biblio_id= 2197;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Tetratomidae. <www.coleopterist.org.uk/tetratomidae-list.html>', url='www.coleopterist.org.uk/tetratomidae-list.html' where biblio_id= 2199;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Dytiscidae. <http://www.coleopterist.org.uk/dytiscidae-list.html>', url='http://www.coleopterist.org.uk/dytiscidae-list.html' where biblio_id= 2200;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Silphidae. <http://www.coleopterist.org.uk/silphidae-list.html>', url='http://www.coleopterist.org.uk/silphidae-list.html' where biblio_id= 2204;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Dryopidae. <http://www.coleopterist.org.uk/dryopidae-list.html>.', url='http://www.coleopterist.org.uk/dryopidae-list.html' where biblio_id= 2206;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Bostrichidae. <http://www.coleopterist.org.uk/bostrichidae-list.html>', url='http://www.coleopterist.org.uk/bostrichidae-list.html' where biblio_id= 2208;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Cleridae. <http://www.coleopterist.org.uk/cleridae-list.html>', url='http://www.coleopterist.org.uk/cleridae-list.html' where biblio_id= 2209;
update public.tbl_biblio_temp set url='http://www.emg.umu.se/biginst/andersn/CPD_061112.pdf' where biblio_id= 4241;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Clambidae. <www.coleopterist.org.uk/clambidae-list.html>', url='http://www.coleopterist.org.uk/clambidae-list.html' where biblio_id= 3283;
update public.tbl_biblio_temp set url='http://www.funet.fi/pub/sci/bio/life/insecta/diptera' where biblio_id= 3351;
update public.tbl_biblio_temp set url='http://www.bwars.com' where biblio_id= 7766;
update public.tbl_biblio_temp set doi='doi:10.1155/2012/387564' where biblio_id= 3708;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Mordellidae. <http://www.coleopterist.org.uk/mordellidae-list.html>.', url='http://www.coleopterist.org.uk/mordellidae-list.html' where biblio_id= 3726;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Buprestidae. <http://www.coleopterist.org.uk/buprestidae-list.html>.', url='http://www.coleopterist.org.uk/buprestidae-list.html' where biblio_id= 3729;
update public.tbl_biblio_temp set url='http://www.coleopterist.org.uk' where biblio_id= 3815;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Scarabaeidae. <www.coleopterist.org.uk/scarabaeidae-list.html>', url='http://www.coleopterist.org.uk/scarabaeidae-list.html' where biblio_id= 3956;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Trogidae. <www.coleopterist.org.uk/trogidae-list.html>', url='http://www.coleopterist.org.uk/trogidae-list.html' where biblio_id= 3957;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Lucanidae. <www.coleopterist.org.uk/lucanidae-list.html>', url='http://www.coleopterist.org.uk/lucanidae-list.html' where biblio_id= 3959;
update public.tbl_biblio_temp set url='http://www.ynu.org.uk' where biblio_id= 3969;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Throscidae. <http://www.coleopterist.org.uk/throscidae-list.html>.', url='http://www.coleopterist.org.uk/throscidae-list.html' where biblio_id= 4046;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Anthribidae. <http://www.coleopterist.org.uk/anthribidae-list.html>.', url='http://www.coleopterist.org.uk/anthribidae-list.html' where biblio_id= 4126;
update public.tbl_biblio_temp set title='Checklist of the beetles of the British Isles, Erirhinidae. <http://www.coleopterist.org.uk/erirhinidae-list.html>', url='http://www.coleopterist.org.uk/erirhinidae-list.html' where biblio_id= 4128;
update public.tbl_biblio_temp set url='http://www.emg.umu.se/biginst/andersn/CPD_061112.pdf' where biblio_id= 4241;
update public.tbl_biblio_temp set url='http://www.brc.ac.uk/downloads/RA77_Carabidae/GBRS%20Notes%20for%20recorders%20and%20RA77%20instructions.doc' where biblio_id= 5102;
update public.tbl_biblio_temp set url='http://www.fugleognatur/speciesintro.asp' where biblio_id= 5467;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Cantharidae. <www.coleopterist.org.uk/cantharidae-list.html>', url='www.coleopterist.org.uk/cantharidae-list.html' where biblio_id= 536;
update public.tbl_biblio_temp set url='http://www.habitas.org.uk/groundbeetles/index.html' where biblio_id= 784;
update public.tbl_biblio_temp set title='http://www.coleo-net.de/coleo/texte/trox.html', url='Lompe, A. http://www.coleo-net.de/coleo/texte/trox.html' where biblio_id= 7294;
update public.tbl_biblio_temp set title='Corixa iberica in Scotland and Spain. HetNews, 7, 4-9. http://www.hetnews.org.uk/pdfs/Issue%207_Spring%202006_853Kb.pdf', url='http://www.hetnews.org.uk/pdfs/Issue%207_Spring%202006_853Kb.pdf' where biblio_id= 832;
update public.tbl_biblio_temp set title='Carabidae of the World. http//www.carabidae.org. (updated 2.2015)', url='http//www.carabidae.org' where biblio_id= 6757;
update public.tbl_biblio_temp set url='http://artfakta.artdatabanken.se/taxon/' where biblio_id= 6762;
update public.tbl_biblio_temp set title='Gattung Soronia Erichson. <http://www.coleo-net.de/coleo/texte/soronia.html>', url='http://www.coleo-net.de/coleo/texte/soronia.html' where biblio_id= 7295;
update public.tbl_biblio_temp set title='Staphylinidae : liste alphabÃ©tique des photos. <http://r.a.r.e.free.fr/interactif/photos%20staphylinidae/index.html>', url='http://r.a.r.e.free.fr/interactif/photos%20staphylinidae/index.html' where biblio_id= 4269;
update public.tbl_biblio_temp set title='British bugs. An online identification guide to UK Hemiptera. http://www.britishbugs.org.uk/index.htmll', url='http://www.britishbugs.org.uk/index.htmll' where biblio_id= 6776;
update public.tbl_biblio_temp set url='http://www.cerambycidae.org' where biblio_id= 6792;
update public.tbl_biblio_temp set url='http://www.coleoptera.org.uk/home' where biblio_id= 6800;
update public.tbl_biblio_temp set url='http://www.kerbtier.de/enindex.htmll' where biblio_id= 6802;
update public.tbl_biblio_temp set title='Atlas of beetles of Russia (a project dedicated to the 100th anniversary of G.G. Jacobson''s book ''Beetles of Russia''). www.zin.ru/Animalia/Coleoptera/eng/', url='http://www.zin.ru/Animalia/Coleoptera/eng' where biblio_id= 6809;
update public.tbl_biblio_temp set url='http://www.biolib.cz/en/main/' where biblio_id= 6818;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Endomycidae. <http://www.coleopterist.org.uk/endomycidae-list.html>.', url='http://www.coleopterist.org.uk/endomycidae-list.html' where biblio_id= 1170;
update public.tbl_biblio_temp set url='http://www.boldsystems.org/index.php/' where biblio_id= 6829;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Meloidae. <http://www.coleopterist.org.uk/meloidae-list.html>.', url='http://www.coleopterist.org.uk/meloidae-list.html' where biblio_id= 1163;
update public.tbl_biblio_temp set title='Checklist of the beetles of the British Isles, Byrrhidae. <http://www.coleopterist.org.uk/byrrhidae-list.html>', url='http://www.coleopterist.org.uk/byrrhidae-list.html' where biblio_id= 1168;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Nitidulidae. <http://www.coleopterist.org.uk/nitidulidae-list.html>.', url='http://www.coleopterist.org.uk/nitidulidae-list.html' where biblio_id= 1172;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Monotomidae. <http://www.coleopterist.org.uk/monotomidae-list.html>.', url='http://www.coleopterist.org.uk/monotomidae-list.html' where biblio_id= 1173;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Melyridae. <http://www.coleopterist.org.uk/melyridae-list.html>.', url='http://www.coleopterist.org.uk/melyridae-list.html' where biblio_id= 1175;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Mycetophagidae. <http://www.coleopterist.org.uk/mycetophagidae-list.html>.', url='http://www.coleopterist.org.uk/mycetophagidae-list.html' where biblio_id= 1177;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Trogossitidae. <http://www.coleopterist.org.uk/trogossitidae-list.html>', url='http://www.coleopterist.org.uk/trogossitidae-list.html' where biblio_id= 1182;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Alexiidae. <http://www.coleopterist.org.uk/alexiidae-list.html>.', url='http://www.coleopterist.org.uk/alexiidae-list.html' where biblio_id= 1184;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Oedemeridae. <http://www.coleopterist.org.uk/oedemeridae-list.html>.', url='http://www.coleopterist.org.uk/oedemeridae-list.html' where biblio_id= 1186;
update public.tbl_biblio_temp set title='Iconographia Coleopterorum Poloniae. <http://www.colpolon.biol.uni.wroc.pl/index.html> (Update 25 1 15)', url='http://www.colpolon.biol.uni.wroc.pl/index.html' where biblio_id= 6834;
update public.tbl_biblio_temp set url='http://www.hetnews.org.uk/pdfs/Issue%207_Spring%202006_853Kb.pdf' where biblio_id= 1269;
update public.tbl_biblio_temp set url='http://archaeologydataservice.ac.uk/catalogue/adsdata/arch-989-1/dissemination/pdf/networka2-54133_1.pdf' where biblio_id= 1329;
update public.tbl_biblio_temp set url='http://www.bwars.com/' where biblio_id= 6874;
update public.tbl_biblio_temp set url='http://www.zin.ru/animalia/coleoptera/eng/index.htmll' where biblio_id= 6912;
update public.tbl_biblio_temp set url='http://www.coleoptera.org.uk/' where biblio_id= 6913;
update public.tbl_biblio_temp set url='http://apions.blogspot.co.uk/' where biblio_id= 6920;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles. Orsodacnidae. <www.coleopterist.org.uk/orsodacnidae-list.html>', url='www.coleopterist.org.uk/orsodacnidae-list.html' where biblio_id= 1860;
update public.tbl_biblio_temp set title='Notes sur les Elmidae. <http://www.insecte.org/forum/viewtopic.php?t=102852>', url='http://www.insecte.org/forum/viewtopic.php?t=102852' where biblio_id= 6942;
update public.tbl_biblio_temp set title='Danmarks Fugle og Natur (2009) <http://www.fugleognatur.dk>', url='http://www.fugleognatur.dk' where biblio_id= 6944;
update public.tbl_biblio_temp set url='http://www.dipteristsforum.org.uk/documents/BRITISH_ISLES_CHECKLIST.pdf' where biblio_id= 6960;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Anobiidae. <www.coleopterist.org.uk/anobiidae-list.html>', url='http://www.coleopterist.org.uk/anobiidae-list.html' where biblio_id= 2191;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Hydraenidae. <http://www.coleopterist.org.uk/hydraenidae-list.html>.', url='http://www.coleopterist.org.uk/hydraenidae-list.html' where biblio_id= 2194;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Noteridae. <http://www.coleopterist.org.uk/noteridae-list.html>.', url='http://www.coleopterist.org.uk/noteridae-list.html' where biblio_id= 2196;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Helophoridae. http://www.coleopterist.org.uk/helophoridae-list.html>.', url='http://www.coleopterist.org.uk/helophoridae-list.html' where biblio_id= 2198;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Cryptophagidae. <http://www.coleopterist.org.uk/cryptophagidae-list.html>.', url='http://www.coleopterist.org.uk/cryptophagidae-list.html' where biblio_id= 2201;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Scydmaenidae. <http://www.coleopterist.org.uk/scydmaenidae-list.html>.', url='http://www.coleopterist.org.uk/scydmaenidae-list.html' where biblio_id= 2202;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Pelobiidae. <http://www.coleopterist.org.uk/pelobiidae-list.html>', url='http://www.coleopterist.org.uk/pelobiidae-list.html' where biblio_id= 2203;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Elmidae. <http://www.coleopterist.org.uk/elmidae-list.html>.', url='http://www.coleopterist.org.uk/elmidae-list.html' where biblio_id= 2205;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Heteroceridae. <http://www.coleopterist.org.uk/heteroceridae-list.html>.', url='http://www.coleopterist.org.uk/heteroceridae-list.html' where biblio_id= 2207;
update public.tbl_biblio_temp set title='Checklist of the Beetles of the British Isles, Cerylonidae. <http://www.coleopterist.org.uk/cerylonidae-list.html>', url='http://www.coleopterist.org.uk/cerylonidae-list.html' where biblio_id= 2210;
update public.tbl_biblio_temp set url='http://www.biol.uni.wroc.pl/cassidae/European Chrysomelidae/' where biblio_id= 7003;
update public.tbl_biblio_temp set url='http://sxbrc.org.uk/publications/East_Sussex_Bees_Wasps_Survey_Falk_2011.pdf' where biblio_id= 2323;
update public.tbl_biblio_temp set url='http://www.cerambyx.uochb.cz/index.php' where biblio_id= 7153;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles: Ptiliidae. <www.coleopterist.org/ptiliidae-list.html>.', url='http://www.coleopterist.org/ptiliidae-list.html' where biblio_id= 3282;
update public.tbl_biblio_temp set url='http://www.britarch.ac.uk/ sair/sair1.htmll' where biblio_id= 3435;
update public.tbl_biblio_temp set doi='DOI: 10.1111/j.1439-0418.2010.01520.x' where biblio_id= 1488;
update public.tbl_biblio_temp set doi='DOI: 10.1080/14732971.2017.1384608' where biblio_id= 7236;
update public.tbl_biblio_temp set url='http://www.meloidae.com/en/' where biblio_id= 7237;
update public.tbl_biblio_temp set url='http://www.coleo-net.de/coleo/texte/nebria.html' where biblio_id= 7292;
update public.tbl_biblio_temp set url='http://www.coleo-net.de/coleo/texte/polyphylla.html' where biblio_id= 7293;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Scraptiidae. <http://www.coleopterist.org.uk/scraptiidae-list.html>.', url='http://www.coleopterist.org.uk/scraptiidae-list.html' where biblio_id= 3727;
update public.tbl_biblio_temp set url='http://www.commanster.eu/commanster.htmll' where biblio_id= 7273;
update public.tbl_biblio_temp set url='http://www.linnea.it/' where biblio_id= 7275;
update public.tbl_biblio_temp set title='http://www.coleo-net.de/coleo/texte/hypocaccus.html', url='http://www.coleo-net.de/coleo/texte/hypocaccus.html' where biblio_id= 7291;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Carabidae. <www.coleopterist.org.uk/carabidae-list.html>', url='www.coleopterist.org.uk/carabidae-list.html' where biblio_id= 3875;
update public.tbl_biblio_temp set url='http://www.zin.ru/animalia/coleoptera/eng' where biblio_id= 7323;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Bolboceratidae. <http://www.coleopterist.org.uk/bolboceratidae-list.html>', url='http://www.coleopterist.org.uk/bolboceratidae-list.html' where biblio_id= 3958;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Apionidae. <http://www.coleopterist.org.uk/apionidae-list.html>', url='http://www.coleopterist.org.uk/apionidae-list.html' where biblio_id= 4123;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Eucnemidae. <http://www.coleopterist.org.uk/eucnemidae-list.html>', url='http://www.coleopterist.org.uk/eucnemidae-list.html' where biblio_id= 4045;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Elateridae. <http://www.coleopterist.org.uk/elateridae-list.html>', url='http://www.coleopterist.org.uk/elateridae-list.html' where biblio_id= 4047;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Curculionidae. <http://www.coleopterist.org.uk/curculionidae-list.html>', url='http:/www.coleopterist.org.uk/curculionidae-list.html' where biblio_id= 4120;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Dryophthoridae. <http:/www.coleopterist.org.uk/dryophthoridae-list.html>', url='http:/www.coleopterist.org.uk/dryophthoridae-list.html' where biblio_id= 4121;
update public.tbl_biblio_temp set title='Checklist of the beetles of the British Isles, Nanophyidae. <http://www.coleopterist.org.uk/nanophyidae-list.html>', url='http://www.coleopterist.org.uk/nanophyidae-list.html' where biblio_id= 4122;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Rhynchitidae. <http://www.coleopterist.org.uk/rhynchitidae-list.html>', url='http://www.coleopterist.org.uk/rhynchitidae-list.html' where biblio_id= 4124;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles, Nemonychidae. <http://www.coleopterist.org.uk/nemonychidae-list.html>', url='http://www.coleopterist.org.uk/nemonychidae-list.html' where biblio_id= 4125;
update public.tbl_biblio_temp set title='Checklist of the beetles of the British Isles, Raymondionymidae. <http://www.coleopterist.org.uk/raymondionmidae-list.html>', url='http://www.coleopterist.org.uk/raymondionmidae-list.html' where biblio_id= 4127;
update public.tbl_biblio_temp set url='http://inpn.mnhn.fr' where biblio_id= 7399;
update public.tbl_biblio_temp set doi='DOI: 10.1016/j.palaeo.2009.07.013' where biblio_id= 4293;
update public.tbl_biblio_temp set title='Cryptocephalus coryli at Sherwood Forest NNR. http://www.eakringbirds.com/eakringbirds6/cryptocephaluscoryli.html', url='http://www.eakringbirds.com/eakringbirds6/cryptocephaluscoryli.html' where biblio_id= 7451;
update public.tbl_biblio_temp set url='http://www.eakringbirds.com' where biblio_id= 7452;
update public.tbl_biblio_temp set url='https://www.researchgate.net/publication/281974239_A_desk_review_of_the_ecology_of_Heather_Beetle' where biblio_id= 7466;
update public.tbl_biblio_temp set url='http://dx.doi.org/10.1016/j.palaeo.2016.10.037' where biblio_id= 7477;
update public.tbl_biblio_temp set title='The mid-Holocene Ulmus decline: a new way to evaluate the pathogen hypothesis. Poster @ <http://www.geus.dk/departments/environ-hist-climate/posters/rasmussen97-uk.html> Geological Survey of Denmark and Greenland.', url='http://www.geus.dk/departments/environ-hist-climate/posters/rasmussen97-uk.html' where biblio_id= 4594;
update public.tbl_biblio_temp set title='Checklist of beetles of the British Isles. Cerambycidae. <www.coleopterist.org.uk/cerambycidae-list.html>', url='www.coleopterist.org.uk/cerambycidae-list.html' where biblio_id= 4658;
update public.tbl_biblio_temp set title='Insect remains. In, A Romano-British rural site at Eaton Socon, Cambridgeshire.', url='http://www.scribd.com/doc/6426034/Eaton-Socon-Insect-remains-by-Mark-Robinson' where biblio_id= 4691;
update public.tbl_biblio_temp set url='http://ads.ahds.ac.uk/catalogue/adsdata/arch-876-1/dissemination/pdf/FINAL_REPORT_WAM_EDIT_July_2008.pdf', full_reference='Robinson, M. (2008) Insect and mollusc remains. In, K. Powell, G. Laws & L. Brown,  Publication Report for Wiltshire Archaeological & Natural History Magazine, A Late Neolithic / Early Bronze Age Eenclosure and Iron Age and Romano-British Settlement at Latton Lands, Wiltshire.' where biblio_id= 4701;
update public.tbl_biblio_temp set doi='DOI: http://dx.doi.org/10.11141/ia.40.1.robinson' where biblio_id= 7528;
update public.tbl_biblio_temp set url='http://www.entomologiitaliani.net/public/forum/phpBB3/viewtopic.php?f=243&t=813' where biblio_id= 7532;
update public.tbl_biblio_temp set title='Kaefer der Welt - Beetles of the World.  <https://www.kaefer-der-welt.de/index.html>', url='https://www.kaefer-der-welt.de/index.html' where biblio_id= 7569;
update public.tbl_biblio_temp set title='Beetles of Russia. Silvanidae. http://www.zin.ru/Animalia/Coleoptera/eng/msmirnov.html', url='http://www.zin.ru/Animalia/Coleoptera/eng/msmirnov.html' where biblio_id= 7594;
update public.tbl_biblio_temp set url='http://www.brc.ac.uk/downloads/RA77_Carabidae/GBRS%20Notes%20for%20recorders%20and%20RA77%20instructions.doc' where biblio_id= 7631;
update public.tbl_biblio_temp set title='Biosystematic Database of World Diptera, Version [number of version]. http://www.diptera.org/biosys.html (accessed on 4.8.2007)', url='http://www.diptera.org/biosys.html' where biblio_id= 5149;
update public.tbl_biblio_temp set doi='DOI: 10.1111/j.1439-0418.2010.01542.x', title='Identification of potential natural enemies of the pea leaf weevil, Sitona lineatus L. in western Canada. Journal of Applied Entomology, 138' where biblio_id= 5220;
update public.tbl_biblio_temp set url='http://delta-intkey.com' where biblio_id= 5241;
update public.tbl_biblio_temp set doi='DOI: http://dx.doi.org/10.2305/IUCN.UK.2016-1.RLTS.T47943568A87496163.en', url='http://dx.doi.org/10.2305/IUCN.UK.2016-1.RLTS.T47943568A87496163.en' where biblio_id= 7699;
update public.tbl_biblio_temp set notes='https://commons.wikimedia.org/wiki/ File:', authors=NULL, url='https://commons.wikimedia.org/wiki/' where biblio_id= 7712;
update public.tbl_biblio_temp set url='http://upload.wikimedia.org/wikipedia/commons/7/72/Grynobius_planus_up.jpg' where biblio_id= 7713;
update public.tbl_biblio_temp set url='http://www.insects.fi/insectimages/browser?order=COL&family=Anobiidae&genus=Hadrobregmus&species=confusus' where biblio_id= 7729;
update public.tbl_biblio_temp set url='http://www.vmpcse.cz' where biblio_id= 7730;
update public.tbl_biblio_temp set url='http://www.cerambyx.uochb.cz' where biblio_id= 7796;
update public.tbl_biblio_temp set url='http://entweb.clemson.edu/database/trichopt/index.html' where biblio_id= 7821;
update public.tbl_biblio_temp set url='http://www.markgtelfer.co.uk/www.markgtelfer.co.uk Carpelimus-incongruus-and-zealandicus' where biblio_id= 7847;
update public.tbl_biblio_temp set doi='DOI: 10.1002/jqs.3135' where biblio_id= 7875;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 2238;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 2278;
update public.tbl_biblio_temp set url='http://www.faunaeur.org' where biblio_id= 2325;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7763;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7764;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7785;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 2622;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7786;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 7787;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 2655;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 6957;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7160;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 2894;
update public.tbl_biblio_temp set year= 1952 where biblio_id= 2964;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7788;
update public.tbl_biblio_temp set year= 1840 where biblio_id= 3047;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 3118;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 3241;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 3259;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 3294;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 3302;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 7789;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7765;
update public.tbl_biblio_temp set year= 1948 where biblio_id= 3366;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7766;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 3395;
update public.tbl_biblio_temp set year= 1934 where biblio_id= 7767;
update public.tbl_biblio_temp set year= 1955 where biblio_id= 3473;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7768;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7769;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 7770;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 7771;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 3629;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7772;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 3699;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7773;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7774;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7790;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 3901;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 3907;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 3909;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 4285;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 3971;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 4041;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 4069;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7372;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7737;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7775;
update public.tbl_biblio_temp set year= 1910 where biblio_id= 7776;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7738;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 4277;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 4318;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 4336;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7739;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 4371;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7777;
update public.tbl_biblio_temp set year= 1933 where biblio_id= 7791;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7740;
update public.tbl_biblio_temp set year= 1911 where biblio_id= 4655;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7741;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 4703;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7742;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 7743;
update public.tbl_biblio_temp set year= 1898 where biblio_id= 7792;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 4804;
update public.tbl_biblio_temp set year= 1972 where biblio_id= 7744;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 4869;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 7793;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 4966;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7794;
update public.tbl_biblio_temp set year= 1943 where biblio_id= 4993;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 4999;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7795;
update public.tbl_biblio_temp set year= 'No date' where biblio_id= 5043;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7849;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7850;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7851;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7852;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 5233;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7778;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 7779;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 5448;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 5454;
update public.tbl_biblio_temp set year= 'unpubl.' where biblio_id= 5504;
update public.tbl_biblio_temp set year= 1886 where biblio_id= 5520;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7780;
update public.tbl_biblio_temp set year= 1934 where biblio_id= 5551;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7781;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 5576;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 6350;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 7782;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7783;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 6444;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7853;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 7854;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7855;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7784;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 7856;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7857;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6673;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 458;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6675;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6676;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6677;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 6678;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 6679;
update public.tbl_biblio_temp set year= 1944 where biblio_id= 6680;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6681;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 469;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6682;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6683;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6684;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6685;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 6686;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 6816;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 512;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 6687;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 6688;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 6689;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 6690;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 536;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 560;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6691;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 6692;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 572;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6693;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6694;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6695;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6696;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6697;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6698;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6699;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6700;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6701;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6702;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6703;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6704;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6705;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6706;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6707;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6708;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6709;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6710;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6711;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6712;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6713;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6714;
update public.tbl_biblio_temp set year= 1953 where biblio_id= 6724;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6715;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6716;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6717;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 6718;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6719;
update public.tbl_biblio_temp set year= 1924 where biblio_id= 6720;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6721;
update public.tbl_biblio_temp set year= 1937 where biblio_id= 6722;
update public.tbl_biblio_temp set year= 1938 where biblio_id= 6723;
update public.tbl_biblio_temp set year= 1956 where biblio_id= 6725;
update public.tbl_biblio_temp set year= 1956 where biblio_id= 6726;
update public.tbl_biblio_temp set year= 1963 where biblio_id= 614;
update public.tbl_biblio_temp set year= 1963 where biblio_id= 6727;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 618;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 619;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 625;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 626;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 6728;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 6729;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 631;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 6730;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 6731;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 6732;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 671;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 6733;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6734;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6735;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6736;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6737;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6738;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 686;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 6739;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 416;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 417;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 424;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 6740;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 6741;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 6742;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 691;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6743;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 6744;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 696;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 698;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 705;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 714;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 720;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 7103;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6745;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6746;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6747;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6748;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6749;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6750;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 782;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 784;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6751;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6752;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 796;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 798;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 808;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 6753;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 820;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 821;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 829;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6754;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 6755;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6756;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6757;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 6758;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 850;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 852;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6759;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 6760;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6761;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6762;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6763;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 879;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 882;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6764;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 886;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 6765;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6766;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 6767;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 6768;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 913;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6769;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 6770;
update public.tbl_biblio_temp set year= 1968 where biblio_id= 921;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6771;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 6772;
update public.tbl_biblio_temp set year= 1940 where biblio_id= 936;
update public.tbl_biblio_temp set year= 1905 where biblio_id= 6773;
update public.tbl_biblio_temp set year= 1962 where biblio_id= 944;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 6774;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6775;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6776;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6777;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6778;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6779;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6780;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6781;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6782;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6783;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6784;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6785;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6786;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6787;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6788;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6789;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6790;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6791;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 971;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6792;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6793;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6794;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 976;
update public.tbl_biblio_temp set year= 1907 where biblio_id= 6795;
update public.tbl_biblio_temp set year= 1903 where biblio_id= 6796;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 6797;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 6798;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 6799;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 993;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 995;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 1003;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 819;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 1009;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 6801;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6802;
update public.tbl_biblio_temp set year= 1891 where biblio_id= 6803;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1034;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 6804;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6805;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 6806;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 1038;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 1040;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 1041;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 6807;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6808;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 6809;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 6810;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 1049;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6811;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6812;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6813;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 6814;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 6815;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6817;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6818;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6819;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1075;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 1076;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 6820;
update public.tbl_biblio_temp set year= 1874 where biblio_id= 6821;
update public.tbl_biblio_temp set year= 1912 where biblio_id= 1085;
update public.tbl_biblio_temp set year= 1933 where biblio_id= 1095;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6822;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6823;
update public.tbl_biblio_temp set year= 1916 where biblio_id= 6824;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1130;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6825;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6826;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6827;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 6828;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 1140;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6830;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6831;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6832;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 1193;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 1194;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 6833;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6834;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 6835;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6836;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6837;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6838;
update public.tbl_biblio_temp set year= 1907 where biblio_id= 6839;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 6840;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 1217;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 6841;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 1228;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6929;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 6842;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6843;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 1251;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6845;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 1253;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 1256;
update public.tbl_biblio_temp set year= 1948 where biblio_id= 6846;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6847;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 1279;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 6848;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6849;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6850;
update public.tbl_biblio_temp set year= 1934 where biblio_id= 1284;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6864;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 6851;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 1288;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6852;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6853;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6854;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6855;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6856;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6857;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6858;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6859;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6860;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 6861;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 1297;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6862;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 1302;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 1314;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 6863;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 1315;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 1323;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 1328;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 1341;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6865;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 1424;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6866;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6867;
update public.tbl_biblio_temp set year= 1954 where biblio_id= 6868;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 6869;
update public.tbl_biblio_temp set year= 1902 where biblio_id= 6870;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6871;
update public.tbl_biblio_temp set year= 1958 where biblio_id= 1442;
update public.tbl_biblio_temp set year= 1903 where biblio_id= 6872;
update public.tbl_biblio_temp set year= 1903 where biblio_id= 6873;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 1446;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6874;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 6875;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 6876;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6877;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 6878;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 6879;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 1570;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 1574;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 6880;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6881;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6882;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6883;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6884;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6885;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6886;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 6887;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 1607;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 1613;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 6888;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 6889;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 6890;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6895;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 1634;
update public.tbl_biblio_temp set year= 1909 where biblio_id= 6891;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6892;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 6893;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6894;
update public.tbl_biblio_temp set year= 1876 where biblio_id= 6896;
update public.tbl_biblio_temp set year= 1878 where biblio_id= 6897;
update public.tbl_biblio_temp set year= 1896 where biblio_id= 6898;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 6899;
update public.tbl_biblio_temp set year= 1869 where biblio_id= 6900;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6901;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6902;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 4851;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 6903;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 6904;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 1667;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6905;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 1669;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6906;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6907;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 1673;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 6908;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 1685;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6909;
update public.tbl_biblio_temp set year= 1963 where biblio_id= 1702;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6910;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6911;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 1717;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6914;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6915;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6916;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 6917;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 6918;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6919;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6920;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6921;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 1745;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1750;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 1758;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 6922;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 1792;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 1800;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6928;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 1804;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 6923;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 6924;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 6925;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6926;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6927;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6930;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6931;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6932;
update public.tbl_biblio_temp set year= 1907 where biblio_id= 6933;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6934;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 6935;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 1862;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6936;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6937;
update public.tbl_biblio_temp set year= 1867 where biblio_id= 6938;
update public.tbl_biblio_temp set year= 1958 where biblio_id= 1875;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6939;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 1892;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 1896;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6940;
update public.tbl_biblio_temp set year= 1830 where biblio_id= 6941;
update public.tbl_biblio_temp set year= 1862 where biblio_id= 1900;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 6942;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 1905;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6943;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6944;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 6945;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6946;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6947;
update public.tbl_biblio_temp set year= 1854 where biblio_id= 6948;
update public.tbl_biblio_temp set year= 1856 where biblio_id= 6949;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 1928;
update public.tbl_biblio_temp set year= 1912 where biblio_id= 1932;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 1934;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6950;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 1941;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6951;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 6952;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6953;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6954;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6955;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 6956;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 6958;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6959;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6960;
update public.tbl_biblio_temp set year= 1954 where biblio_id= 6961;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6962;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6963;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 6964;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 6965;
update public.tbl_biblio_temp set year= 1917 where biblio_id= 6966;
update public.tbl_biblio_temp set year= 1939 where biblio_id= 6967;
update public.tbl_biblio_temp set year= 1940 where biblio_id= 6968;
update public.tbl_biblio_temp set year= 1857 where biblio_id= 6969;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 2833;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6970;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 6971;
update public.tbl_biblio_temp set year= 1966 where biblio_id= 6972;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6973;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 6974;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 6975;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 6976;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 2099;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 6977;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6978;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 6980;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6981;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6982;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 6983;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6984;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6985;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6986;
update public.tbl_biblio_temp set year= 1964 where biblio_id= 2216;
update public.tbl_biblio_temp set year= 1954 where biblio_id= 6987;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 6988;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 6989;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6990;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 6991;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 6993;
update public.tbl_biblio_temp set year= 1894 where biblio_id= 6994;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 2249;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 6995;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 6996;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 6997;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 2265;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 6998;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7110;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 6999;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 2279;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7000;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 2286;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7001;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 2289;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7004;
update public.tbl_biblio_temp set year= 1857 where biblio_id= 7005;
update public.tbl_biblio_temp set year= 1919 where biblio_id= 7006;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7007;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7008;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7009;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 7010;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 2333;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 2339;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7011;
update public.tbl_biblio_temp set year= 1940 where biblio_id= 2342;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7012;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7013;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7014;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 2358;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7015;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 2361;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7016;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7017;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7307;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7018;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7019;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7020;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7021;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 2375;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7022;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7023;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 7024;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 7025;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 2422;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7026;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7027;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7028;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7029;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7030;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7031;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 2451;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7032;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7033;
update public.tbl_biblio_temp set year= 1881 where biblio_id= 7034;
update public.tbl_biblio_temp set year= 1886 where biblio_id= 7035;
update public.tbl_biblio_temp set year= 1893 where biblio_id= 7036;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7037;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 7038;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 7039;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7040;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7041;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 2486;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 2509;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 2511;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7042;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 2523;
update public.tbl_biblio_temp set year= 1892 where biblio_id= 7044;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 7045;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 2539;
update public.tbl_biblio_temp set year= 1972 where biblio_id= 2545;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 7046;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7047;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7048;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7049;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7050;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 2553;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7051;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7052;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7053;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7054;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7055;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7056;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7057;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 7058;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 2595;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 2597;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 2612;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 2623;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 7062;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 7063;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7064;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7065;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7066;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 2636;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7102;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7067;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7068;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7069;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7070;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7071;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7072;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7073;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 7074;
update public.tbl_biblio_temp set year= 1878 where biblio_id= 2641;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7075;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 7076;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7077;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7078;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 2654;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 7079;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 2668;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7080;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7081;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7082;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7083;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7084;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7085;
update public.tbl_biblio_temp set doi='DOI: http://dx.doi.org/10.1093/jisesa/ieu138', year= 2014 where biblio_id= 7086;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7087;
update public.tbl_biblio_temp set title='Family Latridiidae. (Modified from Lompe, A. (2013) <http://www.coleo-net.de/coleo/texte/latridiidae.html>)', year= 2014, url='http://www.coleo-net.de/coleo/texte/latridiidae.html' where biblio_id= 7088;
update public.tbl_biblio_temp set year= 1956 where biblio_id= 2694;
update public.tbl_biblio_temp set year= 1940 where biblio_id= 2698;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 7089;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7090;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 2717;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7091;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 2732;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 7092;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 2753;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 2754;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7093;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 7094;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7095;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 7096;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 7097;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 2790;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 7098;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7099;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7100;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7101;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 2849;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7104;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 2850;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7105;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7106;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7107;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7108;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7109;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7111;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7112;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7113;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7114;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7115;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7116;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7117;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7118;
update public.tbl_biblio_temp set year= 1922 where biblio_id= 7119;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7120;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7121;
update public.tbl_biblio_temp set year= 1962 where biblio_id= 7122;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7123;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7124;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7125;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 2913;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7126;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 7127;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7128;
update public.tbl_biblio_temp set year= 1933 where biblio_id= 2935;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7129;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7130;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7131;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7132;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7133;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 7134;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 2954;
update public.tbl_biblio_temp set year= 1981 where biblio_id= 7135;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7136;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7137;
update public.tbl_biblio_temp set year= 1875 where biblio_id= 7667;
update public.tbl_biblio_temp set year= 1941 where biblio_id= 7138;
update public.tbl_biblio_temp set year= 1945 where biblio_id= 2967;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 2973;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7139;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7140;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7141;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7142;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7143;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7144;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7145;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7146;
update public.tbl_biblio_temp set year= 1903 where biblio_id= 7147;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7148;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7149;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7150;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7151;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 3048;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 7152;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7153;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7154;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7155;
update public.tbl_biblio_temp set year= 1899 where biblio_id= 7156;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 3093;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7308;
update public.tbl_biblio_temp set year= 1956 where biblio_id= 7157;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7158;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7159;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7161;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7162;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7163;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7164;
update public.tbl_biblio_temp set year= 1904 where biblio_id= 7165;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7166;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 3117;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 7167;
update public.tbl_biblio_temp set year= 1879 where biblio_id= 7668;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7168;
update public.tbl_biblio_temp set year= 1952 where biblio_id= 7169;
update public.tbl_biblio_temp set year= 1956 where biblio_id= 7170;
update public.tbl_biblio_temp set year= 1958 where biblio_id= 7171;
update public.tbl_biblio_temp set year= 1972 where biblio_id= 7172;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 3156;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7173;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7174;
update public.tbl_biblio_temp set year= 1903 where biblio_id= 7175;
update public.tbl_biblio_temp set year= 1968 where biblio_id= 7181;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7176;
update public.tbl_biblio_temp set year= 1949 where biblio_id= 3176;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7177;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7178;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7179;
update public.tbl_biblio_temp set year= 1900 where biblio_id= 7180;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 3218;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 3252;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 7182;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7183;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 3279;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7184;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 3284;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7185;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 7186;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 7187;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7188;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7189;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7190;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7191;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7192;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7193;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 3336;
update public.tbl_biblio_temp set year= 1902 where biblio_id= 7194;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 7195;
update public.tbl_biblio_temp set year= 1909 where biblio_id= 7196;
update public.tbl_biblio_temp set year= 1912 where biblio_id= 7197;
update public.tbl_biblio_temp set year= 1958 where biblio_id= 7198;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7199;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7200;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7201;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7202;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7203;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 3378;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 3401;
update public.tbl_biblio_temp set year= 1975 where biblio_id= 3407;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 3410;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 3421;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7204;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7205;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7206;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7207;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 3459;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 3460;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7208;
update public.tbl_biblio_temp set year= 1955 where biblio_id= 7209;
update public.tbl_biblio_temp set year= 1961 where biblio_id= 3475;
update public.tbl_biblio_temp set year= 1963 where biblio_id= 3479;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 3483;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7210;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7211;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 3510;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 7212;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 7213;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7214;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 3540;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7215;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7216;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7217;
update public.tbl_biblio_temp set year= 1981 where biblio_id= 7218;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 7219;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 1463;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7220;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7221;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7222;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7230;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7223;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7224;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 1471;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 7225;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 7226;
update public.tbl_biblio_temp set year= 1898 where biblio_id= 7227;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7228;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7229;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 1489;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7231;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7232;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7233;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7234;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7235;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7236;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7237;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7238;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7239;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7240;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 7241;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7242;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7243;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7244;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 3587;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7245;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7246;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7247;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7248;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7249;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7250;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7251;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7252;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7253;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7260;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7254;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7255;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7256;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7257;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 7258;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7259;
update public.tbl_biblio_temp set year= 1957 where biblio_id= 3660;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7261;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7262;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7263;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7264;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 7265;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 3688;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 3703;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7266;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7267;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 7268;
update public.tbl_biblio_temp set year= 1879 where biblio_id= 7269;
update public.tbl_biblio_temp set year= 1879 where biblio_id= 7270;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7271;
update public.tbl_biblio_temp set year= 1935 where biblio_id= 7272;
update public.tbl_biblio_temp set year= 1940 where biblio_id= 3758;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 3779;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 3780;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7273;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 7274;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7275;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7276;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7277;
update public.tbl_biblio_temp set year= 1953 where biblio_id= 7278;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7279;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7280;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7281;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7282;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7283;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7284;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7285;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7286;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7287;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 7288;
update public.tbl_biblio_temp set year= 1963 where biblio_id= 7289;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7290;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 3813;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 7296;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7297;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7298;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7299;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7300;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7301;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7302;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7303;
update public.tbl_biblio_temp set year= 1974 where biblio_id= 7304;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7305;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7306;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 7309;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 7310;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7311;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 7312;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7313;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7314;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 7315;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7316;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7317;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 7318;
update public.tbl_biblio_temp set year= 1977 where biblio_id= 7319;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 7320;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7321;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 3928;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7322;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7323;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7324;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7325;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 7326;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7327;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 3961;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7328;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7329;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7330;
update public.tbl_biblio_temp set year= 1908 where biblio_id= 7331;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7332;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7333;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7334;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7335;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7336;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7337;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7338;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7339;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7340;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 3970;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7341;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7342;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7343;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 3984;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7344;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7345;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 7346;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7347;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7348;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7349;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7350;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7351;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7352;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7353;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7354;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 4027;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7355;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 4028;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 7356;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7357;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7358;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7359;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7360;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7361;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7362;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7363;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7364;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7365;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7366;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7367;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7368;
update public.tbl_biblio_temp set year= 1939 where biblio_id= 7369;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 7370;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 1354;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7371;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 1386;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 4080;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7373;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7374;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7375;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7376;
update public.tbl_biblio_temp set year= 1978 where biblio_id= 7377;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 7378;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 4117;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 4129;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7379;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7380;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7381;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7382;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7383;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7384;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7385;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7386;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7387;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7388;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7389;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7390;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7391;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7392;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 7393;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 4162;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 7394;
update public.tbl_biblio_temp set year= 1918 where biblio_id= 7395;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7396;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7397;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7398;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 4171;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7399;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7400;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7401;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7402;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7410;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7403;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7404;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7405;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7406;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7407;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7408;
update public.tbl_biblio_temp set year= 1909 where biblio_id= 7409;
update public.tbl_biblio_temp set year= 1895 where biblio_id= 7669;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7411;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7412;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7413;
update public.tbl_biblio_temp set year= 1972 where biblio_id= 7414;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 4255;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7415;
update public.tbl_biblio_temp set year= 1928 where biblio_id= 7418;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7416;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7417;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 4293;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7419;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7420;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7421;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 4320;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 7422;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 4331;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7423;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 7424;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7425;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7426;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7427;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 7428;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7429;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 7428;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7429;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7430;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7431;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7432;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7433;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 1393;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 1406;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7434;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7435;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 1416;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 1419;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7436;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 4409;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7437;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7438;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7439;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7440;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7441;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 4414;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7442;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7443;
update public.tbl_biblio_temp set year= 1943 where biblio_id= 7444;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7445;
update public.tbl_biblio_temp set year= 1892 where biblio_id= 7446;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 7447;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 4438;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7448;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 4455;
update public.tbl_biblio_temp set year= 1937 where biblio_id= 7449;
update public.tbl_biblio_temp set year= 1961 where biblio_id= 4470;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7450;
update public.tbl_biblio_temp set year= 1962 where biblio_id= 4484;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7451;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7452;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7453;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7454;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7455;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7456;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7457;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7458;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7459;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7460;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7461;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7462;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7463;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7464;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7465;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 4504;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7466;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7467;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7468;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7469;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7470;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7471;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 7472;
update public.tbl_biblio_temp set year= 1986 where biblio_id= 7473;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 7474;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7495;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7475;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 4519;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7476;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7477;
update public.tbl_biblio_temp set year= 1957 where biblio_id= 7478;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7479;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 4528;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7480;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 4530;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7481;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7482;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7483;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 7484;
update public.tbl_biblio_temp set year= 1905 where biblio_id= 4548;
update public.tbl_biblio_temp set year= 1910 where biblio_id= 4549;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7485;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7486;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7487;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7488;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7489;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7490;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 4563;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 4566;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7491;
update public.tbl_biblio_temp set year= 1946 where biblio_id= 7492;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7493;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7494;
update public.tbl_biblio_temp set year= 1906 where biblio_id= 7671;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7496;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7497;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7498;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7499;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7500;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7501;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7502;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7503;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 4594;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 7504;
update public.tbl_biblio_temp set year= 1951 where biblio_id= 7505;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7506;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7507;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7508;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 4614;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7509;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7510;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7511;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7512;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7513;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 4635;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 7514;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 4648;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7515;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7524;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7516;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 4661;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7517;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7518;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7519;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7520;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 4670;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7521;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 7522;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7523;
update public.tbl_biblio_temp set year= 1981 where biblio_id= 2111;
update public.tbl_biblio_temp set year= 1981 where biblio_id= 2040;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 2131;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 4761;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 2134;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 2142;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 4688;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 4693;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7525;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7526;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7527;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7528;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7529;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7530;
update public.tbl_biblio_temp set year= 1900 where biblio_id= 7531;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 4762;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7532;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 4723;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7533;
update public.tbl_biblio_temp set year= 1965 where biblio_id= 4727;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7534;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 7535;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7536;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 4742;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7537;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7538;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7539;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7540;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 7541;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7542;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 4752;
update public.tbl_biblio_temp set year= 1866 where biblio_id= 7543;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7544;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7545;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7546;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7576;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7547;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7548;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7549;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7550;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7551;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7552;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7553;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7554;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7555;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7556;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 7557;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 4812;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7558;
update public.tbl_biblio_temp set year= 1947 where biblio_id= 7559;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7560;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7561;
update public.tbl_biblio_temp set year= 1916 where biblio_id= 4822;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7562;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7563;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7564;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7565;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7566;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7567;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7568;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7569;
update public.tbl_biblio_temp set year= 1971 where biblio_id= 1509;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7570;
update public.tbl_biblio_temp set year= 1931 where biblio_id= 1515;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7571;
update public.tbl_biblio_temp set year= 1868 where biblio_id= 7572;
update public.tbl_biblio_temp set year= 1912 where biblio_id= 7573;
update public.tbl_biblio_temp set year= 1913 where biblio_id= 7574;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 7575;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7577;
update public.tbl_biblio_temp set year= 1970 where biblio_id= 7578;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 7579;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7580;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7581;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7582;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 7583;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7584;
update public.tbl_biblio_temp set year= 1900 where biblio_id= 7670;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7585;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 7586;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7587;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7588;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7589;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7590;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 4914;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7595;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 4921;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 2151;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7591;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7592;
update public.tbl_biblio_temp set year= 1981 where biblio_id= 7593;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7594;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 7596;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7597;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7598;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7599;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7600;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 7601;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 2177;
update public.tbl_biblio_temp set year= 2004 where biblio_id= 4929;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7602;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7603;
update public.tbl_biblio_temp set year= 1973 where biblio_id= 7604;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 7605;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7606;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7607;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7608;
update public.tbl_biblio_temp set year= 1921 where biblio_id= 7652;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 7609;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 7610;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 5003;
update public.tbl_biblio_temp set year= 1925 where biblio_id= 7611;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 7612;
update public.tbl_biblio_temp set year= 1944 where biblio_id= 5008;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7613;
update public.tbl_biblio_temp set year= 1999 where biblio_id= 5014;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7614;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7615;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7616;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7617;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7618;
update public.tbl_biblio_temp set year= 1828 where biblio_id= 7619;
update public.tbl_biblio_temp set year= 1831 where biblio_id= 7620;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 5048;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 5060;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7621;
update public.tbl_biblio_temp set year= 1969 where biblio_id= 5064;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7622;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7623;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7624;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7625;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7626;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7627;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7628;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7629;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7630;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7631;
update public.tbl_biblio_temp set year= 1930 where biblio_id= 7653;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7632;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7633;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7634;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7635;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7636;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7637;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7638;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7639;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7640;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7641;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7642;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7643;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7644;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7645;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7646;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7647;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7648;
update public.tbl_biblio_temp set year= 1959 where biblio_id= 7649;
update public.tbl_biblio_temp set year= 1905 where biblio_id= 7650;
update public.tbl_biblio_temp set year= 1914 where biblio_id= 7651;
update public.tbl_biblio_temp set year= 1939 where biblio_id= 7654;
update public.tbl_biblio_temp set year= 1939 where biblio_id= 7655;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7656;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 7657;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7658;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7659;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7660;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7661;
update public.tbl_biblio_temp set year= 1952 where biblio_id= 7662;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7663;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7664;
update public.tbl_biblio_temp set year= 1948 where biblio_id= 7665;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 5186;
update public.tbl_biblio_temp set year= 1875 where biblio_id= 7666;
update public.tbl_biblio_temp set year= 1907 where biblio_id= 7672;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 5194;
update public.tbl_biblio_temp set year= 1997 where biblio_id= 5197;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7673;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7674;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7675;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7676;
update public.tbl_biblio_temp set year= 1939 where biblio_id= 7677;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7678;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7679;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7685;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7680;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7681;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7682;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7683;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7684;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7686;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7687;
update public.tbl_biblio_temp set year= 1995 where biblio_id= 5237;
update public.tbl_biblio_temp set year= 1864 where biblio_id= 7688;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7689;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 5241;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7690;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7691;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7692;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7693;
update public.tbl_biblio_temp set year= 1998 where biblio_id= 7694;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7695;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 5255;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 7696;
update public.tbl_biblio_temp set year= 1996 where biblio_id= 5256;
update public.tbl_biblio_temp set year= 1877 where biblio_id= 7697;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7698;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7699;
update public.tbl_biblio_temp set year= 2007 where biblio_id= 7700;
update public.tbl_biblio_temp set year= 1919 where biblio_id= 7701;
update public.tbl_biblio_temp set year= 1982 where biblio_id= 7702;
update public.tbl_biblio_temp set year= 1961 where biblio_id= 7703;
update public.tbl_biblio_temp set year= 1962 where biblio_id= 7704;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 5350;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 5378;
update public.tbl_biblio_temp set year= 1993 where biblio_id= 7705;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 5414;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7706;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7707;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 5426;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7708;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7709;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7710;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 5452;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 7711;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7713;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7714;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 7715;
update public.tbl_biblio_temp set year= 1979 where biblio_id= 5483;
update public.tbl_biblio_temp set year= 1984 where biblio_id= 7716;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7717;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7718;
update public.tbl_biblio_temp set year= 1968 where biblio_id= 7719;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7720;
update public.tbl_biblio_temp set year= 1967 where biblio_id= 5508;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7721;
update public.tbl_biblio_temp set year= 1854 where biblio_id= 7722;
update public.tbl_biblio_temp set year= 2003 where biblio_id= 7723;
update public.tbl_biblio_temp set year= 1968 where biblio_id= 7724;
update public.tbl_biblio_temp set year= 1983 where biblio_id= 5533;
update public.tbl_biblio_temp set year= 2008 where biblio_id= 7725;
update public.tbl_biblio_temp set year= 2009 where biblio_id= 7726;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7727;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 7728;
update public.tbl_biblio_temp set year= 1894 where biblio_id= 7731;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7732;
update public.tbl_biblio_temp set year= 1980 where biblio_id= 7733;
update public.tbl_biblio_temp set year= 2000 where biblio_id= 7734;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 7735;
update public.tbl_biblio_temp set year= 1991 where biblio_id= 7736;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7745;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7746;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7747;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7748;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7749;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7750;
update public.tbl_biblio_temp set year= 2020 where biblio_id= 7751;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7752;
update public.tbl_biblio_temp set year= 1904 where biblio_id= 7753;
update public.tbl_biblio_temp set year= '1997-2007' where biblio_id= 7796;
update public.tbl_biblio_temp set year= 1955 where biblio_id= 7797;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7798;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7799;
update public.tbl_biblio_temp set year= 1990 where biblio_id= 7800;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7801;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7802;
update public.tbl_biblio_temp set year= 1985 where biblio_id= 7803;
update public.tbl_biblio_temp set year= 2001 where biblio_id= 7804;
update public.tbl_biblio_temp set year= 1992 where biblio_id= 7805;
update public.tbl_biblio_temp set year= 1927 where biblio_id= 7806;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7807;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7808;
update public.tbl_biblio_temp set year= 2015 where biblio_id= 7809;
update public.tbl_biblio_temp set year= 1953 where biblio_id= 7810;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 7811;
update public.tbl_biblio_temp set year= 2005 where biblio_id= 7812;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7813;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7814;
update public.tbl_biblio_temp set year= 1907 where biblio_id= 7815;
update public.tbl_biblio_temp set year= 1988 where biblio_id= 7858;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7816;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7817;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7818;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7819;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7820;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7821;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7822;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7823;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7824;
update public.tbl_biblio_temp set year= 2013 where biblio_id= 7825;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7826;
update public.tbl_biblio_temp set year= 1976 where biblio_id= 7827;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7828;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7829;
update public.tbl_biblio_temp set year= 2011 where biblio_id= 7830;
update public.tbl_biblio_temp set year= 2018 where biblio_id= 7831;
update public.tbl_biblio_temp set year= 1989 where biblio_id= 7859;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7832;
update public.tbl_biblio_temp set year= 2006 where biblio_id= 7833;
update public.tbl_biblio_temp set year= 1994 where biblio_id= 7834;
update public.tbl_biblio_temp set year= 1987 where biblio_id= 7835;
update public.tbl_biblio_temp set year= 2002 where biblio_id= 7836;
update public.tbl_biblio_temp set year= 2016 where biblio_id= 7837;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7838;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7839;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7840;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7841;
update public.tbl_biblio_temp set year= 2014 where biblio_id= 7842;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7843;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7844;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7845;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7846;
update public.tbl_biblio_temp set year= 2010 where biblio_id= 7847;
update public.tbl_biblio_temp set year= 2017 where biblio_id= 7848;
update public.tbl_biblio_temp set year= 2012 where biblio_id= 7870;
update public.tbl_biblio_temp set year= 1972 where biblio_id= 7871;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7872;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7873;
update public.tbl_biblio_temp set year= 1864 where biblio_id= 7874;
update public.tbl_biblio_temp set year= 2019 where biblio_id= 7875;


select format('update tbl_biblio set doi = ''%s'' where bugs_reference = ''%s'';', doi, bugs_reference)
from tbl_biblio_temp
where doi is not null
union
select format('update tbl_biblio set isbn = ''%s'' where bugs_reference = ''%s'';', isbn, bugs_reference)
from tbl_biblio_temp
where isbn is not null
union
select format('update tbl_biblio set notes = ''%s'' where bugs_reference = ''%s'';', notes, bugs_reference)
from tbl_biblio_temp
where notes is not null
union
select format('update tbl_biblio set title = ''%s'' where bugs_reference = ''%s'';', title, bugs_reference)
from tbl_biblio_temp
where title is not null
union
select format('update tbl_biblio set year = ''%s'' where bugs_reference = ''%s'';', year, bugs_reference)
from tbl_biblio_temp
where year is not null
union
select format('update tbl_biblio set authors = ''%s'' where bugs_reference = ''%s'';', authors, bugs_reference)
from tbl_biblio_temp
where authors is not null
union
select format('update tbl_biblio set full_reference = ''%s'' where bugs_reference = ''%s'';', full_reference, bugs_reference)
from tbl_biblio_temp
where full_reference is not null
union
select format('update tbl_biblio set url = ''%s'' where bugs_reference = ''%s'';', url, bugs_reference)
from tbl_biblio_temp
where url is not null;

select format('update tbl_biblio set %s = ''%s'' where bugs_reference = ''%s'';', "key", "value", bugs_reference)
from (
    select 'doi' as "key", doi as value, bugs_reference
    from tbl_biblio_temp
    where doi is not null
    union
    select 'isbn' as "key", isbn as value, bugs_reference
    from tbl_biblio_temp
    where isbn is not null
    union
    select 'notes' as "key", notes as value, bugs_reference
    from tbl_biblio_temp
    where notes is not null
    union
    select 'title' as "key", title as value, bugs_reference
    from tbl_biblio_temp
    where title is not null
    union
    select 'year' as "key", "year" as value, bugs_reference
    from tbl_biblio_temp
    where "year" is not null
    union
    select 'authors' as "key", authors as value, bugs_reference
    from tbl_biblio_temp
    where authors is not null
    union
    select 'full_reference' as "key", full_reference as value, bugs_reference
    from tbl_biblio_temp
    where full_reference is not null
    union
    select 'url' as "key", url as value, bugs_reference
    from tbl_biblio_temp
    where "url" is not null
) as x("key", "value", bugs_reference)
		
	