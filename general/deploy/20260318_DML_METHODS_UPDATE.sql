-- Deploy general: 20260318_DML_METHODS_UPDATE

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-03-18
  Description   Update tbl_methods: fix descriptions and abbreviations for methods 32, 33, 35, 36, 37, 74, 94 based on input from Johan Linderholm.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/416
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Source: change_data/Kopia av sead-group-2-methods_JL.csv
                Changes:
                  method 32  - description extended to include "550C for three hours"
                  method 33  - description extended to include "volume specific"
                  method 35  - abbrev corrected MS-lo → MS-lf, description extended
                  method 36  - abbrev corrected MS-hi → MS-hf, description extended
                  method 37  - abbrev corrected P° → CitP, description unit updated
                  method 74  - abbrev corrected citPtot → CitPOI
                  method 94  - abbrev corrected P°HCL → CitP HCl
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

begin;

-- method 32: Loss on ignition — extend description
update tbl_methods set
    description = E'An evaluation of the proportion of organic matter present in a sample, measured by comparing pre-burnt and post-burnt sample weights.\nStandard method: 550C for three hours.'
where method_id = 32
  and description is distinct from E'An evaluation of the proportion of organic matter present in a sample, measured by comparing pre-burnt and post-burnt sample weights.\nStandard method: 550C for three hours.';

-- method 33: Magnetic susceptibility — extend description
update tbl_methods set
    description = 'A measurement of the ability of a sample to retain an induced magnetic field. Volume specific.'
where method_id = 33
  and description is distinct from 'A measurement of the ability of a sample to retain an induced magnetic field. Volume specific.';

-- method 35: MS Low frequency — fix abbrev MS-lo → MS-lf, extend description
update tbl_methods set
    method_abbrev_or_alt_name = 'MS-lf',
    description = 'A measurement of the ability of a sample to retain a low frequency induced magnetic field. Weight- and volume specific.'
where method_id = 35
  and (method_abbrev_or_alt_name is distinct from 'MS-lf'
    or description is distinct from 'A measurement of the ability of a sample to retain a low frequency induced magnetic field. Weight- and volume specific.');

-- method 36: MS High frequency — fix abbrev MS-hi → MS-hf, extend description
update tbl_methods set
    method_abbrev_or_alt_name = 'MS-hf',
    description = 'A measurement of the ability of a sample to retain a high frequency induced magnetic field. Weight- and volume specific.'
where method_id = 36
  and (method_abbrev_or_alt_name is distinct from 'MS-hf'
    or description is distinct from 'A measurement of the ability of a sample to retain a high frequency induced magnetic field. Weight- and volume specific.');

-- method 37: Phosphate degrees — fix abbrev P° → CitP, update description unit
update tbl_methods set
    method_abbrev_or_alt_name = 'CitP',
    description = 'Amount of phosphates. Standard method: Inorganic phosphate content. Extraction by citric acid (2%). Based on Arrhenius and further developed by EAL. The amount of phosphate is specified as mg P*kg-1.'
where method_id = 37
  and (method_abbrev_or_alt_name is distinct from 'CitP'
    or description is distinct from 'Amount of phosphates. Standard method: Inorganic phosphate content. Extraction by citric acid (2%). Based on Arrhenius and further developed by EAL. The amount of phosphate is specified as mg P*kg-1.');

-- method 74: Total phosphates citric acid — fix abbrev citPtot → CitPOI
update tbl_methods set
    method_abbrev_or_alt_name = 'CitPOI'
where method_id = 74
  and method_abbrev_or_alt_name is distinct from 'CitPOI';

-- method 94: Phosphate degrees HCL — fix abbrev P°HCL → CitP HCl
update tbl_methods set
    method_abbrev_or_alt_name = 'CitP HCl'
where method_id = 94
  and method_abbrev_or_alt_name is distinct from 'CitP HCl';

commit;
