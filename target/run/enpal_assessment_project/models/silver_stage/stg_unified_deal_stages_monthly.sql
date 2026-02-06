
  
    

  create  table "postgres"."public_enpal_crm_analytics"."stg_unified_deal_stages_monthly__dbt_tmp"
  
  
    as
  
  (
    --- There are very minimal number of deals (less than 10) that are common between ACTIVITY & DEAL_CHANGES source tables 
--- Ignoring them for now from the calculation, as there isn't a clear path on how to handle them  
--- deals from DEAL_CHANGES that are not in ACTIVITY 
WITH FINAL_BASE_1 AS (
SELECT 
    DCD.deal_id, 
    DCD.change_time, 
    DCD.changed_field_key, 
    DCD.new_value, 
    DCD.add_time, 
    DCD.user_id, 
    DCD.deal_status_type, 
    DCD.deal_status_value, 
    DCD.user_name, 
    DCD.user_email, 
    DCD.stage_name, 
    DCD.change_year, 
    DCD.change_month, 
    CONCAT('Step ', DCD.deal_status_value, ': ') AS funnel_step, 
    ROW_NUMBER() OVER (PARTITION BY DCD.deal_id, DCD.change_year, DCD.change_month ORDER BY DCD.deal_status_value DESC) AS ranking 
FROM "postgres"."public_enpal_crm_analytics"."stg_deal_changes_detail" DCD
WHERE DCD.changed_field_key = 'stage_id' 
    AND DCD.deal_id NOT IN (SELECT deal_id FROM "postgres"."public_enpal_crm_analytics"."stg_activity_detail" GROUP BY deal_id) 
), 
--- deals from ACTIVITY that are not in DEAL_CHANGES 
FINAL_BASE_2 AS (
SELECT  
    AD.activity_id, 
    AD.type, 
    AD.assigned_to_user AS user_id, 
    AD.deal_id, 
    AD.done, 
    AD.due_to, 
    AD.activity_type_id, 
    AD.activity_name,  
    AD.stage_name, 
    AD.user_name, 
    AD.user_email, 
    AD.year, 
    AD.month,   
    CASE 
    	WHEN AD.activity_type_id = 1 THEN 'Step 2.1: '
    	WHEN AD.activity_type_id = 2 THEN 'Step 3.1: '
    	WHEN AD.activity_type_id = 3 THEN 'Step 8: ' 
    	WHEN AD.activity_type_id = 4 THEN 'Step 6: '
    END AS funnel_step, 
    ROW_NUMBER() OVER(PARTITION BY AD.deal_id, AD.year, AD.month ORDER BY AD.activity_type_id DESC) AS ranking 
FROM "postgres"."public_enpal_crm_analytics"."stg_activity_detail" AD 
WHERE AD.deal_id NOT IN (SELECT deal_id FROM "postgres"."public_enpal_crm_analytics"."stg_deal_changes_detail" GROUP BY deal_id)
)
SELECT 
    FB1.change_year, 
    FB1.change_month, 
    CONCAT(CAST(FB1.change_year AS TEXT), '-', (CASE WHEN FB1.change_month < 10 THEN CONCAT('0', CAST(FB1.change_month AS TEXT)) ELSE CAST(FB1.change_month AS TEXT) END)) AS year_month, 
    FB1.deal_id, 
    FB1.funnel_step, 
    FB1.stage_name 
FROM FINAL_BASE_1 FB1
WHERE ranking = 1  -- eliminate the double count of a deal with more than one stge change in a month

UNION 

SELECT 
    FB2.year,
    FB2.month, 
    CONCAT(CAST(FB2.year AS TEXT), '-', (CASE WHEN FB2.month < 10 THEN CONCAT('0', CAST(FB2.month AS TEXT)) ELSE CAST(FB2.month AS TEXT) END)) AS year_month, 
    FB2.deal_id, 
    FB2.funnel_step, 
    FB2.stage_name 
FROM FINAL_BASE_2 FB2  
WHERE ranking = 1
  );
  