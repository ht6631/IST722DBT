with f_item as (
    select * from {{ ref('fact_item') }}
),
d_user as (
    select * from {{ ref('dim_user') }}
),
d_type as (
    select * from {{ ref('dim_type') }}
)
select 
    seller.userkey as sellerkey, seller.user_id as sellerid,seller.user_email as selleremail,concat(seller.user_lastname,',',seller.user_firstname) as sellername,seller.user_zip_code as seellerzipcode,
    buyer.userkey as buyerkey, buyer.user_id as buyerid, buyer.user_email as buyeremail, concat(buyer.user_lastname, ',', buyer.user_firstname) as buyername, buyer.user_zip_code as buyerzipcode,
    d_type.*, 
    f.itemid, f.itemreserve, f.itemsold,f.itemsoldamount,f.totalbidcount,f.bidamountrange,f.bidokpercentage,f.biddercounts
    from f_item as f
    left join d_user seller on f.sellerkey = seller.userkey
    left join d_user buyer on f.buyerkey = buyer.userkey
    left join d_type on f.typekey = d_type.typekey

