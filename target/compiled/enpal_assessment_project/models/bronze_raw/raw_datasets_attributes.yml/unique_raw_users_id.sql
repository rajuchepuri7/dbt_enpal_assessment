
    
    

select
    id as unique_field,
    count(*) as n_records

from "postgres"."public_enpal_crm_analytics"."raw_users"
where id is not null
group by id
having count(*) > 1


