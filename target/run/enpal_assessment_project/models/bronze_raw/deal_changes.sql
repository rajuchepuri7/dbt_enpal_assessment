
  
    

  create  table "postgres"."public_pipedrive_analytics"."deal_changes__dbt_tmp"
  
  
    as
  
  (
    


SELECT 
    DC.deal_id, 
    DC.change_time, 
    DC.changed_field_key, 
    DC.new_value 
FROM POSTGRES.PUBLIC.DEAL_CHANGES DC
  );
  