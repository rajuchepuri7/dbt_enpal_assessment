
  
    

  create  table "postgres"."public_pipedrive_analytics"."stages__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    S.stage_id, 
    S.stage_name
FROM POSTGRES.PUBLIC.STAGES S
  );
  