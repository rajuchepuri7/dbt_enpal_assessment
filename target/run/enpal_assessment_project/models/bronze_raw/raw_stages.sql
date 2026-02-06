
  
    

  create  table "postgres"."public_enpal_crm_analytics"."raw_stages__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    S.stage_id, 
    S.stage_name
FROM "postgres"."public"."stages" S
  );
  