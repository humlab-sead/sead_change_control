-- Deploy sead_model: 20240924_DML_MEASURED_VALUES_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-09-24
  Description   Initial generic metadata for analysis values
  Issue         https://github.com/humlab-sead/sead_change_control/issues/330
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    -- Inital set of value types for analysis values (based on dendro import lookups 2024-09-24)
    
    with new_data ("value_type_id", "unit_id", "data_type_id", "name", "base_type", "precision", "description") as (
        values
            (0, null, null, 'Not used', 'text', null, 'Not used'),
            (1, null, '5', 'Count', 'integer', null, 'An (positive) integer result of an analysis'),
            (2, null, '5', 'BigCount', 'integer', null, 'An (positive) integer result of an analysis'),
            (3, null, null, 'Boolean', 'boolean', null, 'A boolean (true/false/yes,no) value'),
            (4, null, '20', 'Percentage', 'decimal', null, 'Percentage of something'),
            (5, null, null, 'Age in years', 'integer', null, 'Age of something in years'),
            (6, '8', null, 'Year', 'integer', null, 'A calendar year'),
            (7, null, null, 'Note', 'text', null, 'A note of something'),
            (8, null, null, 'Label', 'text', null, 'A designation of something'),
            (9, null, null, 'Identifier', 'text', null, 'An identification of something'),
            (10, '8', null, 'Year range', 'int4range', null, 'A range of years'),
            (11, null, '8', 'Measurement', 'decimal', null, 'A decimal measurement result of an analysis.')
        )
    	    insert into tbl_value_types ("value_type_id", "unit_id", "data_type_id", "name", "base_type", "precision", "description")
            select "value_type_id", "unit_id"::int, "data_type_id"::int, "name", "base_type", "precision"::int, "description"
            from new_data;


    with new_data("symbol", "description") as (
        values
            ('<', 'Less than. The value is smaller than the compared value.'),
            ('>', 'Greater than. The value is larger than the compared value.'),
            ('=', 'Equal to. The value is exactly equal to the compared value.'),
            ('<=', 'Less than or equal to. The value is smaller than or equal to the compared value.'),
            ('>=', 'Greater than or equal to. The value is larger than or equal to the compared value.'),
            ('~<=', 'Approximately less than or equal to (informal, text-friendly)'),
            ('~>=', 'Approximately greater than or equal to the compared value.'),
            ('~', 'Approximately equal to. The value is roughly around the compared value, but not exact.'),
            ('≈', 'Almost equal to. The value is very close to the compared value but may not be exactly the same.'),
            ('≠', 'Not equal to. The value is different from the compared value.'),
            ('±', 'Plus-minus. Indicates a value range where the actual value could be either greater or smaller by a specific amount.'),
            ('≈ but ≠', 'Almost equal to but not the same. The value is very close to the compared value but not be exactly the same.'),
            ('≃', 'The value might be the same as the compared value (or asymptotically equal to or).')
            -- ('≍', 'Equivalence in an approximate or qualitative sense'),
            -- ('≈≤', 'Roughly less than or equal to'),
            -- ('≈≥', 'Roughly greater than or equal to'),
            -- ('⪅', 'Less than or equal to with approximation (e.g., less than or similar to)'),
            -- ('⪆', 'Greater than or equal to with approximation'),
            -- ('≐', 'Almost equal to but not he same (sometimes used to show close but not identical values)'),
            -- ('≅', 'Approximately congruent to. Often used in geometry to represent values that are congruent or similar.'),
            -- ('≈', 'Approximately equal to'),
            -- ('≉', 'Not approximately equal to'),
            -- ('≅', 'Congruent to (often used for "approximately equal" in a looser sense)'),
            -- ('∼', 'Similar to or roughly equal to'),
            -- ('≲', 'Precedes or is approximately less than'),
            -- ('≳', 'Succeeds or is approximately greater than'),
            -- ('⩽', 'Less than or asymptotically equal to'),
            -- ('⩾', 'Greater than or asymptotically equal to'),
            -- ('⊆', 'Subset of (can imply that one set of values is within another)'),
            -- ('⊂', 'Proper subset of (sometimes used for strict inclusion in ranges)'),
            -- ('⊇', 'Superset of (used for containing another set or range)'),
            -- ('⊃', 'Proper superset of'),
            -- ('∈', 'Element of (to show inclusion within a set or interval)'),
            -- ('∉', 'Not an element of'),

        )
        insert into tbl_value_qualifiers ("symbol", "description")
            select "symbol", "description"
            from new_data
              on conflict ("symbol") do
                update set "description" = excluded."description";
                        
    with new_data("cardinal_symbol", "aliases") as (
        values
            ('<', array['less than', 'mindre än', 'före', 'to']),
            ('>', array['more than', 'mer än', 'efter']),
            ('=', array['equal to', 'lika med']),
            ('<=', array['at most', 'max', 'högst']),
            ('>=', array['at least', 'min', 'minst', 'from']),
            ('~<=', array['to ca.', '≈≤']),
            ('~>=', array['from ca.', '⪆']),
            ('~', array['close to', '∼', '≈', 'ca', 'ca.']),
            ('≠', array['not equal to', 'skiljt från']),
            ('±', array['plus/minus']),
            ('≈ but ≠', array['≐', 'nära']),
            ('≃', array['eventuellt'])
        )

        insert into tbl_value_qualifier_symbols ("symbol", "cardinal_symbol")
            select unnest(aliases) as symbol, "cardinal_symbol"
            from new_data
            union
            select "cardinal_symbol", "cardinal_symbol"
            from new_data;

end $$;
commit;