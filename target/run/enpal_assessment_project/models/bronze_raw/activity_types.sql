
  
    

  create  table "postgres"."public_pipedrive_analytics"."activity_types__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    AP.id, 
    AP.name, 
    AP.active, 
    AP.type
FROM "postgres"."public"."activity_types" AP
  );
  