with stg_products as (
    select * from {{ source('northwind','Products')}}
)
,
stg_categories as (
    select * from {{ source('northwind','Categories')}}
),
temp_table as (
    select * from
    stg_products p 
    join stg_categories c on
    p.CategoryID = c.CategoryID
)
SELECT {{ dbt_utils.generate_surrogate_key(['temp_table.productid']) }} as ProductKey,
    ProductID, ProductName, SupplierID
    ,CategoryName, Description as CategoryDescription
  FROM temp_table

