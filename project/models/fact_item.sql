-- fact_item extract
WITH BidDetails AS (
    SELECT
        bid_item_id
        ,COUNT(bid_user_id) AS totalbidcount
        ,MAX(bid_amount) - MIN(bid_amount) AS bidamountrange
        ,COUNT(DISTINCT bid_user_id) AS biddercounts
        ,round(cast(SUM(bid_status_numeric) as float)/cast(COUNT(bid_user_id) as float),2) AS bidokpercentage
    FROM
        (
            select *,
                CASE WHEN bid_status = 'ok' THEN 1 ELSE 0 END as bid_status_numeric
            from {{source('vbay','vb_bids')}}
        ) as vb_bids_plus
    GROUP BY
        bid_item_id
)
SELECT
    vi.item_id AS itemid
    ,{{ dbt_utils.generate_surrogate_key(['du_seller.user_id']) }} as sellerkey
    ,{{ dbt_utils.generate_surrogate_key(['du_buyer.user_id']) }} as buyerkey
    ,{{ dbt_utils.generate_surrogate_key(['dt.item_type']) }} AS typekey
    ,vi.item_reserve AS itemreserve
    ,vi.item_sold AS itemsold
    ,coalesce(vi.item_soldamount,0) AS itemsoldamount
    ,coalesce(bd.totalbidcount,-999) as totalbidcount
    ,coalesce(bd.bidamountrange,-999) as bidamountrange
    ,coalesce(bd.bidokpercentage,-999) as bidokpercentage
    ,coalesce(bd.biddercounts,-999) as biddercounts
FROM
    {{source('vbay','vb_items')}} vi
    LEFT JOIN {{source('vbay','vb_users')}} du_seller ON vi.item_seller_user_id = du_seller.user_id
    LEFT JOIN {{source('vbay','vb_users')}} du_buyer ON vi.item_buyer_user_id = du_buyer.user_id
    LEFT JOIN {{source('vbay','vb_item_types_lookup')}} dt ON vi.item_type = dt.item_type
    LEFT JOIN BidDetails bd ON vi.item_id = bd.bid_item_id