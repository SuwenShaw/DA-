-- 整体用户购物情况
-- PV（总访问量）、日均访问量
select count(url) as 总访问量, count(url) / (datediff(max(visit_time), min(visit_time)) + 1) as 日均访问量
from (
         select visit_time, url
         from web_action_log
         union all
         select visit_time, url
         from app_action_log
     ) as temp
;

-- 每日访问量
select day(visit_time), count(url) as 日访问量
from (
         select day(visit_time), url
         from web_action_log
         union all
         select day(visit_time), url
         from app_action_log
     ) as temp
group by day(visit_time)
;

-- 总用户数
select count(distinct person_id) as 总用户数
from fact_person_info
;

-- 有购买行为的用户数
select count(distinct detail.person_id) as 购买用户数
from dim_order_info as m_order
         inner join fact_order_detail_info as detail
                    on detail.order_no = m_order.order_no
;

-- 潜客数
select count(distinct person.person_id) as 潜客数
from fact_person_info as person
         left join (
    select detail.person_id as person_id
    from dim_order_info as m_order
             inner join fact_order_detail_info as detail
                        on detail.order_no = m_order.order_no
) as temp
                   on person.person_id = temp.person_id
where temp.person_id is null
;

-- 店铺购买人数
select detail.store, count(distinct detail.person_id) as 购买人数
from dim_order_info as m_order
         inner join fact_order_detail_info as detail
                    on detail.order_no = m_order.order_no
group by detail.store
;

-- 店铺复购人数
select detail.store, count(distinct detail.person_id) as 复购人数
from (
         select detail.person_id,
                detail.store,
                count(distinct detail.order_no) as order_num
         from dim_order_info as m_order
                  inner join fact_order_detail_info as detail
                             on detail.order_no = m_order.order_no
         group by detail.person_id,
                  detail.store
     ) as temp
where order_num >= 2
group by detail.store
;

-- 店铺购买人数、复购人数、复购率
select buying.detail.store as store,buy_num as 购买人数,rebuy_num as 复购人数,concat(round((rebuy_num / buy_num) * 100, 2), '%') as 复购率
from (
         select detail.store,
                count(distinct detail.person_id) as buy_num
         from dim_order_info as m_order
                  inner join fact_order_detail_info as detail
                             on detail.order_no = m_order.order_no
         group by detail.store
     ) as buying
         inner join (
    select detail.store,
           count(distinct detail.person_id) as rebuy_num
    from (
             select detail.person_id,
                    detail.store,
                    count(distinct detail.order_no) as order_num
             from dim_order_info as m_order
                      inner join fact_order_detail_info as detail
                                 on detail.order_no = m_order.order_no
             group by detail.person_id, detail.store
         ) as temp
    where order_num >= 2
    group by detail.store
) as rebuying
                    on buying.detail.store = rebuying.detail.store
;
