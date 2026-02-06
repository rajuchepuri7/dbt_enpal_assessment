
--- Remove the duplicate activities (assuming that activity_id can't be same for different deal and user_id/owner) 
--- prioritize based on 'done' status (TRUE, FALSE) and due_to to keep the activity_id unique 
--- sample duplicate acitivity_id's - 206894, 283308, 283914, 332746, 370773 
--- map the stage_name to the activity_type 
--- derive the year and month from 'due_to'

WITH ACTIVITY_BASE AS (
SELECT 
    A.activity_id, 
    A.type, 
    A.assigned_to_user, 
    A.deal_id, 
    A.done, 
    A.due_to, 
    AT.id AS activity_type_id, 
    AT.name AS activity_name,  
    CASE 
	    A.type 
    	WHEN 'meeting' THEN 'Sales Call 1' 
    	WHEN 'sc_2' THEN 'Sales Call 2' 
    	WHEN 'follow_up' THEN 'Follow-up/Customer Success' 
    	WHEN 'after_close_call' THEN 'Closing'
    END AS stage_name,  
    U.name AS user_name, 
    U.email AS user_email, 
    DATE_PART('YEAR', due_to) AS year, 
    DATE_PART('MONTH', due_to) AS month,  
    ROW_NUMBER() OVER(PARTITION BY A.activity_id ORDER BY A.done DESC, A.due_to) AS ranking
FROM {{ ref('raw_activity') }} A
LEFT JOIN {{ ref('raw_activity_types') }} AT 
    ON AT.type = A.type 
LEFT JOIN {{ ref('raw_users') }} U 
    ON U.id = A.assigned_to_user 
) 
SELECT 
    AB.activity_id, 
    AB.type, 
    AB.assigned_to_user, 
    AB.deal_id, 
    AB.done, 
    AB.due_to, 
    AB.activity_type_id, 
    AB.activity_name,  
    AB.stage_name, 
    AB.user_name, 
    AB.user_email, 
    AB.year, 
    AB.month  
FROM ACTIVITY_BASE AB 
WHERE AB.ranking = 1  --- remove duplicate based on the priority logic / assumption 