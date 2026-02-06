
--- deals count by each month with funnel_step and stage
SELECT 
    UDS.year_month AS month, 
    UDS.funnel_step, 
    UDS.stage_name AS kpi_name, 
    COUNT(UDS.deal_id) AS deals_count
FROM POSTGRES.PUBLIC_PIPEDRIVE_ANALYTICS.STG_UNIFIED_DEAL_STAGES_MONTHLY UDS
GROUP BY 
    UDS.year_month, 
    UDS.funnel_step, 
    UDS.stage_name 
ORDER BY 
    UDS.year_month, 
    UDS.funnel_step 