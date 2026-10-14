-- fix_gadm_names.sql - repairs unit names and types in an already-loaded gadm schema.
--
-- For data loaded by import_gadm_data.sh before it took names with mode() rather than
-- max(). Every leaf in a GID group is supposed to carry the same name, but a few in
-- GADM 4.1 do not, and max() let the odd one out win: two ~1 km2 slivers filed under
-- GBR.1_1 carry NAME_1 'Wales', so the whole of England was stored as "Wales" and the
-- data held two Waleses and no England at all.
--
-- Below is every group whose leaves disagree in GADM 4.1 - 90 of them - set to the name
-- most of the leaves carry, which is what the fixed importer now produces. Ties go to the
-- alphabetically first, as mode() WITHIN GROUP (ORDER BY ...) does. The leaf tally is in
-- the comment on each line, so a wrong-looking correction can be checked against it.
--
-- Idempotent, and geometry is never touched. Re-importing with the current script makes
-- it unnecessary; it exists so an existing deployment need not spend hours re-dissolving.
--
-- Usage: psql -U <user> -d <database> -v ON_ERROR_STOP=1 -f fix_gadm_names.sql

BEGIN;

-- gadm.adm_1.name_1 - unit name (4 groups)
UPDATE gadm.adm_1 SET name_1 = 'England' WHERE gid = 'GBR.1_1';  -- leaves: England x7441, Wales x2
UPDATE gadm.adm_1 SET name_1 = 'Cork' WHERE gid = 'IRL.4_1';  -- leaves: Cork x8, Cork City x1
UPDATE gadm.adm_1 SET name_1 = 'Kili / Bikini / Ejit' WHERE gid = 'MHL.19_1';  -- leaves: Kili / Bikini / Ejit x1, Rongelap x1
UPDATE gadm.adm_1 SET name_1 = 'Zuid-Holland' WHERE gid = 'NLD.14_1';  -- leaves: Zuid-Holland x52, Zuid Hollandse Meren x1

-- gadm.adm_1.type - unit type (1 groups)
UPDATE gadm.adm_1 SET type = 'Provincie' WHERE gid = 'NLD.14_1';  -- leaves: Provincie x52, Water body x1

-- gadm.adm_1.engtype - unit type (English) (1 groups)
UPDATE gadm.adm_1 SET engtype = 'Province' WHERE gid = 'NLD.14_1';  -- leaves: Province x52, Water body x1

-- gadm.adm_2.name_2 - unit name (86 groups)
UPDATE gadm.adm_2 SET name_2 = 'Brändö' WHERE gid = 'ALA.1.1_2';  -- leaves: Brändö x1, Sottunga x1, Vårdö x1
UPDATE gadm.adm_2 SET name_2 = 'Finström' WHERE gid = 'ALA.2.2_2';  -- leaves: Finström x1, Geta x1
UPDATE gadm.adm_2 SET name_2 = 'Tamarugal' WHERE gid = 'CHL.15.1_1';  -- leaves: Tamarugal x5, Iquique x2
UPDATE gadm.adm_2 SET name_2 = 'Tameside' WHERE gid = 'GBR.1.100_1';  -- leaves: Tameside x17, Manchester x3
UPDATE gadm.adm_2 SET name_2 = 'Trafford' WHERE gid = 'GBR.1.104_1';  -- leaves: Trafford x18, Manchester x3
UPDATE gadm.adm_2 SET name_2 = 'Walsall' WHERE gid = 'GBR.1.106_1';  -- leaves: Walsall x19, Sandwell x2, Wolverhampton x2, Birmingham x1, Dudley x1
UPDATE gadm.adm_2 SET name_2 = 'Warrington' WHERE gid = 'GBR.1.107_1';  -- leaves: Warrington x22, Wigan x2, Halton x1
UPDATE gadm.adm_2 SET name_2 = 'Warwickshire' WHERE gid = 'GBR.1.108_1';  -- leaves: Warwickshire x105, Coventry x3, Staffordshire x2, Worcestershire x1
UPDATE gadm.adm_2 SET name_2 = 'Wigan' WHERE gid = 'GBR.1.111_1';  -- leaves: Wigan x22, Lancashire x1
UPDATE gadm.adm_2 SET name_2 = 'Wiltshire' WHERE gid = 'GBR.1.112_1';  -- leaves: Wiltshire x97, Swindon x3
UPDATE gadm.adm_2 SET name_2 = 'Windsor and Maidenhead' WHERE gid = 'GBR.1.113_1';  -- leaves: Windsor and Maidenhead x19, Surrey x1
UPDATE gadm.adm_2 SET name_2 = 'Wokingham' WHERE gid = 'GBR.1.115_1';  -- leaves: Wokingham x25, Reading x5
UPDATE gadm.adm_2 SET name_2 = 'Worcestershire' WHERE gid = 'GBR.1.117_1';  -- leaves: Worcestershire x119, Birmingham x2, Gloucestershire x2
UPDATE gadm.adm_2 SET name_2 = 'Bristol, City of' WHERE gid = 'GBR.1.12_1';  -- leaves: Bristol, City of x32, South Gloucestershire x1
UPDATE gadm.adm_2 SET name_2 = 'Buckinghamshire' WHERE gid = 'GBR.1.13_1';  -- leaves: Buckinghamshire x95, Central Bedfordshire x1, Greater London x1, Slough x1
UPDATE gadm.adm_2 SET name_2 = 'Bury' WHERE gid = 'GBR.1.14_1';  -- leaves: Bury x16, Bolton x1
UPDATE gadm.adm_2 SET name_2 = 'Cambridgeshire' WHERE gid = 'GBR.1.16_1';  -- leaves: Cambridgeshire x109, Norfolk x42, Hertfordshire x2, Peterborough x1, Suffolk x1
UPDATE gadm.adm_2 SET name_2 = 'Central Bedfordshire' WHERE gid = 'GBR.1.17_1';  -- leaves: Central Bedfordshire x29, Bedford x2, Hertfordshire x2
UPDATE gadm.adm_2 SET name_2 = 'Cheshire East' WHERE gid = 'GBR.1.18_1';  -- leaves: Cheshire East x51, Cheshire West and Chester x3
UPDATE gadm.adm_2 SET name_2 = 'Cheshire West and Chester' WHERE gid = 'GBR.1.19_1';  -- leaves: Cheshire West and Chester x44, Cheshire East x1, Flintshire x1, Halton x1
UPDATE gadm.adm_2 SET name_2 = 'Barnsley' WHERE gid = 'GBR.1.1_1';  -- leaves: Barnsley x20, Rotherham x3
UPDATE gadm.adm_2 SET name_2 = 'Cornwall' WHERE gid = 'GBR.1.20_1';  -- leaves: Cornwall x122, Devon x1
UPDATE gadm.adm_2 SET name_2 = 'Coventry' WHERE gid = 'GBR.1.21_1';  -- leaves: Coventry x15, Warwickshire x1
UPDATE gadm.adm_2 SET name_2 = 'Derbyshire' WHERE gid = 'GBR.1.25_1';  -- leaves: Derbyshire x169, Derby x2
UPDATE gadm.adm_2 SET name_2 = 'Devon' WHERE gid = 'GBR.1.26_1';  -- leaves: Devon x181, Plymouth x2
UPDATE gadm.adm_2 SET name_2 = 'Doncaster' WHERE gid = 'GBR.1.27_1';  -- leaves: Doncaster x21, Barnsley x1
UPDATE gadm.adm_2 SET name_2 = 'Dorset' WHERE gid = 'GBR.1.28_1';  -- leaves: Dorset x87, Bournemouth, Christchurch and Po x11
UPDATE gadm.adm_2 SET name_2 = 'Dudley' WHERE gid = 'GBR.1.29_1';  -- leaves: Dudley x18, Worcestershire x1
UPDATE gadm.adm_2 SET name_2 = 'East Riding of Yorkshire' WHERE gid = 'GBR.1.31_1';  -- leaves: East Riding of Yorkshire x26, North Lincolnshire x1
UPDATE gadm.adm_2 SET name_2 = 'East Sussex' WHERE gid = 'GBR.1.32_1';  -- leaves: East Sussex x101, Brighton and Hove x1, West Sussex x1
UPDATE gadm.adm_2 SET name_2 = 'Essex' WHERE gid = 'GBR.1.33_1';  -- leaves: Essex x242, Southend-on-Sea x1
UPDATE gadm.adm_2 SET name_2 = 'Gloucestershire' WHERE gid = 'GBR.1.35_1';  -- leaves: Gloucestershire x143, Monmouthshire x1, Warwickshire x1
UPDATE gadm.adm_2 SET name_2 = 'Greater London' WHERE gid = 'GBR.1.36_1';  -- leaves: Greater London x656, Kent x1, Surrey x1
UPDATE gadm.adm_2 SET name_2 = 'Hampshire' WHERE gid = 'GBR.1.38_1';  -- leaves: Hampshire x222, Surrey x2, Wiltshire x1
UPDATE gadm.adm_2 SET name_2 = 'Hertfordshire' WHERE gid = 'GBR.1.41_1';  -- leaves: Hertfordshire x175, Buckinghamshire x3
UPDATE gadm.adm_2 SET name_2 = 'Knowsley' WHERE gid = 'GBR.1.47_1';  -- leaves: Knowsley x14, Liverpool x2
UPDATE gadm.adm_2 SET name_2 = 'Lancashire' WHERE gid = 'GBR.1.48_1';  -- leaves: Lancashire x249, Blackpool x1, Sefton x1
UPDATE gadm.adm_2 SET name_2 = 'Birmingham' WHERE gid = 'GBR.1.4_1';  -- leaves: Birmingham x64, Solihull x5
UPDATE gadm.adm_2 SET name_2 = 'Leicester' WHERE gid = 'GBR.1.50_1';  -- leaves: Leicester x19, Leicestershire x2
UPDATE gadm.adm_2 SET name_2 = 'Leicestershire' WHERE gid = 'GBR.1.51_1';  -- leaves: Leicestershire x148, Rutland x3, Leicester x2, Warwickshire x1
UPDATE gadm.adm_2 SET name_2 = 'Lincolnshire' WHERE gid = 'GBR.1.52_1';  -- leaves: Lincolnshire x155, North East Lincolnshire x15, Nottinghamshire x1
UPDATE gadm.adm_2 SET name_2 = 'Manchester' WHERE gid = 'GBR.1.54_1';  -- leaves: Manchester x25, Salford x4, Bury x1, Trafford x1
UPDATE gadm.adm_2 SET name_2 = 'Middlesbrough' WHERE gid = 'GBR.1.56_1';  -- leaves: Middlesbrough x17, Stockton-on-Tees x1
UPDATE gadm.adm_2 SET name_2 = 'Newcastle upon Tyne' WHERE gid = 'GBR.1.58_1';  -- leaves: Newcastle upon Tyne x26, Gateshead x2, North Tyneside x1
UPDATE gadm.adm_2 SET name_2 = 'Norfolk' WHERE gid = 'GBR.1.59_1';  -- leaves: Norfolk x154, Suffolk x1
UPDATE gadm.adm_2 SET name_2 = 'North Lincolnshire' WHERE gid = 'GBR.1.60_1';  -- leaves: North Lincolnshire x16, Lincolnshire x1
UPDATE gadm.adm_2 SET name_2 = 'North Somerset' WHERE gid = 'GBR.1.61_1';  -- leaves: North Somerset x35, Bristol, City of x2
UPDATE gadm.adm_2 SET name_2 = 'North Tyneside' WHERE gid = 'GBR.1.62_1';  -- leaves: North Tyneside x19, South Tyneside x1
UPDATE gadm.adm_2 SET name_2 = 'Northamptonshire' WHERE gid = 'GBR.1.64_1';  -- leaves: Northamptonshire x143, Leicestershire x1
UPDATE gadm.adm_2 SET name_2 = 'Northumberland' WHERE gid = 'GBR.1.65_1';  -- leaves: Northumberland x66, County Durham x1
UPDATE gadm.adm_2 SET name_2 = 'Nottingham' WHERE gid = 'GBR.1.66_1';  -- leaves: Nottingham x19, Nottinghamshire x4
UPDATE gadm.adm_2 SET name_2 = 'Nottinghamshire' WHERE gid = 'GBR.1.67_1';  -- leaves: Nottinghamshire x164, Derbyshire x4, Nottingham x1
UPDATE gadm.adm_2 SET name_2 = 'Oxfordshire' WHERE gid = 'GBR.1.69_1';  -- leaves: Oxfordshire x112, Reading x2
UPDATE gadm.adm_2 SET name_2 = 'Portsmouth' WHERE gid = 'GBR.1.73_1';  -- leaves: Portsmouth x15, Hampshire x1
UPDATE gadm.adm_2 SET name_2 = 'Reading' WHERE gid = 'GBR.1.74_1';  -- leaves: Reading x9, West Berkshire x5
UPDATE gadm.adm_2 SET name_2 = 'Redcar and Cleveland' WHERE gid = 'GBR.1.75_1';  -- leaves: Redcar and Cleveland x22, Middlesbrough x3
UPDATE gadm.adm_2 SET name_2 = 'Rochdale' WHERE gid = 'GBR.1.76_1';  -- leaves: Rochdale x20, Oldham x1
UPDATE gadm.adm_2 SET name_2 = 'Rotherham' WHERE gid = 'GBR.1.77_1';  -- leaves: Rotherham x18, Derbyshire x1
UPDATE gadm.adm_2 SET name_2 = 'Rutland' WHERE gid = 'GBR.1.78_1';  -- leaves: Rutland x13, Lincolnshire x1
UPDATE gadm.adm_2 SET name_2 = 'Bolton' WHERE gid = 'GBR.1.7_1';  -- leaves: Bolton x19, Lancashire x1, Wigan x1
UPDATE gadm.adm_2 SET name_2 = 'Salford' WHERE gid = 'GBR.1.80_1';  -- leaves: Salford x16, Trafford x2
UPDATE gadm.adm_2 SET name_2 = 'Sandwell' WHERE gid = 'GBR.1.81_1';  -- leaves: Sandwell x22, Dudley x2, Birmingham x1
UPDATE gadm.adm_2 SET name_2 = 'Liverpool' WHERE gid = 'GBR.1.82_1';  -- leaves: Liverpool x28, Sefton x21, Knowsley x1
UPDATE gadm.adm_2 SET name_2 = 'Shropshire' WHERE gid = 'GBR.1.84_1';  -- leaves: Shropshire x63, Worcestershire x1
UPDATE gadm.adm_2 SET name_2 = 'Slough' WHERE gid = 'GBR.1.85_1';  -- leaves: Slough x14, Windsor and Maidenhead x4
UPDATE gadm.adm_2 SET name_2 = 'Solihull' WHERE gid = 'GBR.1.86_1';  -- leaves: Solihull x12, Birmingham x1
UPDATE gadm.adm_2 SET name_2 = 'South Tyneside' WHERE gid = 'GBR.1.89_1';  -- leaves: South Tyneside x17, Sunderland x2
UPDATE gadm.adm_2 SET name_2 = 'Southampton' WHERE gid = 'GBR.1.90_1';  -- leaves: Southampton x16, Hampshire x1
UPDATE gadm.adm_2 SET name_2 = 'Staffordshire' WHERE gid = 'GBR.1.92_1';  -- leaves: Staffordshire x159, Dudley x3, Wolverhampton x3, Walsall x1
UPDATE gadm.adm_2 SET name_2 = 'Stockport' WHERE gid = 'GBR.1.93_1';  -- leaves: Stockport x21, Tameside x2, Manchester x1
UPDATE gadm.adm_2 SET name_2 = 'Stoke-on-Trent' WHERE gid = 'GBR.1.95_1';  -- leaves: Stoke-on-Trent x37, Staffordshire x3
UPDATE gadm.adm_2 SET name_2 = 'Sunderland' WHERE gid = 'GBR.1.97_1';  -- leaves: Sunderland x23, County Durham x1
UPDATE gadm.adm_2 SET name_2 = 'Causeway Coast and Glens' WHERE gid = 'GBR.2.4_1';  -- leaves: Causeway Coast and Glens x40, Derry City and Strabane x1
UPDATE gadm.adm_2 SET name_2 = 'Lisburn and Castlereagh' WHERE gid = 'GBR.2.7_1';  -- leaves: Lisburn and Castlereagh x40, Belfast x13
UPDATE gadm.adm_2 SET name_2 = 'North Ayrshire' WHERE gid = 'GBR.3.21_1';  -- leaves: North Ayrshire x10, Argyll and Bute x1
UPDATE gadm.adm_2 SET name_2 = 'Gwynedd' WHERE gid = 'GBR.4.11_1';  -- leaves: Gwynedd x71, Isle of Anglesey x2
UPDATE gadm.adm_2 SET name_2 = 'Merthyr Tydfil' WHERE gid = 'GBR.4.12_1';  -- leaves: Merthyr Tydfil x11, Rhondda Cynon Taf x3
UPDATE gadm.adm_2 SET name_2 = 'Neath Port Talbot' WHERE gid = 'GBR.4.14_1';  -- leaves: Neath Port Talbot x39, Bridgend x1
UPDATE gadm.adm_2 SET name_2 = 'Swansea' WHERE gid = 'GBR.4.19_1';  -- leaves: Swansea x37, Neath Port Talbot x2
UPDATE gadm.adm_2 SET name_2 = 'Torfaen' WHERE gid = 'GBR.4.20_1';  -- leaves: Torfaen x24, Blaenau Gwent x3, Newport x1
UPDATE gadm.adm_2 SET name_2 = 'Vale of Glamorgan' WHERE gid = 'GBR.4.21_1';  -- leaves: Vale of Glamorgan x23, Cardiff x1
UPDATE gadm.adm_2 SET name_2 = 'Wrexham' WHERE gid = 'GBR.4.22_1';  -- leaves: Wrexham x47, Flintshire x2
UPDATE gadm.adm_2 SET name_2 = 'Blaenau Gwent' WHERE gid = 'GBR.4.2_1';  -- leaves: Blaenau Gwent x13, Caerphilly x2
UPDATE gadm.adm_2 SET name_2 = 'Bridgend' WHERE gid = 'GBR.4.3_1';  -- leaves: Bridgend x38, Neath Port Talbot x1
UPDATE gadm.adm_2 SET name_2 = 'Denbighshire' WHERE gid = 'GBR.4.9_1';  -- leaves: Denbighshire x30, Conwy x1
UPDATE gadm.adm_2 SET name_2 = 'Malyn' WHERE gid = 'UKR.27.15_1';  -- leaves: Malyn x1, Malyns'kyi x1

-- gadm.adm_2.name_1 - parent (level 1) name (2 groups)
UPDATE gadm.adm_2 SET name_1 = 'England' WHERE gid = 'GBR.1.19_1';  -- leaves: England x46, Wales x1
UPDATE gadm.adm_2 SET name_1 = 'England' WHERE gid = 'GBR.1.35_1';  -- leaves: England x144, Wales x1

-- gadm.adm_2.type - unit type (5 groups)
UPDATE gadm.adm_2 SET type = 'Administrative County' WHERE gid = 'GBR.1.13_1';  -- leaves: Administrative County x97, Ceremonial County x1
UPDATE gadm.adm_2 SET type = 'Ceremonial County' WHERE gid = 'GBR.1.36_1';  -- leaves: Ceremonial County x635, Region x23
UPDATE gadm.adm_2 SET type = 'Administrative County' WHERE gid = 'GBR.1.48_1';  -- leaves: Administrative County x248,  x3
UPDATE gadm.adm_2 SET type = 'Unitary Authority' WHERE gid = 'GBR.1.6_1';  -- leaves: Unitary Authority x17,  x3
UPDATE gadm.adm_2 SET type = 'Island area' WHERE gid = 'GBR.3.27_1';  -- leaves: Island area x6,  x1

-- gadm.adm_2.engtype - unit type (English) (6 groups)
UPDATE gadm.adm_2 SET engtype = 'Administrative County' WHERE gid = 'GBR.1.13_1';  -- leaves: Administrative County x97, Ceremonial County x1
UPDATE gadm.adm_2 SET engtype = 'Ceremonial County' WHERE gid = 'GBR.1.36_1';  -- leaves: Ceremonial County x635, Region x23
UPDATE gadm.adm_2 SET engtype = 'Administrative County' WHERE gid = 'GBR.1.48_1';  -- leaves: Administrative County x248,  x3
UPDATE gadm.adm_2 SET engtype = 'Unitary Authority' WHERE gid = 'GBR.1.6_1';  -- leaves: Unitary Authority x17,  x3
UPDATE gadm.adm_2 SET engtype = 'Island area' WHERE gid = 'GBR.3.27_1';  -- leaves: Island area x6,  x1
UPDATE gadm.adm_2 SET engtype = 'City' WHERE gid = 'UKR.27.15_1';  -- leaves: City x1, District x1

COMMIT;
