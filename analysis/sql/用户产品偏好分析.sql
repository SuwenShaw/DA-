-- 用户产品偏好分析
-- 访问量前十的产品，以及它们的访问量、购买量、收藏加购率、购买率
select sku_code,
       pv,
       buy,
       concat(round((fav + cart) / pv * 100, 2), '%') as pv_to_favcart,
       concat(round(buy / pv * 100, 2), '%')          as pv_to_buy
from (
    -- 筛选访问量前十的产品
         select sku_code, count(url) as pv
         from (
                  select sku_code, url
                  from web_action_log
                  union all
                  select sku_code, url
                  from app_action_log
              ) as temp
         group by sku_code
         order by pv desc
         limit 10
     ) as t1
         left join (
    -- 各产品的收藏、加购量
    select sku_code,
           sum(case when action_type = 'fav' then 1 else 0 end)  as fav,
           sum(case when action_type = 'cart' then 1 else 0 end) as cart
    from behavior_log
    group by sku_code
) as t2
                   on t1.sku_code = t2.sku_code
         left join (
    -- 各产品的购买量
    select sku_code,
           count(order_detail_no) as buy
    from dim_order_info as m_order
             inner join fact_order_detail_info as detail
                        on detail.order_no = m_order.order_no
    group by sku_code
) as t3
                   on t1.sku_code = t3.sku_code
;

-- 销量前十的产品,以及它们的访问量、收藏加购量、购买量、转化率
select sku_code,
       pv,
       fav + cart,
       buy,
       concat(round(buy / pv * 100, 2), '%')           as pv_to_buy,
       concat(round(buy / (fav + cart) * 100, 2), '%') as favcart_to_buy
from (
         -- 各产品的访问量
         select sku_code, count(url) as pv
         from (
                  select sku_code, url
                  from web_action_log
                  union all
                  select sku_code, url
                  from app_action_log
              ) as temp
     ) as t1
         left join (
    -- 各产品的收藏、加购量
    select sku_code,
           sum(case when action_type = 'fav' then 1 else 0 end)  as fav,
           sum(case when action_type = 'cart' then 1 else 0 end) as cart
    from behavior_log
    group by sku_code
) as t2
                   on t1.sku_code = t2.sku_code
         left join (
    -- 筛选出购买量前十的产品
    select sku_code,
           count(order_detail_no) as buy
    from dim_order_info as m_order
             inner join fact_order_detail_info as detail
                        on detail.order_no = m_order.order_no
    group by sku_code
    order by buy desc
    limit 10
) as t3
                   on t1.sku_code = t3.sku_code
;
