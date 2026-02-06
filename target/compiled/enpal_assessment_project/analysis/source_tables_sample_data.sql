--- View sample data from source tables  
SELECT 
    A.activity_id, 
    A.type,  
    A.assigned_to_user, 
    A.deal_id, 
    A.done, 
    A.due_to 
FROM POSTGRES.PUBLIC.ACTIVITY A 
--- LIMIT 10 

/**
--- Actiivty Types
SELECT 
    AT.id, 
    AT.name, 
    AT.active, 
    AT.type
FROM POSTGRES.PUBLIC.ACTIVITY_TYPES AT 

SELECT 
    DC.deal_id, 
    DC.change_time, 
    DC.changed_field_key, 
    DC.new_value 
FROM POSTGRES.PUBLIC.DEAL_CHANGES DC 

SELECT 
    F.id, 
    F.field_key, 
    F.name, 
    F.field_value_options 
FROM POSTGRES.PUBLIC.FIELDS F 

SELECT 
    S.stage_id, 
    S.stage_name
FROM POSTGRES.PUBLIC.STAGES S  

SELECT 
    U.id, 
    U.name, 
    U.email, 
    U.modified 
FROM POSTGRES.PUBLIC.USERS U 
*/