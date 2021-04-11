-- 用户行为时间维度分析
-- 一天中各个时段用户活跃度排序
select hour(visit_time) as 时段, count(url) as 访问量
from (
         select hour(visit_time), url
         from web_action_log
         union all
         select hour(visit_time), url
         from app_action_log
     ) as temp
group by hour(visit_time)
order by hour(visit_time) desc
;

-- 一周中每天用户活跃度排序
select date_format(visit_time, '%W') as 星期, count(url) as 访问量
from (
         select date_format(visit_time, '%W'), url
         from web_action_log
         union all
         select date_format(visit_time, '%W'), url
         from app_action_log
     ) as temp
group by date_format(visit_time, '%W')
order by date_format(visit_time, '%W') desc
;

-- 一月中每天用户活跃度排序
select day(visit_time) as 日期, count(url) as 访问量
from (
         select day(visit_time), url
         from web_action_log
         union all
         select day(visit_time), url
         from app_action_log
     ) as temp
group by day(visit_time)
order by day(visit_time) desc
;