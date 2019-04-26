--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.21
-- Dumped by pg_dump version 9.6.11

-- Started on 2019-04-21 14:35:55 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5689 (class 0 OID 23397)
-- Dependencies: 193
-- Data for Name: tbl_abundance_elements; Type: TABLE DATA; Schema: public; Owner: sead_master
--

COPY public.tbl_abundance_elements (abundance_element_id, record_type_id, element_name, element_description, date_updated) FROM stdin;
37	2	Whole plant	Tree/bush/plant	2012-09-21 18:51:47.967181+02
1	1	Whole arthropod	A complete, or near complete, insect or similar individual	2012-09-21 18:51:47.967181+02
2	2	Pollen grain	Whole or partial pollen grain	2012-09-21 18:51:47.967181+02
3	2	Leaf	Whole or partial leaf	2012-09-21 18:51:47.967181+02
4	2	Seed grain	An individual or partial sead grain	2012-09-21 18:51:47.967181+02
17	1	Aedeagus	Reproductive organ of male insect.	2012-09-21 18:51:47.967181+02
5	1	MNI	Minimum Number of Individuals - an estimation of the number of whole animals represented by the collective parts found.	2012-09-21 18:51:47.967181+02
6	1	Left elytron	Left wing case.	2012-09-21 18:51:47.967181+02
7	1	Right elytron	Right wing case.	2012-09-21 18:51:47.967181+02
8	1	Thorax	\N	2012-09-21 18:51:47.967181+02
9	1	Head	\N	2012-09-21 18:51:47.967181+02
10	1	Body segment (other)	\N	2012-09-21 18:51:47.967181+02
11	1	Leg	\N	2012-09-21 18:51:47.967181+02
12	2	Flower	\N	2012-09-21 18:51:47.967181+02
13	2	Leaf bud	\N	2012-09-21 18:51:47.967181+02
14	4	Shell	\N	2012-09-21 18:51:47.967181+02
15	8	Carapace	Dorsal section of arthropod exoskeleton or shell, plus some vertebrates such as turtles.	2012-09-21 18:51:47.967181+02
16	3	Spore	\N	2012-09-21 18:51:47.967181+02
38	3	Unknown	Unidentified ~pollen sized fossil	2012-09-21 18:51:47.967181+02
18	2	Needle	Foliage element of pine, spruce and other needle bearing plants.	2012-09-21 18:51:47.967181+02
19	2	Cone	Seed releasing body of coniferous plants.	2012-09-21 18:51:47.967181+02
20	2	Flower bud	\N	2012-09-21 18:51:47.967181+02
21	2	Flower	\N	2012-09-21 18:51:47.967181+02
26	2	Ear	\N	2012-09-21 18:51:47.967181+02
22	2	Leaf sheath	Lower part of the leaf, sometimes surrounding the stem.	2012-09-21 18:51:47.967181+02
23	2	Culm node (solid)	Place on a plant stem where a leaf is attached, solid stem part.	2012-09-21 18:51:47.967181+02
24	2	Culm node (hollow)	Place on a plant stem where a leaf is attached, hollow stem part.	2012-09-21 18:51:47.967181+02
25	2	Culm node (undefined)	Place on a plant stem where a leaf is attached, stem part indeterminate or both solid and hollow node parts.	2012-09-21 18:51:47.967181+02
27	2	Spikelet	Flowers of the grasses, cereals etc.	2012-09-21 18:51:47.967181+02
28	2	Chaff	Broken lemmas, glumes etc. Commonly unwanted products of threshing.	2012-09-21 18:51:47.967181+02
29	2	Awn fragment	\N	2012-09-21 18:51:47.967181+02
30	2	Spikelet fork	\N	2012-09-21 18:51:47.967181+02
31	2	Rachis fragment	A fragment part of a segment from the main axis of the cereal/grass spike to which the spikelets are attached.	2012-09-21 18:51:47.967181+02
32	2	Glume base	\N	2012-09-21 18:51:47.967181+02
33	2	Rachis segment(S)	Part(s) of the main axis of the cereal/grass spike to which the spikelets are attached.	2012-09-21 18:51:47.967181+02
34	2	Palea	\N	2012-09-21 18:51:47.967181+02
35	2	Lemma	\N	2012-09-21 18:51:47.967181+02
36	2	Glume	\N	2012-09-21 18:51:47.967181+02
39	2	Shell	Hard casing of nut, fruit stone or similar	2013-05-13 10:44:18.668033+02
40	2	Berry	Fruiting body (i.e. pulp and seed or seedless body, but not only seeds)	2013-05-13 10:44:18.668033+02
41	2	Stem	Over ground structural component of plant (note: use other terms for woody plant twigs, branches etc)	2013-05-13 10:44:18.668033+02
42	2	Twig	Small terminal branch of woody plant	2013-05-13 10:44:18.668033+02
43	2	Bark	Outermost layer of woody plant stem or root	2013-05-13 10:44:18.668033+02
44	2	Wood	Structural tissue of woody plant, e.g. wood chips or bits in soil samples (note: use twig for small branches)	2013-05-13 10:44:18.668033+02
45	2	Root	Supporting and most commonly underground structural part of plant with the function of absorbing water and nutrients from the soil. (Variation in function and relation to ground occur).	2013-06-19 14:28:38.122065+02
46	2	Corm (Root bulb/root tuber)	Tuber/bulb-like structure on the roots of some cultivated plants (e.g. Arrhenatherum elatius var. bulbosum)	2013-06-19 14:38:33.880661+02
47	2	Cone scale	Individual plate on a cone	2013-06-19 14:39:37.643884+02
48	2	Endosperm	Internal part of seed, usually providing starch (nutrition) for the initial growth of the plant	2013-06-19 14:41:26.598067+02
49	2	Straw	Grassy cultivated plant (mainly cereal) stem(s)	2013-09-30 10:00:50.989332+02
\.


--
-- TOC entry 5696 (class 0 OID 0)
-- Dependencies: 337
-- Name: tbl_abundance_elements_abundance_element_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sead_master
--

SELECT pg_catalog.setval('public.tbl_abundance_elements_abundance_element_id_seq', 49, true);


-- Completed on 2019-04-21 14:35:55 CEST

--
-- PostgreSQL database dump complete
--

