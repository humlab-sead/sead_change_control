-- Deploy ceramics: 20221205_DML_CERAMICS_METHOD_ID_UPDATE

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


    update tbl_ceramics_lookup
        set method_id = 172
    where name in (
		'Firing temperature(min)',
		'Melting point', 'Firing atmosphere'
	  ) and method_id <> 172;
            
    update tbl_ceramics_lookup
        set method_id = 171
    where name in (
        'Clay: Coarseness',
        'Clay: Sorting',
        'Clay: Silt',
        'Clay: Sand',
        'Clay: Calcarbon',
        'Clay: Ironoxide',
        'Clay: Limonite',
        'Clay: Mica',
        'Clay: Fossil',
        'Clay: Spongie',
        'Clay: Diatome', 
        'Clay: Organic', 
        'Clay: Ore', 
        'Tempering: Granite', 
        'Tempering: Rock', 
        'Tempering: Sand',
        'Tempering: Chamotte', 
        'Tempering: Asbestos', 
        'Tempering: Calcarbon', 
        'Tempering: Bone', 
        'Tempering: Organic', 
        'Tempering: Natural', 
        'Tempering: Accessory', 
        'Tempering: Max Grain Size',
        '% - Tempering'
    ) and method_id <> 171;

end $$;
commit;
