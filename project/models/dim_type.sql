with stg_vb_item as (
    select * from {{ source('vbay','vb_item_types_lookup')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_vb_item.item_type']) }} as typekey, 
    stg_vb_item.* 
from stg_vb_item
