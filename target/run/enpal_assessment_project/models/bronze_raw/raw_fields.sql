
  
    

  create  table "postgres"."public_enpal_crm_analytics"."raw_fields__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    F.id, 
    F.field_key, 
    F.name, 
    F.field_value_options 
FROM "postgres"."public"."fields" F
  );
  