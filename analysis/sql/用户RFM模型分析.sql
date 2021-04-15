-- 用户RFM模型分析
-- 每个用户的R、F、M评分
-- 每个用户的R评分(R：最近一次购买时间)
select m_order.person_id as id,
       (case
            when datediff(max(m_order.created_time), now()) <= 30 then 5
            when datediff(max(m_order.created_time), now()) <= 90 then 4
            when datediff(max(m_order.created_time), now()) <= 180 then 3
            when datediff(max(m_order.created_time), now()) <= 365 then 2
            else 1
           end)          as r_score
from dim_order_info as m_order
         inner join fact_detail_info as detail
                    on m_order.order_no = detail.order_no
group by m_order.person_id
;

-- 每个用户的F评分(F：消费频率，客户从去年至今的消费次数)
select m_order.person_id as id,
       (case
            when count(m_order.order_no) >= 100 then 5
            when count(m_order.order_no) >= 50 then 4
            when count(m_order.order_no) >= 25 then 3
            when count(m_order.order_no) >= 10 then 2
            else 1
           end)          as f_score
from dim_order_info as m_order
         inner join fact_detail_info as detail
                    on m_order.order_no = detail.order_no
where created_time between 20200101 and now()
group by m_order.person_id
;

-- 每个用户的M评分(M：消费金额，客户从去年至今的消费金额)
select m_order.person_id as id,
       (case
            when count(price) >= 500000 then 5
            when count(price) >= 100000 then 4
            when count(price) >= 50000 then 3
            when count(price) >= 10000 then 2
            else 1
           end)          as m_score
from dim_order_info as m_order
         inner join fact_detail_info as detail
                    on m_order.order_no = detail.order_no
where created_time between 20200101 and now()
group by m_order.person_id
;

-- 所有用户的R、F、M平均分
-- 所有用户R平均分
select avg(r_score)
from (
         select m_order.person_id,
                (case
                     when datediff(max(m_order.created_time), now()) <= 30 then 5
                     when datediff(max(m_order.created_time), now()) <= 90 then 4
                     when datediff(max(m_order.created_time), now()) <= 180 then 3
                     when datediff(max(m_order.created_time), now()) <= 365 then 2
                     else 1
                    end)          as r_score
         from dim_order_info as m_order
                  inner join fact_detail_info as detail
                             on m_order.order_no = detail.order_no
         group by m_order.person_id
     ) as person_r
;

-- 所有用户F平均分
select avg(f_score)
from (
         select m_order.person_id,
                (case
                     when count(m_order.order_no) >= 100 then 5
                     when count(m_order.order_no) >= 50 then 4
                     when count(m_order.order_no) >= 25 then 3
                     when count(m_order.order_no) >= 10 then 2
                     else 1
                    end) as f_score
         from dim_order_info as m_order
                  inner join fact_detail_info as detail
                             on m_order.order_no = detail.order_no
         where created_time between 20200101 and now()
         group by m_order.person_id
     ) as person_f
;

-- 所有用户M平均分
select avg(m_score)
from (
         select m_order.person_id,
                (case
                     when count(price) >= 500000 then 5
                     when count(price) >= 100000 then 4
                     when count(price) >= 50000 then 3
                     when count(price) >= 10000 then 2
                     else 1
                    end) as m_score
         from dim_order_info as m_order
                  inner join fact_detail_info as detail
                             on m_order.order_no = detail.order_no
         where created_time between 20200101 and now()
         group by m_order.person_id
     ) as person_m
;

-- R、F、M三个评分维度会细分出5x5x5=125类用户，而实际运用上，我们只需要把每个维度做一次两分即可，这样在3个维度上我们可以得到8组用户
-- 每个用户的RFM评分
select id, concat(r_score2, f_score2, m_score2) as rfm_score
from (
         -- 每个用户的第二次R评分
         select id,
                if(r_score1 > avg(r_score), 1, 0) as r_score2
         from (
                  -- 每个用户的第一次R评分
                  select m_order.person_id as id,
                         (case
                              when datediff(max(m_order.created_time), now()) <= 30 then 5
                              when datediff(max(m_order.created_time), now()) <= 90 then 4
                              when datediff(max(m_order.created_time), now()) <= 180 then 3
                              when datediff(max(m_order.created_time), now()) <= 365 then 2
                              else 1
                             end)          as r_score1
                  from dim_order_info as m_order
                           inner join fact_detail_info as detail
                                      on m_order.order_no = detail.order_no
                  group by m_order.person_id
              ) as r1
     ) as r2
         inner join (
    -- 每个用户的第二次F评分
    select id,
           if(f_score1 > avg(f_score), 1, 0) as f_score2
    from (
             -- 每个用户的第一次F评分
             select m_order.person_id as id,
                    (case
                         when count(m_order.order_no) >= 100 then 5
                         when count(m_order.order_no) >= 50 then 4
                         when count(m_order.order_no) >= 25 then 3
                         when count(m_order.order_no) >= 10 then 2
                         else 1
                        end)          as f_score
             from dim_order_info as m_order
                      inner join fact_detail_info as detail
                                 on m_order.order_no = detail.order_no
             where created_time between 20200101 and now()
             group by m_order.person_id
         ) as f1
) as f2
                    on r2.id = f2.id
         inner join (
    -- 每个用户的第二次M评分
    select id,
           if(m_score1 > avg(m_score), 1, 0) as m_score2
    from (
             -- 每个用户的第一次M评分
             select m_order.person_id,
                    (case
                         when count(price) >= 500000 then 5
                         when count(price) >= 100000 then 4
                         when count(price) >= 50000 then 3
                         when count(price) >= 10000 then 2
                         else 1
                        end) as m_score
             from dim_order_info as m_order
                      inner join fact_detail_info as detail
                                 on m_order.order_no = detail.order_no
             where created_time between 20200101 and now()
             group by m_order.person_id
         ) as m1
) as m2
                    on r2.id = m2.id
;

-- 重要价值客户（111）：最近消费时间近、消费频次和消费金额都很高，必须是VIP
-- 重要保持客户（011）：最近消费时间较远，但消费频次和金额都很高，说明这是个一段时间没来的忠诚客户，我们需要主动和他保持联系
-- 重要发展客户（101）：最近消费时间较近、消费金额高，但频次不高，忠诚度不高，很有潜力的用户，必须重点发展
-- 重要挽留客户（001）：最近消费时间较远、消费频次不高，但消费金额高的用户，可能是将要流失或者已经要流失的用户，应当给予挽留措施
-- 普通客户 (100、110、000、010)

-- 根据RFM评分对客户进行分类
select id,
       (case
            when rfm_score = '111' then '重要价值客户'
            when rfm_score = '011' then '重要保持客户'
            when rfm_score = '101' then '重要发展客户'
            when rfm_score = '001' then '重要挽留客户'
            else '普通客户'
           end) as 客户分类
from (
         -- 每个客户对RFM评分
         select id, concat(r_score2, f_score2, m_score2) as rfm_score
         from (
                  -- 每个用户的第二次R评分
                  select id,
                         if(r_score1 > avg(r_score), 1, 0) as r_score2
                  from (
                           -- 每个用户的第一次R评分
                           select m_order.person_id as id,
                                  (case
                                       when datediff(max(m_order.created_time), now()) <= 30 then 5
                                       when datediff(max(m_order.created_time), now()) <= 90 then 4
                                       when datediff(max(m_order.created_time), now()) <= 180 then 3
                                       when datediff(max(m_order.created_time), now()) <= 365 then 2
                                       else 1
                                      end)          as r_score1
                           from dim_order_info as m_order
                                    inner join fact_detail_info as detail
                                               on m_order.order_no = detail.order_no
                           group by m_order.person_id
                       ) as r1
              ) as r2
                  inner join (
             -- 每个用户的第二次F评分
             select id,
                    if(f_score1 > avg(f_score), 1, 0) as f_score2
             from (
                      -- 每个用户的第一次F评分
                      select m_order.person_id as id,
                             (case
                                  when count(m_order.order_no) >= 100 then 5
                                  when count(m_order.order_no) >= 50 then 4
                                  when count(m_order.order_no) >= 25 then 3
                                  when count(m_order.order_no) >= 10 then 2
                                  else 1
                                 end)          as f_score
                      from dim_order_info as m_order
                               inner join fact_detail_info as detail
                                          on m_order.order_no = detail.order_no
                      where created_time between 20200101 and now()
                      group by m_order.person_id
                  ) as f1
         ) as f2
                             on r2.id = f2.id
                  inner join (
             -- 每个用户的第二次M评分
             select id,
                    if(m_score1 > avg(m_score), 1, 0) as m_score2
             from (
                      -- 每个用户的第一次M评分
                      select m_order.person_id,
                             (case
                                  when count(price) >= 500000 then 5
                                  when count(price) >= 100000 then 4
                                  when count(price) >= 50000 then 3
                                  when count(price) >= 10000 then 2
                                  else 1
                                 end) as m_score
                      from dim_order_info as m_order
                               inner join fact_detail_info as detail
                                          on m_order.order_no = detail.order_no
                      where created_time between 20200101 and now()
                      group by m_order.person_id
                  ) as m1
         ) as m2
                             on r2.id = m2.id
     ) as rfm
;
