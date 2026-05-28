-- Revert general:20260318_DML_METHODS_UPDATE

BEGIN;

-- method 32: Loss on ignition — restore original description
UPDATE tbl_methods SET
    description = E'An evaluation of the proportion of organic matter present in a sample, measured by comparing pre-burnt and post-burnt sample weights.\nStandard method:'
WHERE method_id = 32;

-- method 33: Magnetic susceptibility — restore original description
UPDATE tbl_methods SET
    description = 'A measurement of the ability of a sample to retain an induced magnetic field.'
WHERE method_id = 33;

-- method 35: MS Low frequency — restore abbrev MS-lf → MS-lo, restore description
UPDATE tbl_methods SET
    method_abbrev_or_alt_name = 'MS-lo',
    description = 'A measurement of the ability of a sample to retain a low frequency induced magnetic field.'
WHERE method_id = 35;

-- method 36: MS High frequency — restore abbrev MS-hf → MS-hi, restore description
UPDATE tbl_methods SET
    method_abbrev_or_alt_name = 'MS-hi',
    description = 'A measurement of the ability of a sample to retain a high frequency induced magnetic field.'
WHERE method_id = 36;

-- method 37: Phosphate degrees — restore abbrev CitP → P°, restore description unit
UPDATE tbl_methods SET
    method_abbrev_or_alt_name = 'P°',
    description = 'Amount of phosphates. Standard method: Inorganic phosphate content. Extraction by citric acid (2%). Based on Arrhenius and further developed by EAL. The amount of phosphate is specified as mg P2O5/100g dry soil.'
WHERE method_id = 37;

-- method 74: Total phosphates citric acid — restore abbrev CitPOI → citPtot
UPDATE tbl_methods SET
    method_abbrev_or_alt_name = 'citPtot'
WHERE method_id = 74;

-- method 94: Phosphate degrees HCL — restore abbrev CitP HCl → P°HCL
UPDATE tbl_methods SET
    method_abbrev_or_alt_name = 'P°HCL'
WHERE method_id = 94;

COMMIT;
