-- Deploy facet: 20260323_DML_FACET_DESCRIPTIONS

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-03-23
  Description   Update facet descriptions: improve 26 facets where description was missing or just the filter name
  Issue         https://github.com/humlab-sead/sead_change_control/issues/
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Source: filters.json review. Only facets where the description was identical to the display title
                or otherwise uninformative have been updated. Already-good descriptions are left untouched.
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

begin;

set search_path = facet, pg_catalog;

-- facet_id 3: Magnetic susceptibility range filter
update facet.facet set description = 'Measure of the degree to which a material can be magnetized in the presence of an external magnetic field.'
where facet_id = 3 and description is distinct from 'Measure of the degree to which a material can be magnetized in the presence of an external magnetic field.';

-- facet_id 4: MS after heating to 550°C
update facet.facet set description = 'Measurement of the magnetic susceptibility of a sample after heating at a temperature of 550°C.'
where facet_id = 4 and description is distinct from 'Measurement of the magnetic susceptibility of a sample after heating at a temperature of 550°C.';

-- facet_id 5: Loss on Ignition (also fixes "Loss of Ignition" typo in current description)
update facet.facet set description = 'Organic content in % from weight lost when heated to a high temperature (e.g. 550°C)'
where facet_id = 5 and description is distinct from 'Organic content in % from weight lost when heated to a high temperature (e.g. 550°C)';

-- facet_id 6: Phosphates
update facet.facet set description = 'Concentration of phosphate compounds in a sample, often used as an indicator of past human activity.'
where facet_id = 6 and description is distinct from 'Concentration of phosphate compounds in a sample, often used as an indicator of past human activity.';

-- facet_id 12: Proxy types
update facet.facet set description = 'General type of proxy measurement (e.g. pollen, dating) used to infer aspects of the past.'
where facet_id = 12 and description is distinct from 'General type of proxy measurement (e.g. pollen, dating) used to infer aspects of the past.';

-- facet_id 29: Feature type
update facet.facet set description = 'Archaeological, geological, environmental, or cultural features associated with the excavation and samples'
where facet_id = 29 and description is distinct from 'Archaeological, geological, environmental, or cultural features associated with the excavation and samples';

-- facet_id 31: Abundance classification
update facet.facet set description = 'Type of quantification or classification system used to record presence or abundance of organisms or material properties. Examples include: presence/absence, abundance classes (e.g. rare, common, abundant), and numerical counts or measurements.'
where facet_id = 31 and description is distinct from 'Type of quantification or classification system used to record presence or abundance of organisms or material properties. Examples include: presence/absence, abundance classes (e.g. rare, common, abundant), and numerical counts or measurements.';

-- facet_id 33: Abundances
update facet.facet set description = 'Quantification of the amount (number, presence etc.) of an organism (taxon, species etc.)'
where facet_id = 33 and description is distinct from 'Quantification of the amount (number, presence etc.) of an organism (taxon, species etc.)';

-- facet_id 34: Insect activity seasons
update facet.facet set description = 'Season in which an adult insect has been observed to be active.'
where facet_id = 34 and description is distinct from 'Season in which an adult insect has been observed to be active.';

-- facet_id 35: Bibliography modern
update facet.facet set description = 'Published references associated with species descriptions or taxonomic identification literature'
where facet_id = 35 and description is distinct from 'Published references associated with species descriptions or taxonomic identification literature';

-- facet_id 36: Bibliography sites/sample groups
update facet.facet set description = 'Publications and reports associated with specific excavation sites or sample groups'
where facet_id = 36 and description is distinct from 'Publications and reports associated with specific excavation sites or sample groups';

-- facet_id 37: Bibliography sites
update facet.facet set description = 'Publications and reports directly associated with excavation sites'
where facet_id = 37 and description is distinct from 'Publications and reports directly associated with excavation sites';

-- facet_id 38: Dataset provider
update facet.facet set description = 'The institution or individual responsible for contributing a dataset to SEAD'
where facet_id = 38 and description is distinct from 'The institution or individual responsible for contributing a dataset to SEAD';

-- facet_id 39: Dataset methods
update facet.facet set description = 'The various methods and techniques used for creating, collecting or analyzing the data'
where facet_id = 39 and description is distinct from 'The various methods and techniques used for creating, collecting or analyzing the data';

-- facet_id 41: Region
update facet.facet set description = 'Modern or historical geographical or administrative region'
where facet_id = 41 and description is distinct from 'Modern or historical geographical or administrative region';

-- facet_id 42: Data types
update facet.facet set description = 'Types of data generated by an analysis or observation.'
where facet_id = 42 and description is distinct from 'Types of data generated by an analysis or observation.';

-- facet_id 43: RDB system
update facet.facet set description = 'Red Data Book systems are used to classify and document the conservation status of species and ecosystems.'
where facet_id = 43 and description is distinct from 'Red Data Book systems are used to classify and document the conservation status of species and ecosystems.';

-- facet_id 44: RDB Code
update facet.facet set description = 'Red Data Book codes provide a description of the conservation status of a species in a particular geographical area.'
where facet_id = 44 and description is distinct from 'Red Data Book codes provide a description of the conservation status of a species in a particular geographical area.';

-- facet_id 45: Modification types
update facet.facet set description = 'Types of modification to an organism (insect, seed, bone etc.), such as it being a fragment or carbonised.'
where facet_id = 45 and description is distinct from 'Types of modification to an organism (insect, seed, bone etc.), such as it being a fragment or carbonised.';

-- facet_id 46: Abundance elements
update facet.facet set description = 'The part (element) of the organism (plant or animal) that was counted.'
where facet_id = 46 and description is distinct from 'The part (element) of the organism (plant or animal) that was counted.';

-- facet_id 47: Sampling contexts
update facet.facet set description = 'The context in which the sample was collected.'
where facet_id = 47 and description is distinct from 'The context in which the sample was collected.';

-- facet_id 48: Constructions
update facet.facet set description = 'Dated timber constructions identified through dendrochronological analysis (e.g. buildings, bridges, ships)'
where facet_id = 48 and description is distinct from 'Dated timber constructions identified through dendrochronological analysis (e.g. buildings, bridges, ships)';

-- facet_id 50: Location type
update facet.facet set description = 'Administrative level of a geographic location entry (e.g. country, region, municipality)'
where facet_id = 50 and description is distinct from 'Administrative level of a geographic location entry (e.g. country, region, municipality)';

-- facet_id 52: Analysis entity ages
update facet.facet set description = 'Age range assigned to analysis entities based on dating evidence; uses range-intersection matching'
where facet_id = 52 and description is distinct from 'Age range assigned to analysis entities based on dating evidence; uses range-intersection matching';

-- facet_id 53: Dendrochronology ages (also fixes typo "dendrchronology" in existing description)
update facet.facet set description = 'Age range filter for dendrochronology, covering both estimated felling year and outermost tree ring date'
where facet_id = 53 and description is distinct from 'Age range filter for dendrochronology, covering both estimated felling year and outermost tree ring date';

-- facet_id 54: Construction purpose
update facet.facet set description = 'The intended function of a dated timber construction (e.g. residential, religious, infrastructure, naval)'
where facet_id = 54 and description is distinct from 'The intended function of a dated timber construction (e.g. residential, religious, infrastructure, naval)';

commit;
