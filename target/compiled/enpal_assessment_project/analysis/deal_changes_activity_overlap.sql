--- Check whethe any common deals exist between deal_flow & activity data
--- Identify if there is any relevance between them 
--- plan for the next steps to handle them depending on impact & outcome 

SELECT 
    *  
FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_ACTIVITY 
WHERE deal_id NOT IN (SELECT 
                          DISTINCT deal_id 
                      FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_DEAL_CHANGES
                     ) --- AND done = FALSE 

/**
SELECT 
    *  
FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_DEAL_CHANGES
WHERE deal_id NOT IN (SELECT 
                          DISTINCT deal_id 
                      FROM POSTGRES.PUBLIC_ENPAL_CRM_ANALYTICS.RAW_ACTIVITY 
                     )
**/ 

--- SELECT * FROM ACTIVITY WHERE deal_id = 149371; 

--- SELECT * FROM DEAL_CHANGES WHERE deal_id = 149371;