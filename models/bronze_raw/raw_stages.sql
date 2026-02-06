

SELECT 
    S.stage_id, 
    S.stage_name
FROM {{ source ('postgres_public', 'stages') }} S 