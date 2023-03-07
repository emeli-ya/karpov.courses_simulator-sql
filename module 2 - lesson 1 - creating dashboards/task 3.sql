/*
Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

Число платящих пользователей.
Число активных курьеров.
Долю платящих пользователей в общем числе пользователей на текущий день.
Долю активных курьеров в общем числе курьеров на текущий день.
Колонки с показателями назовите соответственно paying_users, active_couriers, paying_users_share, active_couriers_share. 
Колонку с датами назовите date. Проследите за тем, чтобы абсолютные показатели были выражены целыми числами. Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты. 

Поля в результирующей таблице: date, paying_users, active_couriers, paying_users_share, active_couriers_share
*/

with t1 as (select time::date as date, count(distinct user_id) as paying_users 
     from user_actions
     where action = 'create_order' and order_id not in (select order_id from user_actions where action = 'cancel_order')
     group by date
     order by date),
t2 as (select time::date as date, count(distinct courier_id) as active_couriers
     from courier_actions
     where (action = 'accept_order' or action = 'deliver_order') and order_id not in (select order_id from user_actions where action = 'cancel_order')
     group by date
     order by date),
t3 as (SELECT date,
       (sum(new_users) OVER (ORDER BY date))::int as total_users,
       (sum(new_couriers) OVER (ORDER BY date))::int as total_couriers
FROM   (SELECT date,
               count(courier_id) as new_couriers
        FROM   (SELECT courier_id,
                       min(time::date) as date
                FROM   courier_actions
                GROUP BY courier_id) t1
        GROUP BY date) t2
    LEFT JOIN (SELECT date,
                      count(user_id) as new_users
               FROM   (SELECT user_id,
                              min(time::date) as date
                       FROM   user_actions
                       GROUP BY user_id) t3
               GROUP BY date) t4 using (date))
select t1.date, paying_users, active_couriers, round(paying_users::decimal/total_users*100,2) as paying_users_share,
round(active_couriers::decimal/total_couriers*100,2) as active_couriers_share
from t1 
join t2 on t1.date = t2.date 
join t3 on t1.date = t3.date
