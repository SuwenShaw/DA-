-- 购买率高和购买量高的用户特征
-- 购买率前20的用户特征
select person_id,
       is_member,
       gender,
       province,
       city
from fact_person_info as person
         inner join (
    -- 筛选出购买率前20的用户
    select user_id,
           concat(round(sum_buy / sum_pv * 100, 2), '%') as pv_to_buy
    from (
             select user_id, sum_pv, sum_buy
             from (
                      -- 各用户访问量
                      select user_id, count(url) as sum_pv
                      from (
                               select url
                               from web_action_log
                               union all
                               select url
                               from app_action_log
                           ) as temp1
                      group by user_id
                  ) as t1
                      left join (
                 -- 各用户购买量
                 select detail.person_id as id,
                        count(order_detail_no) as sum_buy
                 from dim_order_info as m_order
                          inner join fact_order_detail_info as detail
                                     on detail.order_no = m_order.order_no
                 group by detail.person_id
             ) as t3
                                on t1.user_id = t3.id
         ) as temp2
    order by pv_to_buy desc
    limit 20
) as user
                    on person.person_id = user.user_id
;

-- 购买量前20的用户特征
select person_id,
       is_member,
       gender,
       province,
       city
from fact_person_info as person
         inner join (
    -- 筛选出购买量前20的用户
    select detail.person_id as id,
           count(order_detail_no) as sum_buy
    from dim_order_info as m_order
             inner join fact_order_detail_info as detail
                        on detail.order_no = m_order.order_no
    group by detail.person_id
    order by sum_buy desc
    limit 20
) as temp
                    on person.person_id = temp.id
;
