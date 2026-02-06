

SELECT 
    U.id, 
    U.name, 
    U.email, 
    U.modified 
FROM {{ source('postgres_public', 'users') }} U 