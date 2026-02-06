--- activity_types raw data load into bronze layer
SELECT 
    AP.id, 
    AP.name, 
    AP.active, 
    AP.type
FROM "postgres"."public"."activity_types" AP