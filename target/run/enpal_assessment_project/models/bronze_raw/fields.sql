
  
    

  create  table "postgres"."public_pipedrive_analytics"."fields__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    F.id, 
    F.field_key, 
    F.name, 
    F.field_value_options 
FROM "postgres"."public"."fields" F
  );
  