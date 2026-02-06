
  
    

  create  table "postgres"."public_enpal_crm_analytics"."raw_activity_types__dbt_tmp"
  
  
    as
  
  (
    --- activity_types raw data load into bronze layer
SELECT 
    AP.id, 
    AP.name, 
    AP.active, 
    AP.type
FROM "postgres"."public"."activity_types" AP
  );
  