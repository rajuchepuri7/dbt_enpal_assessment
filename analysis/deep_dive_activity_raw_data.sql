
--- Check whether the duplicate activity_id exist or not
SELECT 
    activity_id, 
    COUNT(*) AS CNT 
FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_ACTIVITY
GROUP BY 
    activity_id
HAVING COUNT(*) > 1 

--- Duplicate activity_id details 
/**
SELECT 
    * 
FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_ACTIVITY
WHERE activity_id IN (521731, 
332746, 
283914, 
370773, 
818588, 
855539, 
206894, 
835226, 
488221, 
283308,
500358) ORDER BY activity_id 
**/
