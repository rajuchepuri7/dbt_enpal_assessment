
  
    

  create  table "postgres"."public_pipedrive_analytics"."stg_deal_changes_details__dbt_tmp"
  
  
    as
  
  (
    WITH DEAL_CHANGES_BASE AS (
SELECT 
    DC.deal_id, 
    DC.change_time, 
    DC.changed_field_key, 
    DC.new_value, 
    --- Group the add_time field changes
    COUNT(CASE WHEN DC.changed_field_key = 'add_time' THEN 1 END) OVER(PARTITION BY DC.deal_id ORDER BY DC.change_time) AS add_time_group, 
    --- Group the user_id field changes 
    COUNT(CASE WHEN DC.changed_field_key = 'user_id' THEN 1 END) OVER (PARTITION BY DC.deal_id ORDER BY DC.change_time) AS user_group, 
    --- Group for combined status (stage_id OR lost_reason)
    COUNT(CASE WHEN DC.changed_field_key IN ('stage_id', 'lost_reason') THEN 1 END) OVER (PARTITION BY DC.deal_id ORDER BY DC.change_time) as status_group 
FROM "postgres"."public_pipedrive_analytics"."deal_changes" DC 
), 
DEAL_CHANGES_BASE_TRANSFORM AS (
SELECT 
    DCB.deal_id,
    DCB.change_time,
    DCB.changed_field_key,
    DCB.new_value,
    -- Carry forward add_time, user_id, stage_id, lost_reason to form a record with the same value until it's next change occurs
    CAST(FIRST_VALUE(CASE WHEN DCB.changed_field_key = 'add_time' THEN DCB.new_value END) OVER (PARTITION BY DCB.deal_id, DCB.add_time_group ORDER BY DCB.change_time) AS TIMESTAMP) AS add_time, 
    COALESCE(CAST(FIRST_VALUE(CASE WHEN DCB.changed_field_key = 'user_id' THEN DCB.new_value END) OVER (PARTITION BY DCB.deal_id, DCB.user_group ORDER BY DCB.change_time) AS BIGINT), -1) AS user_id, 
    FIRST_VALUE(CASE WHEN DCB.changed_field_key IN ('stage_id', 'lost_reason') THEN DCB.changed_field_key END) OVER (PARTITION BY DCB.deal_id, DCB.status_group ORDER BY DCB.change_time) AS deal_status_type, 
    CAST(FIRST_VALUE(CASE WHEN DCB.changed_field_key IN ('stage_id', 'lost_reason') THEN DCB.new_value END) OVER (PARTITION BY DCB.deal_id, DCB.status_group ORDER BY DCB.change_time) AS INT) AS deal_status_value 
FROM DEAL_CHANGES_BASE DCB
ORDER BY 
    DCB.deal_id, 
    DCB.change_time
)
SELECT 
    BT.deal_id, 
    BT.change_time, 
    BT.changed_field_key, 
    BT.new_value, 
    BT.add_time, 
    BT.user_id, 
    BT.deal_status_type, 
    BT.deal_status_value, 
    U.name AS user_name, 
    U.email AS user_email, 
    S.stage_name, 
    CAST(DATE_PART('YEAR', BT.change_time) AS INT) AS change_year, 
    CAST(DATE_PART('MONTH', BT.change_time) AS INT) AS change_month 
FROM DEAL_CHANGES_BASE_TRANSFORM BT
LEFT JOIN "postgres"."public_pipedrive_analytics"."users" U 
    ON U.id = BT.user_id 
LEFT JOIN (SELECT 'stage_id' AS status_type, stage_id, stage_name FROM "postgres"."public_pipedrive_analytics"."stages"
           
           UNION 
           
           SELECT 'lost_reason' AS status_type, reason_id, reason_label FROM "postgres"."public_pipedrive_analytics"."stg_lost_reasons" 
          ) S 
    ON S.status_type = COALESCE(BT.deal_status_type, 'XXXX') 
    AND S.stage_id = COALESCE(BT.deal_status_value, 0) 
ORDER BY 
    BT.deal_id, 
    BT.change_time
  );
  