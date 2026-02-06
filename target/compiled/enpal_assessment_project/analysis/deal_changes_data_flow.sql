--- Understand the flow of the changes for a deal 
--- Enrich the record with releavant data elements from other tables which can help deduce the insights as needed
--- Identify the approach to persist the value of an attribute until it's next possible change
--- Don't mix it with other attributes for which would like do the same 
--- Since it's starts with deal creation, at that point of time there might not be a user assigned to it
--- populate -1 until an actual user / owner is assinged to fill the gap
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
FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_DEAL_CHANGES DC 
WHERE deal_id = 399956
)
SELECT * FROM DEAL_CHANGES_BASE 


--- Next step to where actual enrichment happens
/**
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
**/