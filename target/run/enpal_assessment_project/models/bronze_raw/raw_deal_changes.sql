
  
    

  create  table "postgres"."public_enpal_crm_analytics"."raw_deal_changes__dbt_tmp"
  
  
    as
  
  (
    


SELECT 
    DC.deal_id, 
    DC.change_time, 
    DC.changed_field_key, 
    DC.new_value 
FROM "postgres"."public"."deal_changes"DC
  );
  