/*
Для каждого дня рассчитайте следующие показатели:

Выручку, полученную в этот день.
Выручку с заказов новых пользователей, полученную в этот день.
Долю выручки с заказов новых пользователей в общей выручке, полученной за этот день.
Долю выручки с заказов остальных пользователей в общей выручке, полученной за этот день.
Колонки с показателями назовите соответственно revenue, new_users_revenue, new_users_revenue_share, old_users_revenue_share. 
Колонку с датами назовите date. 

Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.
Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, revenue, new_users_revenue, new_users_revenue_share, old_users_revenue_share
*/

with R1 as (select min_date, sum(price) as new_users_revenue
FROM
(with t1 as (SELECT creation_time::date as date,
                   unnest(product_ids) as product_id,
                   order_id
            FROM   orders
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')), 
t2 as (SELECT product_id, price
    FROM   products),
t3 as (SELECT min_date, order_id
                           FROM   (SELECT time::date as date,
                                          min(time::date) OVER(PARTITION BY user_id) as min_date,
                                          user_id,
                                          order_id
                                   FROM   user_actions) t1
                           WHERE  order_id not in (SELECT order_id
                                                   FROM   user_actions
                                                   WHERE  action = 'cancel_order')
                              and date = min_date
                           GROUP BY min_date, order_id
                           ORDER BY min_date)
select min_date, t3.order_id, t1.product_id, t2.price
from t3
left join t1 using (order_id)
left join t2 on t1.product_id = t2.product_id) W1
group by min_date),
R2 as (SELECT creation_time::date as date,
               sum(price) as revenue
        FROM   (SELECT creation_time,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) t1
            LEFT JOIN products using (product_id)
        GROUP BY date)
select R2.date, revenue, new_users_revenue, round(new_users_revenue::decimal/revenue*100,2) as new_users_revenue_share,
round((revenue - new_users_revenue)::decimal/revenue*100,2) as old_users_revenue_share
from R1
left join R2 
on R1.min_date = R2.date
