-- 用户行为漏斗分析
-- PV（访问量）
select count(url) as 总访问量
from (
         select url
         from web_action_log
         union all
         select url
         from app_action_log
     ) as temp
;

-- fav（收藏）、cart（加购物车）
select sum(case when action_type='fav' then 1 else 0 end) as 总收藏量,
       sum(case when action_type='cart' then 1 else 0 end) as 总加购量
       from behavior_log
;

-- buy（购买）
select count(order_detail_no) as 总购买量
from dim_order_info as m_order
         inner join fact_order_detail_info as detail
                    on detail.order_no = m_order.order_no
;

-- 用户总访问、收藏、加购、购买量
-- method1
select sum(pv) as sum_pv, sum(fav) as sum_fav, sum(cart) as sum_cart, sum(buy) as sum_buy
from (
     -- PV（访问量）
         select user_id, count(url) as pv
         from (
                  select user_id, url
                  from web_action_log
                  union all
                  select user_id, url
                  from app_action_log
              ) as temp
         group by user_id
     ) as t1
         left join (
    -- fav（收藏）、cart（加购物车）
    select user_id,
           sum(case when action_type = 'fav' then 1 else 0 end)  as fav,
           sum(case when action_type = 'cart' then 1 else 0 end) as cart
    from behavior_log
    group by user_id
) as t2
                   on t1.user_id = t2.user_id
         left join (
    -- buy（购买）
    select person_id,
           count(order_detail_no) as buy
    from dim_order_info as m_order
             inner join fact_order_detail_info as detail
                        on detail.order_no = m_order.order_no
    group by person_id
) as t3
                   on t1.user_id = t3.person_id
;

-- method2
select sum_pv, sum_fav, sum_cart, sum_buy
from (
    -- PV（访问量）
         select 'key' as t_key, count(url) as sum_pv
         from (
                  select url
                  from web_action_log
                  union all
                  select url
                  from app_action_log
              ) as temp
     ) as t1
         left join (
    -- fav（收藏）、cart（加购物车）
    select 'key'                                                 as t_key,
           sum(case when action_type = 'fav' then 1 else 0 end)  as sum_fav,
           sum(case when action_type = 'cart' then 1 else 0 end) as sum_cart
    from behavior_log
) as t2
                   on t1.t_key = t2.t_key
         left join (
    -- buy（购买）
    select 'key'                  as t_key,
           count(order_detail_no) as sum_buy
    from dim_order_info as m_order
             inner join fact_order_detail_info as detail
                        on detail.order_no = m_order.order_no
) as t3
                   on t1.t_key = t3.t_key
;

-- 用户各行为转化率
-- method1
select concat(round(sum_pv / sum_pv * 100, 2), '%')                as pv_to_pv,
       concat(round((sum_fav + sum_cart) / sum_pv * 100, 2), '%')  as pv_to_favcart,
       concat(round(sum_buy / sum_pv * 100, 2), '%')               as pv_to_buy,
       concat(round(sum_buy / (sum_fav + sum_cart) * 100, 2), '%') as favcart_to_buy
from (
         select sum_pv, sum_fav, sum_cart, sum_buy
         from (
                  select 'key' as t_key, count(url) as sum_pv
                  from (
                           select url
                           from web_action_log
                           union all
                           select url
                           from app_action_log
                       ) as temp1
              ) as t1
                  left join (
             select 'key'                                                 as t_key,
                    sum(case when action_type = 'fav' then 1 else 0 end)  as sum_fav,
                    sum(case when action_type = 'cart' then 1 else 0 end) as sum_cart
             from behavior_log
         ) as t2
                            on t1.t_key = t2.t_key
                  left join (
             select 'key'                  as t_key,
                    count(order_detail_no) as sum_buy
             from dim_order_info as m_order
                      inner join fact_order_detail_info as detail
                                 on detail.order_no = m_order.order_no
         ) as t3
                            on t1.t_key = t3.t_key
     ) as temp2
;

-- method2
with t1 -- 总访问量
         as (select 'key'      as t_key,
                    count(url) as sum_pv
             from (
                      select url
                      from web_action_log
                      union all
                      select url
                      from app_action_log
                  ) as temp
    ),
     t2 -- 总收藏量、总加购量
         as (select 'key'                                                 as t_key,
                    sum(case when action_type = 'fav' then 1 else 0 end)  as sum_fav,
                    sum(case when action_type = 'cart' then 1 else 0 end) as sum_cart
             from behavior_log),
     t3 -- 总购买量
         as (select 'key'                  as t_key,
                    count(order_detail_no) as sum_buy
             from dim_order_info as m_order
                      inner join fact_order_detail_info as detail
                                 on detail.order_no = m_order.order_no)
select concat(round(sum_pv / sum_pv * 100, 2), '%')                as pv_to_pv,
       concat(round((sum_fav + sum_cart) / sum_pv * 100, 2), '%')  as pv_to_favcart,
       concat(round(sum_buy / sum_pv * 100, 2), '%')               as pv_to_buy,
       concat(round(sum_buy / (sum_fav + sum_cart) * 100, 2), '%') as favcart_to_buy
from t1
         inner join t2
                    on t1.t_key = t2.t_key
         inner join t3
                    on t1.t_key = t3.t_key
;
