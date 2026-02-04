

SELECT 
    AP.id, 
    AP.name, 
    AP.active, 
    AP.type
FROM {{ source('postgres_public', 'activity_types') }} AP 