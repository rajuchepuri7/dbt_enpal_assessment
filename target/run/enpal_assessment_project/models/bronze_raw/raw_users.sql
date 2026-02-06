
  
    

  create  table "postgres"."public_enpal_crm_analytics"."raw_users__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    U.id, 
    U.name, 
    U.email, 
    U.modified 
FROM "postgres"."public"."users" U
  );
  