SELECT 
    CAST(item->>'id' AS SMALLINT) as reason_id,
    item->>'label' as reason_label
FROM "postgres"."public_pipedrive_analytics"."fields" F, 
LATERAL jsonb_array_elements(F.field_value_options) AS item 
WHERE F.field_key = 'lost_reason'