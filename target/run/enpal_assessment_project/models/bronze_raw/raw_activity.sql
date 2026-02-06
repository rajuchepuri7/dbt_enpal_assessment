
  
    

  create  table "postgres"."public_enpal_crm_analytics"."raw_activity__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    A.activity_id, 
    A.type,  
    A.assigned_to_user, 
    A.deal_id, 
    A.done, 
    A.due_to 
FROM "postgres"."public"."activity" A
  );
  