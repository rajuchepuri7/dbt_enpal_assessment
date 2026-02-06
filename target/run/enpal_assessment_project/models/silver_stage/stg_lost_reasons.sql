
  
    

  create  table "postgres"."public_enpal_crm_analytics"."stg_lost_reasons__dbt_tmp"
  
  
    as
  
  (
    SELECT 
    CAST(item->>'id' AS SMALLINT) as reason_id,
    item->>'label' as reason_label
FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_FIELDS F, 
LATERAL jsonb_array_elements(F.field_value_options) AS item 
WHERE F.field_key = 'lost_reason'
  );
  