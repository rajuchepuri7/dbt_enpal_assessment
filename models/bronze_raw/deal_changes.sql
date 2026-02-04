

{{
    config( materialized = 'table')
}}


SELECT 
    DC.deal_id, 
    DC.change_time, 
    DC.changed_field_key, 
    DC.new_value 
FROM {{ source('postgres_public', 'deal_changes') }}DC 