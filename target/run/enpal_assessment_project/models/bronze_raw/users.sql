
  
    

  create  table "postgres"."public_pipedrive_analytics"."users__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    U.id, 
    U.name, 
    U.email, 
    U.modified 
FROM "postgres"."public"."users" U
  );
  