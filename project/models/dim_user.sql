with stg_vb_users as (
    select * from {{ source('vbay','vb_users')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_vb_users.user_id']) }} as userkey, 
    stg_vb_users.* 
from stg_vb_users
