
  
    

  create  table "postgres"."public_pipedrive_analytics"."activity__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    A.activity_id, 
    A.type,  
    A.assigned_to_user, 
    A.deal_id, 
    A.done, 
    A.due_to 
FROM POSTGRES.PUBLIC.ACTIVITY A
  );
  